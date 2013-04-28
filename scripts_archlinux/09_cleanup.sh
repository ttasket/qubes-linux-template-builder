#!/bin/sh

set -e

echo "Mounting archlinux install system into mnt_archlinux_dvd..."
sudo mount $CACHEDIR/root-image.fs mnt_archlinux_dvd

echo "--> Starting cleanup actions"
# Remove unused packages and their dependencies (make dependencies)
cleanuppkgs=`sudo ./mnt_archlinux_dvd/usr/bin/arch-chroot $INSTALLDIR pacman -Qdt | cut -d " " -f 1`
echo "--> Packages that can be cleaned up: $cleanuppkgs"
if [ -n "$cleanuppkgs" ] ; then
	sudo ./mnt_archlinux_dvd/usr/bin/arch-chroot $INSTALLDIR pacman --noconfirm -Rsc $cleanuppkgs
fi

# Remove non required linux kernel
echo "--> Cleaning up linux kernel"
sudo ./mnt_archlinux_dvd/usr/bin/arch-chroot $INSTALLDIR pacman --noconfirm -Rsc linux
sudo ./mnt_archlinux_dvd/usr/bin/arch-chroot $INSTALLDIR pacman --noconfirm -S linux-firmware

# Clean pacman cache
sudo ./mnt_archlinux_dvd/usr/bin/arch-chroot $INSTALLDIR pacman --noconfirm -Scc

sudo umount mnt_archlinux_dvd

#rm -f $INSTALLDIR/var/lib/rpm/__db.00* $INSTALLDIR/var/lib/rpm/.rpm.lock
#yum -c $PWD/yum.conf $YUM_OPTS clean packages --installroot=$INSTALLDIR

# Make sure that rpm database has right format (for rpm version in template, not host)
#echo "--> Rebuilding rpm database..."
#chroot `pwd`/mnt /bin/rpm --rebuilddb 2> /dev/null
