#!/bin/bash
set -x                         # tell sh to display commands before execution
echo "Starting....."

logFileName="/var/log/clusterdefault.log"
touch $logFileName

# Send all as a redirect , but then tee so we can see logs and output
exec &> >(tee -a "$logFileName")

set -eo pipefail
read_os()
{
    os_release=$(cat /etc/os-release | grep "^ID\=" | cut -d'=' -f 2 | xargs)
    os_maj_ver=$(cat /etc/os-release | grep "^VERSION_ID\=" | cut -d'=' -f 2 | xargs)
    full_version=$(cat /etc/os-release | grep "^VERSION\=" | cut -d'=' -f 2 | xargs)
}

read_os
case $os_release in
    almalinux)
        logger -s  "Not Implemented"
        exit 0
        ;;
    ubuntu)
        #no terminal

        apt-get update
        apt-get install -y moreutils nethogs 
        exit 0
        ;;
    *)
        logger -s "Untested OS $os_release $os_version"
        exit 0
        ;;
esac
