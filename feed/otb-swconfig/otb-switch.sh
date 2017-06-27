setup_switch_dev() {
	local name
	config_get name "$1" name
	name="${name:-$1}"
	otb-swconfig dev "$name" load network
}

setup_switch() {
	config_load network
	config_foreach setup_switch_dev switch
}
