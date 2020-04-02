#!/usr/bin/env bash

sudo apt install kernel-package fakeroot
sudo apt install git
git clone https://github.com/oaken-source/linux-replication.git
cd linux-replication/
git checkout replication-v3.12
cp -v /boot/config-$(uname -r) .config
make olddefconfig 
make-kpkg clean
fakeroot make-kpkg --initrd --revision=3.12.replication kernel_image
sudo dpkg -i ../linux-image-3.16-subarchitecture_1.0.custom_i386.deb