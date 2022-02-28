#!/bin/bash
git clone git://git.sv.gnu.org/emacs.git
sudo apt install build-essential libgtk-3-dev libgnutls28-dev libtiff5-dev libgif-dev libjpeg-dev libpng-dev libxpm-dev libncurses-dev texinfo libgccjit0 libgccjit-10-dev gcc-10 g++-10 libjansson4 libjansson-dev autoconf
export CC=/usr/bin/gcc-10 CXX=/usr/bin/gcc-10
cd emacs
./autogen.sh
./configure --with-pgtk --with-json --with-native-compilation
make -j8
sudo make install
cd ..
rm -rf emacs
hostnamectl set-hostname kanon
sudo apt update
sudo apt full-upgrade
ln -s /mnt/c/Users/juane/proyectos ~/proyectos
ln -s /mnt/c/Users/juane/personal ~/personal
ln -s /mnt/c/Users/juane/biblioteca ~/biblioteca
ln -s /mnt/c/Users/juane/puj ~/puj
ln -s /mnt/c/Users/juane/img ~/img
ln -s /mnt/c/Users/juane/Downloads ~/Downloads
ln -s /mnt/c/Users/juane/org-roam ~/org-roam
rm -rf ~/.emacs.d

sudo apt install qutebrowser.
