settings_get_path()
{
	decoration_message _ "The installer will create a directory for your linux rootfs, enter it's name!"
	decoration_text_centered "It will be located inside '/anarch'!"

	read -p 'Enter a path: ' settings_installdir

	settings_installpath="/anarch/"$settings_installdir

	if [ ! -d "$settings_installpath" ]
	then
  		mkdir -p $settings_installpath
		echo
		decoration_line _
		decoration_text_centered "$settings_installdir directory created in '/anarch'!"
	fi

	return
}

settings_get_mountstorage()
{
	decoration_message _ "Do you want to mount your internal storage in the container?"
	decoration_text_centered "(Yes / No)"

	read -p 'Answer: ' settings_mountstorage

	if [ $settings_mountstorage = "yes" ]
	then
		return
	elif [ $settings_mountstorage = "no" ]
	then
		return
	else
		echo
		decoration_message ! "Invalid input, type \"yes\", or \"no\"." 
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
	decoration_text_centered "(Yes / No)"

	read -p 'Answer: ' settings_verification_answer

	if [ $settings_verification_answer = "yes" ]
	then
		return
	elif [ $settings_verification_answer = "no" ]
	then
		echo
		decoration_line _
		decoration_text_centered "Exiting installation..."

        exit 1
	else
		echo
		decoration_line !
		decoration_text_centered "Invalid input, type \"yes\", or \"no\"."
		echo
		settings_verification
	fi
}