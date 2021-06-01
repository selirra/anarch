install_create_dir()
{
	decoration_message _ "Creating \"anarch\" directory at your device's root..."
	
	mount -o rw,remount /
	mkdir /anarch
	mount -o ro,remount /
}

install_base()
{
	decoration_message _ "Starting installation..."
	decoration_text_centered "Do not turn off your device!"

	mkdir -p $settings_installpath/root/sdcard
	cd $settings_installpath
	wget -O archlinuxarm.tar.gz http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz
	cd $settings_installpath/root

	decoration_message _ "Extracting the rootfs, this might take a while..."
	tar -xf $settings_installpath/archlinuxarm.tar.gz
	rm $settings_installpath/archlinuxarm.tar.gz
	cd $settings_installpath
}

install_profile()
{
	decoration_message _ "Setting up your profile..."

	rm $settings_installpath/root/etc/resolv.conf
	echo "nameserver 8.8.8.8" > $settings_installpath/root/etc/resolv.conf
	echo "export HOME=/root" >> $settings_installpath/root/etc/profile
	echo "unset LD_PRELOAD" >> $settings_installpath/root/etc/profile
	echo "cd ~" >> $settings_installpath/root/etc/profile
}

install_mount()
{
	decoration_message _ "Mounting the filesystem..."

	mount -o bind /dev $settings_installpath/root/dev
	mkdir -p $settings_installpath/root/dev/shm
	mount -t proc proc $settings_installpath/root/proc
	mount -t sysfs sysfs $settings_installpath/root/sys
	mount -t tmpfs tmpfs $settings_installpath/root/tmp
	mount -t tmpfs tmpfs $settings_installpath/root/dev/shm
	mount -t devpts devpts $settings_installpath/root/dev/pts
}

install_mount_internal()
{
    decoration_message _ "Mounting your internal storage..."
	
	mount -o bind /sdcard $settings_installpath/root/sdcard
}

install_scripts()
{
	decoration_message _ "Creating startup scripts..."

	echo "#!/bin/bash" > $settings_installpath/mount_anarch
	echo "mount -o bind /dev $settings_installpath/root/dev" >> $settings_installpath/mount_anarch
	echo "mkdir -p $settings_installpath/root/dev/shm" >> $settings_installpath/mount_anarch
	echo "mount -t proc  proc $settings_installpath/root/proc" >> $settings_installpath/mount_anarch
	echo "mount -t sysfs sysfs $settings_installpath/root/sys" >> $settings_installpath/mount_anarch
	echo "mount -t tmpfs tmpfs $settings_installpath/root/tmp" >> $settings_installpath/mount_anarch
	echo "mount -t tmpfs tmpfs $settings_installpath/root/dev/shm" >> $settings_installpath/mount_anarch
	echo "mount -t devpts devpts $settings_installpath/root/dev/pts" >> $settings_installpath/mount_anarch
    if [ $settings_mountstorage = "yes" ]
	then
		echo "mount -o bind /sdcard $settings_installpath/root/sdcard" >> $settings_installpath/mount_anarch
	fi
	
	echo "#!/bin/bash" > $settings_installpath/unmount_anarch
	if [ $settings_mountstorage = "yes" ]
	then
		echo "umount -l $settings_installpath/root/sdcard" >> $settings_installpath/unmount_anarch
	fi	
	echo "umount -l $settings_installpath/root/dev/pts" >> $settings_installpath/unmount_anarch
	echo "umount -l $settings_installpath/root/dev/shm" >> $settings_installpath/unmount_anarch
	echo "umount -l $settings_installpath/root/tmp" >> $settings_installpath/unmount_anarch
	echo "umount -l $settings_installpath/root/sys" >> $settings_installpath/unmount_anarch
	echo "umount -l $settings_installpath/root/proc" >> $settings_installpath/unmount_anarch
	echo "umount -l $settings_installpath/root/dev" >> $settings_installpath/unmount_anarch

	echo "#!/bin/bash" > $settings_installpath/start_anarch
	echo "chroot $settings_installpath/root /bin/bash -l" >> $settings_installpath/start_anarch
}

install_misc()
{
	decoration_message _ "Setting up the keyring, package manager, and servicectl..."

	sed -i 's/#IgnorePkg   =/IgnorePkg   = linux-aarch64 linux-firmware/' $settings_installpath/root/etc/pacman.conf
	sed -i 's/CheckSpace/#CheckSpace/' $settings_installpath/root/etc/pacman.conf

	echo "#!/bin/bash" > $settings_installpath/root/tmp/delete_stuff
	echo "pacman -Rs linux-aarch64 linux-firmware --noconfirm" >> $settings_installpath/root/tmp/delete_stuff
	echo "exit" >> $settings_installpath/root/tmp/delete_stuff
	chroot $settings_installpath/root bash /tmp/delete_stuff

	echo "#!/bin/bash" > $settings_installpath/root/tmp/keyring_setup
	echo "pacman-key --init" >> $settings_installpath/root/tmp/keyring_setup
	echo "pacman-key --populate" >> $settings_installpath/root/tmp/keyring_setup
	echo "pacman -Sy archlinux-keyring archlinuxarm-keyring --noconfirm" >> $settings_installpath/root/tmp/keyring_setup
	echo "pacman -Su --noconfirm" >> $settings_installpath/root/tmp/keyring_setup
	echo "exit" >> $settings_installpath/root/tmp/keyring_setup
	chroot $settings_installpath/root bash /tmp/keyring_setup

	echo "#!/bin/bash" > $settings_installpath/root/tmp/misc_setup
	echo "pacman -S nano base-devel wget git tigervnc --noconfirm" >> $settings_installpath/root/tmp/misc_setup
	echo "exit" >> $settings_installpath/root/tmp/misc_setup
	chroot $settings_installpath/root bash /tmp/misc_setup

	echo "#!/bin/bash" > $settings_installpath/root/tmp/servicectl_setup
	echo "cd /tmp" >> $settings_installpath/root/tmp/servicectl_setup
	echo "wget -O a.tar.gz https://github.com/selirra/servicectl/archive/1.0.tar.gz" >> $settings_installpath/root/tmp/servicectl_setup
	echo "tar -xf a.tar.gz -C /usr/local/lib/" >> $settings_installpath/root/tmp/servicectl_setup
	echo "ln -s /usr/local/lib/servicectl-1.0/servicectl /usr/local/bin/servicectl" >> $settings_installpath/root/tmp/servicectl_setup
	echo "ln -s /usr/local/lib/servicectl-1.0/serviced /usr/local/bin/serviced" >> $settings_installpath/root/tmp/servicectl_setup
	echo "rm a.tar.gz" >> $settings_installpath/root/tmp/servicectl_setup
	echo "exit" >> $settings_installpath/root/tmp/servicectl_setup
	chroot $settings_installpath/root bash /tmp/servicectl_setup

	rm -rf $settings_installpath/root/tmp/delete_stuff
	rm -rf $settings_installpath/root/tmp/keyring_setup
	rm -rf $settings_installpath/root/tmp/misc_setup
	rm -rf $settings_installpath/root/tmp/servicectl_setup
}