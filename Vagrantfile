# -*- mode: ruby -*-
# vi: set ft=ruby :
$SETUP_USER_CHANDU = <<SCRIPT
	sudo mkdir -p /home/chandu/.ssh
	sudo rm -rf /home/chandu/.ssh/*
	sudo cp /fun/.ssh-for-vagrant/* /home/chandu/.ssh		
	sudo chown -R chandu /home/chandu/.ssh/
	for file in /home/chandu/.ssh/*
	do
	  sudo chmod 0400 $file
	done
SCRIPT

$MAKE_SYMLINK_VS10 = <<SCRIPT
	cd /usr/lib/mono/xbuild/Microsoft/VisualStudio/
	ln -s v9.0 v10.0
SCRIPT
VAGRANT_BASE_BOX_PATH= "file://" + (Pathname(__FILE__).dirname.join('boxes', 'ubuntu-base-14.box').to_s)
VAGRANT_CHEFFILES_PATH = Pathname(__FILE__).dirname.to_s

machines = {
	:nobuntu => {
		:ipaddress => "10.0.0.5",
		:run_list => "role[default],role[nodejs]",
		:shell_commands => [
		],
		:shell_scripts => [
			'./custom-scripts/samba/mount-samba-share.sh'
		]
	},
	:rubuntu => {
		:ipaddress => "10.0.0.4",
		:run_list => "role[default],role[ror]",
		:shell_commands => [
		],
		:shell_scripts => [
			'./custom-scripts/samba/mount-samba-share.sh'
		]
	},
	:phuntu => {
		:ipaddress => "10.0.0.3",
		:run_list => "role[default],role[php]",
		:shell_commands => [
		],
		:shell_scripts => [
			'./custom-scripts/samba/mount-samba-share.sh'
		]
	},
	:pyntu => {
		:ipaddress => "10.0.0.6",
		:run_list => "role[default],role[python]",
		:shell_commands => [
		],
		:shell_scripts => [
			'./custom-scripts/samba/mount-samba-share.sh'
		]
	},
	:mogambo => {
		:ipaddress => "10.0.0.7",
		:run_list => "role[default],role[mogambo]",
		:shell_commands => [
			$MAKE_SYMLINK_VS10 ,
			"sudo apt-get install mono-complete mono-gmcs"
		],
		:shell_scripts => [
			'./custom-scripts/samba/mount-samba-share.sh'
		]
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
			config.vm.synced_folder "G:/BitBucket/time-tracker-ui", "/fun", type: "rsync",   rsync__exclude: [".git/", "node_modules/"], :owner=> 'chandu', :mount_options => ['dmode=777', 'fmode=777'], rsync__args: ["--verbose", "--rsync-path='rsync'", "--archive", "--delete", "-z", "--chmod=ugo+rwx" , "-u=chandu", "-g=chandu"], rsync__chown: true
			config.omnibus.chef_version = :latest
			config.ssh.forward_agent = true 
			config.vm.provider "virtualbox" do |vb|
			ENV["VAGRANT_DETECTED_OS"] = ENV["VAGRANT_DETECTED_OS"].to_s + " cygwin"
			#   # Don't boot with headless mode
			#	vb.gui = true
			#
			#   # Use VBoxManage to customize the VM. For example to change memory:
			#	vb.customize ["modifyvm", :id, "--memory", "512"]
			 	vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
			 end
			config.vm.provision :chef_solo do |chef|
				chef.cookbooks_path =["site-cookbooks", "cookbooks"].map { |e| File.join(VAGRANT_CHEFFILES_PATH, e)  }
				chef.roles_path = File.join(VAGRANT_CHEFFILES_PATH, "roles")
				chef.data_bags_path = File.join(VAGRANT_CHEFFILES_PATH, "data_bags")
				chef.provisioning_path = "/tmp/vagrant-chef"
				chef.run_list = options[:run_list].split(",")
			end
			config.vm.provision :shell, :inline => $SETUP_USER_CHANDU
			options[:shell_commands].each { |x| config.vm.provision :shell, :inline =>  x }
			#options[:shell_scripts].each { |x| config.vm.provision :shell, :path =>  x }
		end
	end
end