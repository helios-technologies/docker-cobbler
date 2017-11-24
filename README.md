# docker-cobbler (Last version 2.6.11) 

[![](https://cobbler.github.io/images/logo-brand.png)](http://cobbler.github.io/ "cobbler")

### Last Update: 13/10/2016.

Build Status: 

[![Build Status](https://api.travis-ci.org/ethnchao/docker-cobbler.svg?branch=master)](https://travis-ci.org/ethnchao/docker-cobbler) [![](https://images.microbadger.com/badges/image/ethnchao/cobbler.svg)](https://microbadger.com/images/ethnchao/cobbler "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/ethnchao/cobbler.svg)](https://microbadger.com/images/ethnchao/cobbler "Get your own version badge on microbadger.com")

### Cobbler
Cobbler is a build and deployment system. The primary functionality of cobbler is to simplify the lives of administrators by automating repetive actions, and to encourage reuse of existing work through the use of templating.

### Docker

[Docker](https://www.docker.com/) allows you to package an application with all of its dependencies into a standardized unit for software development.

More information : 

* [What is docker](https://www.docker.com/what-docker)
* [How to Create a Docker Business Case](https://www.brianchristner.io/how-to-create-a-docker-business-case/)

### Get to the point

This repository provides the *LATEST STABLE* version of the Cobbler Docker file.

Component & Version:

* [`centos:latest`](https://hub.docker.com/_/centos/)
* ['cobbler:2.6.11'](http://cobbler.github.io/)

### Configurations

Before you up this container, adjust the configuration files in etc/cobbler.

* In the *settings* file, adjust at least these settings:
  * default_password_crypted
  * manage_dhcp
  * manage_dns
  * manage_forward_zones
  * manage_reverse_zones
  * next_server
  * pxe_just_once
  * server

In container：
* Cobbler configuration lives in **/etc/cobbler**
* Tftpd configuration lives in **/etc/cobbler/tftpd.template**
* dhcpd configuration lives in **/etc/cobbler/dhcp.template**

### Dockerfile

Due to the reasons for the Chinese network, I replace the yum base/epel repository with domestic mirror.

### Up

Use the accompanied Makefile to set it up. Issue make <target\> to make the following:

*build*	  Build the image

*run*    Run the Docker container

**After Run this container, Remeber run cobbler sync**

* clean:  Remove the docker container
* mount:  By default, run **make mount** will mount dist/centos7.iso on the path dist/mnt/centos7; You can alternatively run **make mount -e NAME=ubuntu16** for mount dist/ubuntu16.iso to dist/mnt/ubuntu16. For use with the import target. Remeber use DVD iso.
* umount: Unmount dist/mnt.
* tty:    Attach to a console inside the container
* stop:   Stop the container
* start:  Start the container
* import: By default, run **make import** will import /mnt/centos7 into Cobbler; You can alternatively run **make import -e NAME=ubuntu16** for import /mnt/ubuntu16. See mount target.
* all:    Build image, mount iso, run the container and import the distribution
* vbox:   Create a VirtualBox VNIC for listening on and issuing DHCP addresses. This is for testing Cobbler functionality in combination with Virtualbox VMs. Requires a working VirtualBox installation.

### Vagrant

Create a bridge to have an isolated network to work
```
brctl addbr cobbler
ip link set cobbler up
```

Start cobbler
```
vagrant up
vagrant ssh
```

UI will be accessible at [https://localhost:4443/cobbler_web] with cobbler/cobbler as credentials.

#### Simple setup example

First download a centos7 ISO and store it in dist/centos7.iso

```
vagrant ssh
$ sudo -i
# mkdir -p /mnt/centos7 && sudo mount -t iso9660 -o loop,ro -v /vagrant/dist/centos7.iso /mnt/centos7/
# cobbler import --name=centos7 --arch=x86_64 --path=/mnt/centos7
# cobbler profile add --name=centos7-sample --distro=centos7-x86_64 --kickstart=/var/lib/cobbler/kickstarts/sample.ks
# cobbler system add --name=node1 --profile=centos7-sample --netboot-enabled=true --interface=eth0 --mac-address=00:16:3E:0B:2E:EE --netmask=255.255.255.0 --ip-address=192.168.56.200 --mtu=1500
```

### Issue

There is still some issue I can't fix:
1. After you first time run this container, you should run **cobbler sync**. Because TFTPd can't self start by xinetd, but after you run cobbler sync, tftpd will start successfully
2. Mount DVD iso first before you start container.

### Reference
* [Cobbler in a Docker Container by Thijs Schnitger](http://container-solutions.com/cobbler-in-a-docker-container/)
