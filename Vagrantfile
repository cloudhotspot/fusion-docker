# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Variables
$guest_name = "fusion01"
$shared_path = "~/Source"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|	
	# Add guest to host hosts file
	config.hostmanager.enabled = true
	config.hostmanager.manage_host = true
	
	# Box
	config.vm.box = "phusion/ubuntu-14.04-amd64"
	config.vm.provider "vmware_fusion" do |v|
		v.vmx["memsize"] = "4096"
		v.vmx["numvcpus"] = "4"
	end
	
	# Guest configuration
	config.vm.hostname = $guest_name
	
	# Shared folders
	config.vm.synced_folder $shared_path, "/share", type: "nfs"
	
	# Provisioner
	config.vm.provision "shell", path: "provision.sh"
	
end