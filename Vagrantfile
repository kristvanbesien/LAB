# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANT_ROOT = File.dirname(File.expand_path(__FILE__))

# Require YAML module
require 'yaml'
 
# Read YAML file with box details
serverfile = File.join(VAGRANT_ROOT,'servers.yaml')
boxes = YAML.load_file(serverfile)


Vagrant.configure(2) do |config|
  config.vm.network "private_network", type: "dhcp"
  config.vm.box = "centos7base"

  config.ssh.forward_agent = true
 
  config.hostmanager.enabled = true
  config.hostmanager.ip_resolver = proc do |vm, resolving_vm|
    if vm.id
      `VBoxManage guestproperty get #{vm.id} "/VirtualBox/GuestInfo/Net/1/V4/IP"`.split()[1]
    end
  end

  config.puppet_install.puppet_version = "3.7.5"

  config.vm.provision :puppet, run: "always"  do |puppet|
    puppet.hiera_config_path = "puppet/hiera.yaml"
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "site.pp"
  end

  boxes.each do |opts|
    config.vm.define opts[:name] do |config|
      config.vm.hostname = opts[:name]
      config.vm.provider :virtualbox do |vb|
        if opts[:datadisk]
          file_to_disk = File.join(VAGRANT_ROOT,"#{config.vm.hostname}_datadisk.vdi")
          unless File.exist?(file_to_disk)
            vb.customize ['createhd', '--filename', file_to_disk, '--size', opts[:datadisk].to_i * 1024]
          end
          vb.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk] 
        end
      end
    end
  end
end


