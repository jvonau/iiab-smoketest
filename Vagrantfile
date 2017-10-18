# -*- mode: ruby -*-
# vi: set ft=ruby :
# Setting Vagrant minimum require_version
Vagrant.require_version ">= 2.0.0"

# Setting default location to store .vagrant folder. Matches $JENKINS_HOME
ENV['VAGRANT_DOTFILE_PATH'] = '/var/lib/jenkins'


Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox"
  config.vm.boot_timeout = 600
  config.vm.box_check_update = "true"
  # You can find out your network interface name with 'lshw -class network'
  config.vm.network "public_network", type: "dhcp", bridge: [
    "enp3s0",
    "wlan0",
    "eth0",
    "82579LM Gigabit Network Connection",
    "82567LM-3 Gigabit Network Connection",
    "Centrino Advanced-N 6205 [Taylor Peak]"]
  config.vm.network "private_network", type: "dhcp"
  config.vm.network "private_network", type: "dhcp"
  config.ssh.username = "vagrant"
  config.ssh.password = "vagrant"
  config.ssh.insert_key = false
  config.ssh.keys_only = false
  config.ssh.host = 'localhost'

  # Vagrant-dependency-manager to install required Vagrant plugins
  if File.exists?(File.dirname(__FILE__)+ "/dependency_manager.rb")
    require File.dirname(__FILE__)+ "/dependency_manager"
    check_plugins ["vagrant-vbguest", "vagrant-cachier"]
  end

  # vagrant-vbguest check if the VirtualBox Guest Additions version number are in sync
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = true
  end

  # Enable vagrant-cachier plugin enabled for multi-vm envirnoment
  if Vagrant.has_plugin?("vagrant-cachier")
     config.cache.scope = :machine

    config.cache.synced_folder_opts = {
      owner: "root",
      group: "root",
      mount_options:['dmode=777', 'fmode=755']
    }
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--memory", 2048]
    vb.customize ["modifyvm", :id, "--cpus", 2]
  end

  config.vm.define "ubuntu", autostart: false do |ubuntu|
    ubuntu.vm.box = "ubuntu/xenial64"
        # Fixes Apt hash sum mismatch error https://blog.packagecloud.io/eng/2016/03/21/apt-hash-sum-mismatch/
    ubuntu.vm.provision "shell", inline: "echo 'Acquire::CompressionTypes::Order:: \"gz\";' > /etc/apt/apt.conf.d/99compression-workaround"
    ubuntu.vm.provision "shell", path: "curl-me-debian"
  end

  config.vm.define "debian", autostart: false do |debian|
    debian.vm.box = "debian/stretch64"
    debian.vm.provision "shell", path: "curl-me-debian"
  end

  config.vm.define "fedora", autostart: false do |fedora|
    fedora.vm.box = "fedora/26-cloud-base"
    # BUG curl-me script requires 'lsb_release' which is not part of Fedora core
    fedora.vm.provision "shell", path: "curl-me-fedora"
  end

  config.vm.define "centos", autostart: false do |centos|
    centos.vm.box = "centos/7"
    # BUG curl-me script requires 'lsb_release' program
    centos.vm.provision "shell", path: "curl-me-centos"
  end

end
