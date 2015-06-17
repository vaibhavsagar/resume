# Install jq to filter Github release data for Pandoc.
# sudo apt-get -y install jq
# Get the latest .deb released.
# wget `curl https://api.github.com/repos/jgm/pandoc/releases/latest | jq -r '.assets[] | .browser_download_url | select(endswith("deb"))'` -O pandoc.deb
# Get a release with a .deb for now
wget https://github.com/jgm/pandoc/releases/download/1.14/pandoc-1.14-1-amd64.deb -O pandoc.deb
sudo dpkg -i pandoc.deb
