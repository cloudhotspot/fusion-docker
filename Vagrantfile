# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Variables
$memory = 4096
$cpus = 4
$guest_name = "fusion01"
$virtualbox_ip = "192.168.50.11"
$shared_host_path = "~/Source"
$shared_guest_path = "/share"


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|	
	# Add guest to host hosts file
	config.hostmanager.enabled = true
	config.hostmanager.manage_host = true
	
	# Box
	config.vm.box = "phusion/ubuntu-14.04-amd64"

	# VMWare Fusion settings
	config.vm.provider "vmware_fusion" do |v|
		v.vmx["memsize"] = $memory.to_s
		v.vmx["numvcpus"] = $cpus.to_s
	end

  # Virtualbox settings
	config.vm.provider "virtualbox" do |v, override|
		# Virtualbox requires a private network with static IP for hostmanager plugin to work
		override.vm.network "private_network", ip: $virtualbox_ip	
		v.memory = $memory
		v.cpus = $cpus
	end
	
	# Common configuration
	config.vm.hostname = $guest_name
	config.vm.synced_folder $shared_host_path, $shared_guest_path, type: "nfs"
	
	# Provisioner
	config.vm.provision "shell", path: "provision.sh"
	
end