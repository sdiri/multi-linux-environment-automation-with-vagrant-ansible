# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
    servers=[
        {
          :hostname => "servera.lab.com",
          :nd => "servera",
          :box => "bento/almalinux-9",
          :ip => "172.16.1.53",
          :ssh_port => '2205'
        },
        {
          :hostname => "serverb.lab.com",
          :nd => "serverb",
          :box => "bento/almalinux-9",
          :ip => "172.16.1.54",
          :ssh_port => '2206'
        },
		    {
          :hostname => "serverc.lab.com",
          :nd => "serverc",
          :box => "bento/almalinux-9",
          :ip => "172.16.1.55",
          :ssh_port => '2207'
        },
		    {
          :hostname => "serverd.lab.com",
          :nd => "serverd",
          :box => "bento/almalinux-9",
          :ip => "172.16.1.56",
          :ssh_port => '2208'
        },
		    {
          :hostname => "logserver.lab.com",
          :nd => "logserver",
          :box => "bento/almalinux-9",
          :ip => "172.16.1.57",
          :ssh_port => '2209'
        },
        {
          :hostname => "workstationx.lab.com",
          :nd => "workstationx",
          :box => "bento/almalinux-9",
          :ip => "192.168.56.102",
          :ssh_port => '2210'
        },
        {
          :hostname => "controller.lab.com",
          :nd => "controller",
          :box => "bento/almalinux-9",
          :ip => "192.168.56.103",
          :ssh_port => '2211'
        },
		    {
          :hostname => "db.lab.com",
          :box => "bento/ubuntu-18.04",
          :ip => "172.16.1.50",
          :ssh_port => '2200'
        },
        {
          :hostname => "web.lab.com",
          :box => "bento/ubuntu-18.04",
          :ip => "172.16.1.51",
          :ssh_port => '2201'
        },
        {
          :hostname => "softs.lab.com",
          :box => "bento/ubuntu-18.04",
          :ip => "192.168.70.101",
          :ssh_port => '2202'
        }
      ]

      servers.each do |machine|
        config.vm.define machine[:hostname] do |node|
          node.vm.box = machine[:box]
          node.vm.hostname = machine[:hostname]
          node.hostmanager.aliases = machine[:nd]
    
          node.vm.network :private_network, ip: machine[:ip]
          node.vm.network "forwarded_port", guest: 22, host: machine[:ssh_port], id: "ssh"
          node.vm.synced_folder "./data", "/home/vagrant/data"
    
          # Provisioning to set up user addition log file and execute user setup script
          node.vm.provision "shell" do |s|
            s.inline = <<-SHELL
              sudo touch /var/log/ansible_user_addition.log
              sudo chmod 776 /var/log/ansible_user_addition.log
              sudo touch /var/log/init_envirement_setup_errors.log
              sudo chmod 776 /var/log/init_envirement_setup_errors.log              
              echo "#{machine[:ip]} #{machine[:hostname]}" | sudo tee -a /etc/hosts >/dev/null
            SHELL
          end
          # Copy the environment_setup.sh script from host to guest VM's /home/vagrant/ directory
          node.vm.provision "file", source: "D:/LinuxLab/lab4almalinux/scripts/environment_setup.sh", destination: "/home/vagrant/environment_setup.sh"

          # Executing the environment_setup.sh script
          node.vm.provision "shell" do |s|
            s.inline = <<-SHELL
              sudo chmod 777 /home/vagrant/environment_setup.sh
              sudo /home/vagrant/environment_setup.sh
            SHELL
          end

    
          node.vm.provider :virtualbox do |vb|
            vb.customize ["modifyvm", :id, "--memory", 512]
            vb.customize ["modifyvm", :id, "--cpus", 1]
          end
          
          node.vm.provision "shell" do |s|
            s.inline = <<-SHELL
              # Ensure the .ssh directory exists
              sudo mkdir -p /root/.ssh
      
              # Create an empty known_hosts file if it doesn't exist
              sudo touch /root/.ssh/known_hosts
            SHELL
          end
          # Add SSH key acceptance provisioner here
          node.vm.provision "shell", inline: <<-SHELL
            ssh-keyscan -H #{machine[:ip]} >> ~/.ssh/known_hosts
          SHELL
        end
      end
    end