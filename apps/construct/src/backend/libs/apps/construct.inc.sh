app_data_path=/var/lib/tao-ce/construct



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
    sed -i \
            -e "s@^define[(]'$const_name'[ ]*,.*@define('$const_name',$const_value); // overwritten by $0 on $(date -Ins -u)@" \
            $app_data_path/config/generis.conf.php
}

construct_setup_taoLti() {
    php index.php 'oat\taoLti\scripts\tools\SetupLtiPlatform' \
            -l 'Portal' \
            -cid 'portal-authoring-client-id-1' \
            -did '1' \
            -a   ${PORTAL_BE_BASE_URL} \
            -tu  'http://foo.bar' \
            -ou  ${DELIVERTENANT_0_LTI_1P3_OIDC_LOGIN_INITIATION_URL} \
            -ju  ${DELIVERTENANT_0_LTI_1P3_CREDENTIALS_0_JWKS}
}

construct_replace_taoLti()  {
    sed -i \
            -e "s@^.*'rootUrl'.*@'rootUrl' => '$config_base_url',     // overwritten by $0 on $(date -Ins -u)@" \
            $app_data_path/config/taoLti/Lti1p3RegistrationRepository.conf.php
}   

construct_config() {
    construct_wait ready

    construct_replace_generis ROOT_URL ${config_base_url}
    construct_replace_generis TIME_ZONE ${config_tz}
    construct_replace_generis DEFAULT_LANG ${config_lang}
    construct_replace_generis DEFAULT_ANONYMOUS_INTERFACE_LANG ${config_lang}

    construct_setup_taoLti
    construct_replace_taoLti
}

construct_update() {
    construct_wait install

    rm -f ${app_ready_sem}

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
    silent_skip=0

    while getopts ":Fs" o; do
        case $o in
            F)
                _warn "Forcing install, current installation will be overwritten (^C now to cancel)..."
                force_install=1
                sleep 10
            ;;
            s)
                _warn "Silent skip if TAO is already installed."
                silent_skip=1
            ;;
            ?)
                _fail "No such option -${OPTARG}."
            ;;
        esac
    done

    set -e

    construct_is_installed && {
        [ $silent_skip -eq 1 ] && { 
                _warn "Silent skip ${app_name} installation process..."
                return 0
            } || \
        [ $force_install -eq 0 ] \
            && _fail "${app_name} already installed, use '-F' option to overwrite (DATA IN $app_data_path AND DATABASE IN pgsql WILL BE LOST)" \
            || _warn "${app_name} starting"
    }

    _warn "${app_name} install running..."

    php tao/scripts/taoSetup.php \
        ${TAOADM_CONFIG}/init/construct-seed.json

    php  index.php 'oat\\tao\\scripts\\tools\\UpdateDeliverConnectConfig'
    php index.php 'oat\\taoAdvancedSearch\\scripts\\tools\\IndexCreator'

    _sem "${app_install_sem}"
    construct_update
}
