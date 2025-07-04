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
        env | sort
        id 
        pwd
        script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
        # check service file is there
        if [ ! -f /shared/home/hpcadmin/.config/systemd/user/rclone@.service ]; then
            logger -s "Rclone configuration file not found. "
            mkdir -p  /shared/home/hpcadmin/.config/systemd/user
            cp $script_dir/../files/ubuntu/rclone@.service /shared/home/hpcadmin/.config/systemd/user/rclone@.service || true
       
        fi
        
        chown -R hpcadmin:hpcadmin /shared/home/hpcadmin/.config/systemd
        #Incase rclone has already mounted
        if [ ! -d /mnt/dropbox ]; then
            mkdir -p /mnt/dropbox || true
        fi
        chown hpcadmin:hpcadmin /mnt/dropbox
        chmod 755 /mnt/dropbox
        # sudo -u hpcadmin  'systemctl --user daemon-reload' || true
        systemctl --user daemon-reload --machine=hpcadmin@.host --user
        # machinectl --user enable --now rclone@dropbox || true
        # sudo -u hpcadmin 'systemctl --user enable --now rclone@dropbox' || true
        systemctl --user enable --now rclone@dropbox --machine=hpcadmin@.host --user
        # su - hpcadmin -c 'rclone mount DB:/ /mnt/dropbox --daemon --links --vfs-cache-mode=full --vfs-cache-max-age 24h0m0s --vfs-fast-fingerprint --vfs-read-ahead 128M --transfers 16 --vfs-read-chunk-size 128M --buffer-size 256M --vfs-read-chunk-streams 32 --config="/shared/home/hpcadmin/.config/rclone/rclone.conf"'

        exit 0
        # fi
        # exit 0
        ;;
    *)
        logger -s "Untested OS $os_release $os_version"
        exit 0
        ;;
esac
