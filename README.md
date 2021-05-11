# This script will help you set up an ArchLinuxARM chroot container on your android device.  

## WARNING - READ THE NEXT SECTION BEFORE DOING ANYTHING  

There shouldn't be much danger if you follow the instructions, but i'm not responsible for any damage you might do to your device.  
I can't guarantee that this script will work on every device.  
Make sure to read the script, don't just blindly run random scripts off the internet. :)  
Never try to delete your chroot container, without unmounting it first, and rebooting your phone!  


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

Download, and then run the script as root.  
`git clone https://github.com/selirra/anarch`  
`cd anarch`  
`su`  
`bash scripts/setup_anarch`  

You will be asked for an installation path, the size of the created disk.img file, and whether you want to mount your internal storage in the container.  

If everything went okay, once the setup script finishes, you should have a working ArchLinuxARM chroot container.  
You can now create a password for the root user with `passwd`.  

You will find the mount, unmount, and start scripts at "/your/installation/path/anarch"!  

## Some more info:  

### If you want VNC:  
* Create a password for your vnc server with `vncpasswd`  
* To change your vnc server's resolution, run `echo "geometry="your_desired_resolution" > ~/.vnc/config`.  
* Run `vncserver :0` to start your vnc server.  

### If you want SSH:  
* Run `ssh-keygen -A`.  
* Run `echo "PermitRootLogin yes" >> /etc/ssh/sshd_config` to enable logging in as root via SSH.  
* Enable and start the sshd service with `servicectl enable sshd` and `servicectl start sshd`.  
* Connect to your device via ssh with `ssh root@"the_device's_ip_address"`.  

### Setting up the locale settings:  
* Edit "/etc/locale.gen" with the text editor of your choice, and uncomment your desired locale.  
* Run `locale-gen`, then run `echo "LANG=en_US.UTF-8" > /etc/locale.conf`. (replace "en_US.UTF-8" with the locale that you uncommented in locale.gen)  
* To make the changes permament, run `echo "unset LANG" >> /etc/profile` and `echo "source /etc/profile.d/locale.sh" >> /etc/profile`.  

### Setting up timezone settings:
* Run `ln -sf /usr/share/zoneinfo/Zone/SubZone /etc/localtime`, make sure to replace "Zone" and "Subzone" in the command.
* This is an example: `ln -sf /usr/share/zoneinfo/Europe/Budapest /etc/localtime`

### Desktop environments that i tried:  
* Xfce, LXDE, and Plasma works without major errors.  
* After installing Plasma, run `echo "export $(dbus-launch)" >> /etc/profile`.
  
### Credits:
* To get around systemd's limitations in chroot, i used Smaknsk's servicectl utility.
* https://github.com/smaknsk/servicectl
