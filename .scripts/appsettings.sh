source="appsettings.override.json"


if [[ $(which op) == '' ]]; then
	echo "You need to install the 1password-cli first"
	exit 1
fi

if [[ $(which 1password) == '' ]]; then
	echo "You need to install the 1password desktop app first"
	exit 1
fi

if [[ $(pgrep 1password) == '' ]]; then
    	nohup 1password --silent >/dev/null 2>&1 &
	disown
	sleep 1
fi

value=$(op read op://Shared/alpha-appsettings.override.json/appsettings.override.json)

if [[ $? -ne 0 ]]; then
	exit $?
fi

dests=($1)
value_parsed=$(echo $value | jq)

if [[ ${#dests} -eq 0 ]]; then
	search=$(grep -ril 'UseAzureKeyVault(' --include \*.cs)
	if [[ -z "$search" ]]; then
		echo "No destination could be satisfied"
		echo "Usage: appsettings <dest>"
		echo "If no dest is specified, it will try to find all directories where UseAzureKeyVault() defined"
		return
	fi
	for s in $search; do
		dests+=("$(dirname "$s")")
	done
fi
for dest in "${dests[@]}"; do
	if [[ -f $dest/$source ]]; then
		existing=$(jq -R 'fromjson? | .' $dest/$source)
		is_same=$(jq -n --arg a "$existing" --arg b "$value_parsed" '$a == $b' 2> /dev/null || false)


		if [[ $is_same == true ]]; then
			echo "$dest is up to date"
			continue
		fi
	fi

	echo "$source -> $dest"
	echo $value_parsed > $dest/$source
done
