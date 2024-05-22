MACHINES = {
  :"bashscript" => {
              :box_name => "ubuntu/focal64",
              :box_version => "20240513.0.0 ",
              :ip_addr => '192.168.56.102',
              :cpus => 2,
              :memory => 2048,
            }
}

Vagrant.configure("2") do |config|
  MACHINES.each do |boxname, boxconfig|
    config.vm.synced_folder ".", "/vagrant", disabled: false
    config.vm.define boxname do |box|
      box.vm.box = boxconfig[:box_name]
      box.vm.box_version = boxconfig[:box_version]
      box.vm.host_name = boxname.to_s
      box.vm.network "private_network", ip: boxconfig[:ip_addr]
      box.vm.provider "virtualbox" do |v|
        v.memory = boxconfig[:memory]
        v.cpus = boxconfig[:cpus]
      end
    end
  end
end
