construct_is_ready() {
    [ -f "${app_ready_sem}" ]
}

construct_is_installed() {
    [ -f "${app_install_sem}" ]
}

construct_init() {
    cd $app_path

    mkdir -p \
        ${app_data_path}/data \
        ${app_data_path}/config \
        ${app_data_path}/locales

    chown -R ${TAO_USER}:${TAO_GROUP} $app_data_path
}

construct_wait() {
    backoff_to_ramp="1,1,1,1,2,2,2,5,5,5,5,5,5,5,5,5,10,30,60"

    bti=1

    while sleep ${bto:-1} ; do

        [ ${bti} -le 20 ] && {
            bto=$(echo $backoff_to_ramp | cut -f${bti} -d,) 
            bti=$(( ${bti} + 1 ))
        } || bto=60


        case $1 in
            install)
                construct_is_installed && break
                _info "${app_name} not installed, waiting for installation..."
            ;;
            ready)
                construct_is_ready && break
                _info "${app_name} not ready, waiting for update..."
            ;;
        esac
    done
}

construct_replace_generis() {
    const_name=$1
    const_value=$2
    const_type=${3:-string}

    case $const_type in
        string)
            const_value="'"${const_value}"'"
        ;;
        number)
            const_value=${const_value}
        ;;
    esac



    _info "Update ${const_name} in ${app_data_path}/config/generis.conf.php to ${const_value}"
    gosu ${TAO_USER} \
        sed -i \
            -e "s@^define[(]'$const_name'[ ]*,.*@define('$const_name',$const_value); // overwritten by $0 on $(date -Ins -u)@" \
            $app_data_path/config/generis.conf.php
}

construct_config() {
    construct_wait ready

    construct_replace_generis ROOT_URL ${config_base_url}
    construct_replace_generis TIME_ZONE ${config_tz}
    construct_replace_generis DEFAULT_LANG ${config_lang}
    construct_replace_generis DEFAULT_ANONYMOUS_INTERFACE_LANG ${config_lang}
}

construct_update() {
    construct_wait install

    rm -f ${app_ready_sem}

    gosu ${TAO_USER} \
        php tao/scripts/taoUpdate.php

    _sem "${app_ready_sem}"
}

construct_run() {
    construct_wait install
    construct_wait ready

    construct_config

    _info "Starting ${app_name} on ${config_base_url} "

    php-fpm -O -y ${TAOADM_CONFIG}/apps/construct.fpm.ini
}

construct_worker() {
    construct_wait ready

    construct_config

    _info "Starting ${app_name} worker on ${config_base_url}"

    supercronic -passthrough-logs -quiet ${TAOADM_CONFIG}/apps/construct.crontab
}

construct_install() {
    force_install=0

    while getopts ":F" o; do
        case $o in
            F)
                _warn "Forcing install, current installation will be overwritten (^C now to cancel)..."
                force_install=1
                sleep 10
            ;;
            ?)
                _fail "No such option -${OPTARG}."
            ;;
        esac
    done

    set -e

    construct_is_installed && {
        [ $force_install -eq 0 ] \
            && _fail "${app_name} already installed, use '-F' option to overwrite (DATA IN $app_data_path AND DATABASE IN pgsql WILL BE LOST)" \
            || _warn "${app_name} starting"
    }


    gosu ${TAO_USER} \
        php tao/scripts/taoSetup.php \
            ${TAOADM_CONFIG}/init/construct-seed.json

    gosu ${TAO_USER} \
        php  index.php 'oat\\tao\\scripts\\tools\\UpdateDeliverConnectConfig'

    gosu ${TAO_USER} \
        php index.php 'oat\\taoAdvancedSearch\\scripts\\tools\\IndexCreator'

    _sem "${app_install_sem}"
    construct_update
}
