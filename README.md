# test


##Update on cycle
<!-- NO git clone https://github.com/ResearchComputePlatform/Cluster-Init.git -->

<!-- "/usr/local/bin/cyclecloud", "project", "fetch", url, folder + ".tmp"]) -->
/usr/local/bin/cyclecloud project fetch https://github.com/ResearchComputePlatform/Cluster-Init .



<!-- check_output(["/usr/local/bin/cyclecloud", "project", "upload", locker], cwd=folder + ".tmp") -->

sudo /usr/local/bin/cyclecloud project upload azure-storage 


USER
systemctl --user enable --now rclone@dropbox



journalctl -u rclone@dropbox -f



 /usr/local/bin/cyclecloud show_cluster