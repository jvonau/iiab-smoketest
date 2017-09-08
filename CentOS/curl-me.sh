#!/bin/bash -x
# Start loading IIAB. "bash -x" is debug mode

set -e
# "set -e" to exit on error (avoids snowballing)

LSB_RELEASE=`which lsb_release`

if [ "$LSB_RELEASEx" != "x" ]; then
  LINUX_DIST=`lsb_release -is`
else
  if [ -f /etc/debian_version ]; then
    # assume Raspbian has lsb_release
    LINUX_DIST = "Debian"
  elif [ -f /etc/centos_version ]; then
    LINUX_DIST = "Centos"
  else
    LINUX_DIST = "Unknown"
  fi
fi

if [ $LINUX_DIST == "Centos" ]; then
  yum update
  # in case needed
  yum install -y git

elif [ $LINUX_DIST == "Ubuntu" ] || [ $LINUX_DIST == "Debian" ] || [ $LINUX_DIST == "Raspbian" ]; then
  export DEBIAN_FRONTEND=noninteractive
  apt-get -y update
  apt-get -y dist-upgrade
  apt-get -y clean
  # in case needed
  apt-get install -y git
else
  echo "$LINUX_DIST not supported at this time."
  exit 1
fi

mkdir -p /opt/iiab

# Get the extras
cd /opt/iiab
git clone https://github.com/iiab/iiab-factory --depth 1

# Get the current install options (we'll do more with these later like manage releases)
source /opt/iiab/iiab-factory/factory-settings

git clone https://github.com/iiab/iiab-admin-console --depth 1
git clone https://github.com/iiab/iiab-menu --depth 1

# Get iiab
git clone https://github.com/iiab/iiab --depth 1

cd /opt/iiab/iiab

./scripts/ansible
# Installs the correct version of Ansible

cd /opt/iiab/iiab/vars

if [ $LINUX_DIST == "Raspbian" ]; then
  wget http://download.iiab.io/6.3/rpi/local_vars.yml
  # Above assumes a virgin RPi system (wget WON'T overwrite existing files)
fi
# In general please examine local_vars.yml carefully (and modify as nec)
# before running Ansible (below, which takes ~2.5 hours the first time!)

# And note the security warning

# NOTE: you can change many/most settings after install too, using the
# Admin Console (http://box/admin) as documented at: http://FAQ.IIAB.IO

read -p "Press enter to Install or ctl-c to STOP and edit local vars"

cd /opt/iiab/iiab
./runansible
# Try to rerun the above line if it fails?

cd /opt/iiab/iiab-admin-console
./install

cd /opt/iiab/iiab-menu
./cp-menus
