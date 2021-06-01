check_root()
{
	decoration_message _ "Checking root access."

	if [[ $EUID -ne 0 ]]
	then
	   	decoration_message ! "This script must be run as root!" 
	   	exit 1
	else
		decoration_message _ "Root privileges detected!"
		return
	fi
}

check_available_space()
{
	decoration_message _ "Checking available storage space."
	
    settings_available_space=$(echo $(df -h /data) | awk -v N=11 '{print $N}' | tr -d G)

	if [ $settings_available_space -lt 4 ]
	then
		decoration_message ! "Not enough space!"
		exit 1
	else
		decoration_message _ "The available space is: ${settings_available_space}G"
		return
	fi
}