# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  os = "bento/ubuntu-20.04"
  net_ip = "192.168.56"
  minions_name = ['node1']

  config.proxy.http = "http://10.0.2.2:8889"
  config.proxy.https = "http://10.0.2.2:8889"
  config.proxy.no_proxy = "localhost,127.0.0.0/8,::1"

  config.vm.define :master, primary: true do |master_config|
    master_config.vm.provider "virtualbox" do |vb|
      vb.memory = 512
      vb.cpus = 2
      vb.name = "salt_master"
    end

    master_config.vm.box = "#{os}"
    master_config.vm.hostname = "saltmaster.local"
    master_config.vm.network "private_network", ip: "#{net_ip}.10"

    master_config.vm.synced_folder "saltstack/salt/", "/srv/salt"

    master_config.vm.provision :salt do |salt|
      salt.master_config = "saltstack/etc/master"
      salt.install_type = "stable"
      salt.install_master = true
      salt.no_minion = true
      salt.verbose = true
      salt.colorize = true
    end

    minions_name.each do |minion|
      master_config.vm.provision :shell, inline: <<-SHELL
        salt-key -y -q --gen-keys=#{minion} --gen-keys-dir=/srv/salt/keys
        cp -r /srv/salt/keys/#{minion}.pub /etc/salt/pki/master/minions/#{minion}
      SHELL
    end
  end

  minions_name.each_with_index do |minion, index|
    config.vm.define "percona_#{minion}" do |pnode|
      pnode.vm.provider "virtualbox" do |vb|
          vb.memory = 1024
          vb.cpus = 1
          vb.name = "percona_#{minion}"
      end

      pnode.vm.box = "#{os}"
      pnode.vm.hostname = "#{minion}"
      pnode.vm.network "private_network", ip: "#{net_ip}.1#{index+1}"

      pnode.vm.synced_folder "saltstack/salt/", "/srv/salt"

      pnode.vm.provision :salt do |salt|
        salt.minion_config = "saltstack/etc/minion"
        salt.install_type = "stable"
        salt.verbose = true
        salt.colorize = true
        salt.bootstrap_options = "-i #{minion}"
      end

      pnode.vm.provision :shell, inline: <<-SHELL
        cp -f /srv/salt/keys/#{minion}.pub /etc/salt/pki/minion/minion.pub
        cp -f /srv/salt/keys/#{minion}.pem /etc/salt/pki/minion/minion.pem
      SHELL
    end
  end
end
