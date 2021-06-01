decoration_line()
{
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" | tr ' ' $1
}

decoration_text_centered()
{
	title=$1
	printf '%*s\n' $(((${#title}+$COLUMNS)/2)) "$title"
}

decoration_message()
{
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" | tr ' ' $1
	title=$2
	printf '%*s\n' $(((${#title}+$COLUMNS)/2)) "$title"
}

decoration_install_finished()
{
	decoration_line =
	decoration_text_centered "Installation completed!"
	echo
	decoration_text_centered "From now on, you can enter your chroot by running"
	decoration_text_centered "the mount, and start scripts in your anarch folder!"
	echo
	decoration_text_centered "Installer script created by: Selirra"
	decoration_text_centered "https://github.com/selirra"
	echo
	decoration_text_centered "Servicectl utility created by: Smaknsk"
	decoration_text_centered "https://github.com/smaknsk/servicectl"
	decoration_line =
}