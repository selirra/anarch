check_root()
{
	if [[ $EUID -ne 0 ]]
	then
	   echo "This script must be run as root!" 
	   exit 1
	else
		echo "Root privileges detected!"
		return
	fi
}

check_available_space()
{
    settings_available_space=$(echo $(df -h /data) | awk -v N=11 '{print $N}' | tr -d G)

	if [ $settings_available_space -lt 4 ]
	then
		echo "Not enough space!"
		exit 1
	else
		echo "The available space is: ${settings_available_space}G"
		return
	fi
}