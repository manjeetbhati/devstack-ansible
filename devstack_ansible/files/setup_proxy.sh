#!/bin/bash

# Script to set up Intel proxy environment variables
#
# Nate Potter

exit_with_error () {
    echo "$1" 1>&2
    exit 1
}

if [[ $EUID -ne 0 ]];then
    exit_with_error "Please run this script as root"
fi   

# Update .bashrc with proxy variables

echo 
export GIT_PROXY_COMMAND=~/bin/socks-gw
export PATH=~/bin:$PATH' >> ~/.bashrc || exit_with_error "Failed to update .bashrc!"

echo "Updated .bashrc..."

# Create proxy scripts in ~/bin

mkdir ~/bin && \
echo '#!/bin/sh
$1 = hostname, $2 = port
proxy=proxy-socks.sc.intel.com
exec socat STDIO SOCKS4:$proxy:$1:$2' > ~/bin/git-proxy && \
echo '#!/bin/sh
MODE="GNOME"
echo $1 | grep "\.intel\.com$" > /dev/null 2>&1
if [ $? -eq 0 ];then
    connect $@
else
    connect -S proxy-socks.sc.intel.com:1080 $@
fi' > ~/bin/socks-gw && \
chmod a+x ~/bin -R || exit_with_error "Failed to create proxy scripts!"

echo "Created proxy scripts..."

# Update environment variables


# Update sudoers file

cp /etc/sudoers /etc/sudoers.tmp && \
chmod 0640 /etc/sudoers.tmp && \
echo 'Defaults  env_keep+="http_proxy https_proxy no_proxy HTTP_PROXY HTTPS_PROXY NO_PROXY"' >> /etc/sudoers.tmp && \
chmod 0440 /etc/sudoers.tmp && \
mv /etc/sudoers.tmp /etc/sudoers || exit_with_error "Failed to update sudoers!"

echo "Updated sudoers..."

echo "Proxy setup complete! Restart your terminal or source .bashrc for it to take effect."
