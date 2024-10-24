#!/bin/bash -e
if [[ ! $USER == root ]]; then
	echo "run script with sudo"
	exit 1
fi

# Fetch latest version
TAG=$(curl -s https://api.github.com/repos/prometheus/alertmanager/releases | jq -r '.[] | .tag_name' | head -n 1)
echo $TAG

# Remove the `v` prefix
VERSION=$(echo $TAG | sed 's/v//')
echo $VERSION

# Check CPU architecture
ARCH=$(uname -s | tr A-Z a-z)-$(uname -m | sed 's/x86_64/amd64/')
echo $ARCH

# Download the release
curl -L -O https://github.com/prometheus/alertmanager/releases/download/$TAG/alertmanager-$VERSION.$ARCH.tar.gz

# Extract the file
tar -xvzf alertmanager-$VERSION.$ARCH.tar.gz

# Move promtool
mv alertmanager-$VERSION.$ARCH/amtool /usr/local/bin

# Verify if promtool is installed
amtool --version

# Delete downloaded files
rm -rf alertmanager-$VERSION.$ARCH
rm -rf alertmanager-$VERSION.$ARCH.tar.gz
