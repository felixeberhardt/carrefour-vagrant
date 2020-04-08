# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provision :shell, path: "bootstrap.sh"

  config.vm.define :test_vm do |test_vm|
    test_vm.vm.box = "debian/jessie64"
    test_vm.vm.provider :libvirt do |domain|
      domain.machine_virtual_size = 64
      domain.cpus = 4
      domain.cputopology :sockets => '2', :cores => '2', :threads => '1'
      domain.numa_nodes = [
        {:cpus => "0-1", :memory => "1024"},
        {:cpus => "2-3", :memory => "4096"}
      ]
    end

    test_vm.vm.network :private_network, :ip => '10.20.30.40'
  end

  config.vm.provider :libvirt do |libvirt|
    libvirt.driver = "kvm"
    libvirt.connect_via_ssh = false
    libvirt.storage_pool_name = "default"
  end

  config.trigger.after [:provision] do |t|
    t.name = "Reboot after provisioning"
    t.run = { :inline => "vagrant reload" }
  end
end
