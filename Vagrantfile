# Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.ssh.forward_agent = true
  config.vm.network "forwarded_port", guest: 80, host: 80, host_ip: "127.0.0.1", id: 'apache_http'
  config.vm.network "forwarded_port", guest: 22, host: 22, host_ip: "127.0.0.1", id: 'ssh'
  config.vm.synced_folder "public_html", "/var/www/html"
  config.vm.synced_folder "log/apache2", "/var/log/apache2"
  config.vm.synced_folder "log/mariadb", "/var/log/mysql"
  config.vm.provision "shell", path: "provision.sh"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
  end
end