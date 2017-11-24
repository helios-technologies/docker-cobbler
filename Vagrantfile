# -*- mode: ruby -*-
# vi: set ft=ruby :
memory = ENV["VAGRANT_RAM"] || "5120"

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 443, host: 4443

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :public_network, ip: "192.168.56.1", bridge: 'cobbler'

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = memory
  end

  config.vm.provision "shell", inline: <<-EOF
    set -x
    yum -y update
    yum -y install epel-release
    yum -y install cobbler cobbler-web dhcp syslinux pykickstart wget tcpdump net-tools xinetd
    systemctl enable cobblerd
    systemctl enable httpd
    systemctl enable dhcpd
    systemctl enable xinetd
    sed -ei 's/\(^.*disable.*=\) yes/\1 no/' /etc/xinetd.d/tftp
    sed -ei 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    setenforce 0
    setsebool -P httpd_can_network_connect true
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
    sysctl -p
    iptables -A FORWARD -i eth1 -j ACCEPT
    iptables -A FORWARD -o eth1 -j ACCEPT
    iptables -t nat -A POSTROUTING ! -d 192.168.0.0/16 -o eth0 -j MASQUERADE
    cp /vagrant/etc/cobbler/settings /etc/cobbler/settings
    cp /vagrant/etc/cobbler/dhcp.template /etc/cobbler/dhcp.template
    systemctl start cobblerd
    systemctl start httpd
    sleep 10
    cobbler get-loaders
    cobbler sync
    systemctl start xinetd
  EOF
end
