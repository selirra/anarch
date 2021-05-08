# This script will set up an ArchLinuxARM chroot environment, at "/sdcard/archroot".

## WARNING - READ THE NEXT SECTION BEFORE DOING ANYTHING

I'm not responsible for any damage you *might* do to your device.  
I made this script for my personal use, but i think some people will find it quite useful, so i shared it, but i can't guarantee that it will work properly on every device.  
Make sure to read the script, don't just blindly run random scripts off the internet. :)  
If you wish to delete your archroot folder, make sure to unmount it first.


## Installation guide

Things you need before you can run the installer:  
* A rooted android phone
* Termux
* Git
* Wget
* Bsdtar  

Open Termux, and install the required dependencies, you can skip this step if you already have them installed.  
`pkg upgrade`  
`pkg install git wget bsdtar`  

### Important! The installer script will make an 8GB .img file by default, you can increase it's size by editing the installer script's fifth row! (truncate -s 8G disk.img)

Download, and then run the script as root.  
`git clone https://github.com/selirra/ArchRoot`  
`cd ArchRoot`  
`su`  
`bash archroot_install`  

After the installation finishes, and you are inside the chroot, run these:  
`pacman-key --init && pacman-key --populate`  
`pacman -Sy archlinux-keyring archlinuxarm-keyring && pacman -Su`  

Create a password for the root user with `passwd`.  

Optional: If you want to install kde plasma, run:  
`echo "export $(dbus-launch)" >> /etc/profile`  

If everything went okay, now you should have a working archlinuxarm chroot environment!  
You will find the mount, unmount, and start scripts at "/sdcard/archroot"!  

## Some more info:  

I used this to get around the limitations of systemd in chroot: https://github.com/smaknsk/servicectl  
You can install tigervnc and run `vncserver :0` if you want a vnc server.  

Setting up the locale settings:  
* Edit "/etc/locale.gen" with the text editor of your choice, and uncomment your desired locale.  
* Run `locale-gen`, then run `echo "LANG=en_US.UTF-8" > /etc/locale.conf`. (replace "en_US.UTF-8" with the locale that you uncommented in locale.gen)  
* To make the changes permament, run `echo "unset LANG" >> /etc/profile` and `echo "source /etc/profile.d/locale.sh" >> /etc/profile`.  

Setting up timezone settings:
* Run `ln -sf /usr/share/zoneinfo/Zone/SubZone /etc/localtime`, make sure to replace "Zone" and "Subzone" in the command.
* This is an example: `ln -sf /usr/share/zoneinfo/Europe/Budapest /etc/localtime`

Desktop environments that i tried:  
* Xfce - works fine.
* Lxde - works fine.
* Plasma - works, but it throws some errors in termux when i connected to it with vnc, it didn't load with x11.  

Issues:  
* Ping doesn't work for me.
* Dns resolving on user accounts doesn't work for me.
* I modified the makepkg command to not check for root, but even then i couldn't install AUR packages, because it ran into some errors with fakeroot.  

Let me know if you know how to fix these issues, thank you!
