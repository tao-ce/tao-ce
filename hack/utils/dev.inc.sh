set -eux

__hack_dir=$(dirname ${BASH_SOURCE[0]})
. ${__hack_dir}/composer.inc.sh
. ${__hack_dir}/npm.inc.sh
. ${__hack_dir}/data.inc.sh
unset __hack_dir
