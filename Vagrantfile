# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.8.4"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box          = "windows_2016_insider"
  config.vm.communicator = "winrm"

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder ENV['HOME'], ENV['HOME']

  config.vm.provision "shell", path: "scripts/load-images.ps1"
  config.vm.provision "shell", path: "scripts/build-dockertls.ps1"
  config.vm.provision "shell", path: "scripts/create-machine.ps1", args: "-machineHome #{ENV['HOME']} -machineName insider"

  ["vmware_fusion", "vmware_workstation"].each do |provider|
    config.vm.provider provider do |v, override|
      v.gui = false
      v.memory = 2048
      v.cpus = 2
      v.enable_vmrun_ip_lookup = false
      v.linked_clone = true
      v.vmx["vhv.enable"] = "TRUE"
    end
  end

  config.vm.provider "virtualbox" do |v, override|
    v.gui = false
    v.memory = 2048
    v.cpus = 2
    v.linked_clone = true
    override.vm.network :private_network, ip: "192.168.99.90", gateway: "192.168.99.1"
  end

  config.vm.provider "hyperv" do |v|
    v.cpus = 2
    v.maxmemory = 2048
    v.differencing_disk = true
  end
end
