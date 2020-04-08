#!/usr/bin/env bash

faketty () {
    script -qefc "$(printf "%q " "$@")"
}

# extend root partition
sudo apt-get install -y parted
faketty sudo parted /dev/vda resizepart 1 yes 100% print
sudo resize2fs /dev/vda1

# install basic tools
sudo apt-get install -y vim numactl

# install required packages
sudo apt-get install -y kernel-package fakeroot
sudo apt-get install -y git

# checkout kernel tree
[ -d linux-replication ] || \
    git clone https://github.com/oaken-source/linux-replication.git
cd linux-replication/ || exit
git checkout replication-v3.9

# configure
[ -f .config ] || (
  cp -v config-bench .config
  make olddefconfig
)

# build
faketty make-kpkg clean
faketty fakeroot make-kpkg --initrd --revision=3.9.replication kernel_image

# install
sudo dpkg -i ../linux-image-3.9.0-replication+_3.9.replication_amd64.deb

# configure grub to use the kernel
sudo sed -i 's|^GRUB_DEFAULT=.*|GRUB_DEFAULT="Advanced options for Debian GNU/Linux>Debian GNU/Linux, with Linux 3.9.0-replication+"|' /etc/default/grub
sudo update-grub

# needs a reboot now!
echo "setup complete. reboot now!"
