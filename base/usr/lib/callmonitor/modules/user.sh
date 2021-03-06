require system

# retrieves a password
# (passwords containing umlauts are not handled correctly)
user_getpw() {
    local user=${1:-@CompatMode} found=false
    cfg2sh ar7 boxusers | sed -rn "s/^boxusers_users_(name|password)=/\1=/p" |
    while read -r line; do
	case $line in
	    name=*)
		unset name password
		eval "$line"
		if [ "$name" = "$user" ]; then
		    found=true
		fi
		;;
	    password=*)
		if $found; then
		    eval "$line"
		    echo "$password"
		    break
		fi
		;;
	esac
	false
    done
}
## lists all users, one per line (might include user "@CompatMode")
user_list() {
    cfg2sh ar7 boxusers | sed -rn "s/^boxusers_users_(name)=/\1=/p" |
    while read -r line; do
	eval "$line"
	echo "$name"
    done
}
## returns 0 if this is a multi-user box
user_supported() {
    grep -q "^boxusers " /var/flash/ar7.cfg
}

## returns 0 if compatability mode is enabled
user_is_compat() {
    [ "$(system_query boxusers:settings/compatibility_mode)" != 0 ]
}

user_auth_is_skipped() {
    [ "$(system_query boxusers:settings/skip_auth_from_homenetwork)" = 1 ]
}
