# -*- mode: ruby -*-
# vi: set ft=ruby :
$SETUP_USER_CHANDU = <<SCRIPT
	sudo mkdir -p /home/chandu/.ssh
	sudo rm -rf /home/chandu/.ssh/*
	sudo cp /fun/.ssh-for-vagrant/* /home/chandu/.ssh		
	sudo chown -R chandu /home/chandu/.ssh/
	for file in /home/chandu/.ssh/*
	do
	 # do something on $file
	  sudo chmod 0400 $file
	done
SCRIPT
VAGRANT_BASE_BOX_PATH= "file://" + (Pathname(__FILE__).dirname.join('boxes', 'precise64.box').to_s)
VAGRANT_CHEFFILES_PATH = Pathname(__FILE__).dirname.to_s
class VagrantCommonConfig
	def self.configure(config, box_name, host_name, ip_address, base_path)
		config.vm.boot_timeout=1000	
		config.vm.box = box_name
		config.vm.hostname = host_name
		config.vm.box_url =  VAGRANT_BASE_BOX_PATH
		config.vm.network "private_network", ip: ip_address
		config.vm.network "public_network"
		config.vm.synced_folder "G:/", "/fun"
		
		config.ssh.forward_agent = true


		 config.vm.provider "virtualbox" do |vb|
		#   # Don't boot with headless mode
		#	vb.gui = true
		#
		#   # Use VBoxManage to customize the VM. For example to change memory:
		#	vb.customize ["modifyvm", :id, "--memory", "512"]
		 end

		 vagrant_json = JSON.parse(Pathname(base_path).dirname.join('nodes', 'vagrant.json').read)
	 	
		config.vm.provision :chef_solo do |chef|
			chef.cookbooks_path =["site-cookbooks", "cookbooks"].map { |e| File.join(VAGRANT_CHEFFILES_PATH, e)  }
			chef.roles_path = File.join(VAGRANT_CHEFFILES_PATH, "roles")
			chef.data_bags_path = File.join(VAGRANT_CHEFFILES_PATH, "data_bags")
			chef.provisioning_path = "/tmp/vagrant-chef"

			# You may also specify custom JSON attributes:
			chef.run_list = vagrant_json.delete('run_list')
			chef.json = vagrant_json
		end

		
		config.vm.provision :shell, :inline => $SETUP_USER_CHANDU
	end
end