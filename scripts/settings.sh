settings_get_path()
{
	decoration_message _ "The installer will create a directory for your linux rootfs, enter it's name!"
	decoration_text_centered "It will be located inside '/data/anarch'!"

	read -p 'Enter your directory name: ' settings_installdir

	settings_installpath="/data/anarch/"$settings_installdir

	if [ ! -d "$settings_installpath" ]
	then
  		mkdir -p $settings_installpath

		echo
		decoration_message _ "$settings_installdir directory created in '/data/anarch'!"
		echo
	fi

	if [ ! -L /anarch ]
	then
  		ln -sf /data/anarch /anarch 

		echo
		decoration_message _ "'/data/anarch' symlink created at your device's root directory!"
		echo
	fi

	return
}

settings_get_mountstorage()
{
	decoration_message _ "Do you want to mount your internal storage in the container?"
	decoration_text_centered "(y / n)"

	read -p 'Answer: ' settings_mountstorage

	if [ $settings_mountstorage = "y" ]
	then
		return
	elif [ $settings_mountstorage = "n" ]
	then
		return
	else
		echo
		decoration_message ! "Invalid input, type 'y', or 'n'." 
		echo

		settings_get_mountstorage
	fi
}

settings_verification()
{
	decoration_message _ "Installation path: $settings_installpath"
	decoration_text_centered "Mount internal storage: $settings_mountstorage"
	echo
	decoration_message _ "Are these settings correct?"
	decoration_text_centered "(y / n)"

	read -p 'Answer: ' settings_verification_answer

	if [ $settings_verification_answer = "y" ]
	then
		return
	elif [ $settings_verification_answer = "n" ]
	then
        settings_exit
	else
		echo
		decoration_message ! "Invalid input, type 'y', or 'n'."
		echo

		settings_verification
	fi
}

settings_exit()
{
	echo
	decoration_message _ "Exiting installation..."
	echo

	rmdir $settings_installpath

	exit 1
}