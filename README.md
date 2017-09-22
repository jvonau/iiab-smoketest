Internet-in-a-Box (IIAB) Smoke Tests
==============================
Smoke-testing of Internet-in-a-Box OS builds using Jekins and vagrant. This repository contains Vagrant virtual images for Ubuntu, Debian, Fedora and CentOS.

At the moment Rasbian virtual image emulated in Qemu using [Jessie kernel](https://github.com/dhruvvyas90/qemu-rpi-kernel) and [Rasbian Stretch Lite](https://www.raspberrypi.org/downloads/raspbian/) image. In future releases, this would be ported using [vagrant-libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt) provider.

The goal of the project is to port [George Hunt's xsce-tests](https://github.com/georgejhunt/xsce-tests/) for Internet-in-a-Box (IIAB) project.

# Usage
You'll need a [Jenkins server](http://jenkins.io/) with [Vagrant plugin](https://wiki.jenkins.io/display/JENKINS/Vagrant-plugin) installed. You can then add new jobs to build Internet-in-a-Box (IIAB) for each target operating system.



# Testing

TBD


# Reporting

TBD


# TODO

Port Rasbian Qemu to vagrant-libvirt. 
