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

machines = {
	:nobuntu => {
		:ipaddress => "10.0.0.5",
		:run_list => "role[default]"
	},
	:rubuntu => {
		:ipaddress => "10.0.0.4",
		:run_list => "role[default],role[ror]"
	},
	:phuntu => {
		:ipaddress => "10.0.0.3",
		:run_list => "role[default],role[php]"
	},
	:pyntu => {
		:ipaddress => "10.0.0.6",
		:run_list => "role[default],role[python]"
	}
}

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |global_config|
	machines.each_pair do |name, options|
		global_config.vm.define name do |config|
			config.vm.boot_timeout=1000	
			config.vm.box = name.to_s
			config.vm.hostname =  "#{name}.dev"
			config.vm.box_url =  VAGRANT_BASE_BOX_PATH
			config.vm.network "private_network", ip: options[:ipaddress]
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
			config.vm.provision :chef_solo do |chef|
				chef.cookbooks_path =["site-cookbooks", "cookbooks"].map { |e| File.join(VAGRANT_CHEFFILES_PATH, e)  }
				chef.roles_path = File.join(VAGRANT_CHEFFILES_PATH, "roles")
				chef.data_bags_path = File.join(VAGRANT_CHEFFILES_PATH, "data_bags")
				chef.provisioning_path = "/tmp/vagrant-chef"
				chef.run_list = options[:run_list].split(",")
			end
			config.vm.provision :shell, :inline => $SETUP_USER_CHANDU
		end
	end
end