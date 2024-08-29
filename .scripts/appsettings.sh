source="appsettings.override.json"


if [[ $(which op) == '' ]]; then
	echo "You need to install the 1password-cli first"
	exit 1
fi

value=$(op read op://Shared/alpha-appsettings.override.json/appsettings.override.json | jq)

if [[ $? -ne 0 ]]; then
	exit $?
fi

dests=($1)

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
		is_same=$(jq -n --arg a "$existing" --arg b "$value" '$a == $b' 2> /dev/null || false)


		if [[ $is_same == true ]]; then
			echo "$dest is up to date"
			continue
		fi
	fi
	echo "$source -> $dest"
	echo $value > $dest/$source
done
