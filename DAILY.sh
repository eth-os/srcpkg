#!/bin/sh
# DAILY.sh 20120111 markc@renta.net (AGPLv3)
# nohup ionice -c3 nice -n19 sh DAILY.sh > DAILY.log 2>&1 &

PKGS="
  qt-git
  qt-mobility-git
  qt-components-desktop-git
  qt-creator-git
"

DISTRO=eth-os
ARCH=x86_64
START=$(date -u)

. /etc/makepkg.conf

SRC=$SRCDEST/pkg/$DISTRO
BIN=$PKGDEST/pkg/$DISTRO

cd $SRC

for p in $PKGS; do
  PKG=$SRC/$p
  if [ -f $PKG/PKGBUILD ]; then
    cd $PKG
    makepkg -csi --noconfirm && rm *.xz
    cd $SRC
  fi
  sleep 2
done

cd $BIN/$ARCH

for p in $PKGS; do
  if [ -f $PKGDEST/*$p*.xz ]; then
    rm *$p*.xz
    mv $PKGDEST/*$p*.xz .
  fi
done

rm qt-private-headers-git*.xz
mv $PKGDEST/qt-private-headers-git*.xz .

rm eth-os.db.tar.gz
repo-add eth-os.db.tar.gz *.pkg.*

echo $START
date -u
