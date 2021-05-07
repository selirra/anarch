## This script will set up an ArchLinuxARM chroot environment, at "/sdcard/archroot".

# WARNING - READ THE NEXT SECTION BEFORE DOING ANYTHING

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
`pkg install wget bsdtar`  

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
