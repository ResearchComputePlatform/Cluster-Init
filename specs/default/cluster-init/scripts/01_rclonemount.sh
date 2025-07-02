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
        ;;
    ubuntu)
        #no terminal
        # check if rclone fonfig file exists
        if [ -f /shared/home/hpcadmin/.config/rclone/rclone.conf ]; then
            logger -s "Rclone configuration file found. "
            mkdir /mnt/Dropbox
            chown hpcadmin:hpcadmin /mnt/Dropbox
            chmod 755 /mnt/Dropbox
            rclone mount DB:/ /mnt/Dropbox --daemon --links --vfs-cache-mode=full --vfs-cache-max-age 24h0m0s --vfs-fast-fingerprint --vfs-read-ahead 128M --transfers 16 --vfs-read-chunk-size 128M --buffer-size 256M --vfs-read-chunk-streams 32 &

            exit 0
        fi
        exit 0
        ;;
    *)
        logger -s "Untested OS $os_release $os_version"
        exit 0
        ;;
esac
