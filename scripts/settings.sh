settings_get_path()
{
	read -p 'Enter a path: ' settings_installdir

	settings_installpath="/data/linux/"$settings_installdir

	if [ ! -d "$settings_installpath" ]
	then
  		mkdir -p $settings_installpath
		echo
		decoration_line _
		decoration_text_centered "$settings_installdir directory created in /data/linux!"
	fi

	return
}

settings_get_mountstorage()
{
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