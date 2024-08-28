source="appsettings.override.json"

if [[ $(which op) == '' ]]; then
	echo "You need to install the 1password-cli first"
	return
fi
value=$(op read op://Shared/alpha-appsettings.override.json/appsettings.override.json)
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
	echo "$source -> $dest"
	echo $value > $dest/$source
done
