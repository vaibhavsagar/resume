# Install jq to filter Github release data for Pandoc.
sudo apt-get -y install jq
# Get the latest .deb released.
wget 'https://github.com/jgm/pandoc/releases/download/1.15.1/pandoc-1.15.1-1-amd64.deb' -O pandoc.deb
sudo dpkg -i pandoc.deb
