pvresize /dev/vda4
lvresize -L +100G /dev/systemVG/LVRoot
sync
xfs_growfs /dev/mapper/systemVG-LVRoot 
dnf install -y code vim git patch docker docker-compose @xfce-desktop-environment
systemctl enable --now docker
usermod -aG docker geo

sysctl -w fs.inotify.max_user_watches=524288
sysctl -w fs.inotify.max_user_instances=512
sysctl -w net.ipv4.ip_unprivileged_port_start=0



eval $(ssh-agent)
ssh-add
git clone git@github.com:tao-ce/tao-ce.git
patch -p1 < .cache/portal.patch

sudo firewall-cmd --permanent --zone=public --add-port=443/tcp
sudo firewall-cmd --reload
