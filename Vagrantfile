Vagrant.configure("2") do |config|
    config.ssh.username = "ubuntu"
    config.ssh.password = "ubuntu"
    config.vm.define "nomadServer01" do |nomadServer01|
      nomadServer01.vm.box = "luyz25/ubuntu-server"
      config.vm.box_version = "20.04-1"
      nomadServer01.vm.hostname = 'nomad-server01'

      nomadServer01.vm.network :private_network, ip: "192.168.56.101"
      nomadServer01.vm.network :forwarded_port, guest: 22, host: 2201, id: "ssh"

      nomadServer01.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--cpus", 2]
        v.customize ["modifyvm", :id, "--memory", 2048]
        v.customize ["modifyvm", :id, "--name", "nomad-server01"]
        v.customize ["modifyvm", :id, "--usb", "on"]
        v.customize ["modifyvm", :id, "--usbehci", "off"]
      end
      nomadServer01.vm.provision "shell", path: "scripts/def_hosts.sh"
      nomadServer01.vm.provision "shell", path: "scripts/install_defaults.sh"
    end

    config.vm.define "consulServer01" do |consulServer01|
        consulServer01.vm.box = "luyz25/ubuntu-server"
        config.vm.box_version = "20.04-1"
        consulServer01.vm.hostname = 'consul-server01'
  
        consulServer01.vm.network :private_network, ip: "192.168.56.102"
        consulServer01.vm.network :forwarded_port, guest: 22, host: 2202, id: "ssh"
  
        consulServer01.vm.provider :virtualbox do |v|
          v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
          v.customize ["modifyvm", :id, "--cpus", 2]
          v.customize ["modifyvm", :id, "--memory", 2048]
          v.customize ["modifyvm", :id, "--name", "consul-server01"]
          v.customize ["modifyvm", :id, "--usb", "on"]
          v.customize ["modifyvm", :id, "--usbehci", "off"]
        end
        consulServer01.vm.provision "shell", path: "scripts/def_hosts.sh"
        consulServer01.vm.provision "shell", path: "scripts/install_defaults.sh"
      end

    config.vm.define "nomadNode01" do |nomadNode01|
      nomadNode01.vm.box = "luyz25/ubuntu-server"
      config.vm.box_version = "20.04-1"
      nomadNode01.vm.hostname = 'nomad-node01'

      nomadNode01.vm.network :private_network, ip: "192.168.56.103"
      nomadNode01.vm.network :forwarded_port, guest: 22, host: 2203, id: "ssh"

      nomadNode01.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--cpus", 2]
        v.customize ["modifyvm", :id, "--memory", 4096]
        v.customize ["modifyvm", :id, "--name", "nomad-node01"]
        v.customize ["modifyvm", :id, "--usb", "on"]
        v.customize ["modifyvm", :id, "--usbehci", "off"]
      end
      nomadNode01.vm.provision "shell", path: "scripts/def_hosts.sh"
      nomadNode01.vm.provision "shell", path: "scripts/install_defaults.sh"
    end
end