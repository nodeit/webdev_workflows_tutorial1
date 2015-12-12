Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"

  # give our VM an ip address we can access from our browser
  config.vm.network "private_network", ip: "192.168.33.10"

  # sync our local ~/Projects/tutorial1/myapp file to /var/www/myapp in the VM
  config.vm.synced_folder "myapp", "/var/www/myapp", type: "rsync"

  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
  SHELL

  config.vm.provision "shell", path: "provisioning/nginx.sh"
  config.vm.provision "shell", path: "provisioning/nodejs.sh", privileged: false

end