# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what




# Install required plugins
required_plugins = ["vagrant-hostsupdater"]
required_plugins.each do |plugin|
    exec "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

# Setting the function to form an env variable
def set_env vars
  command = <<~HEREDOC
      echo "Setting Environment Variables"
      source ~/.bashrc
  HEREDOC

  vars.each do |key, value|
    command += <<~HEREDOC
      if [ -z "$#{key}" ]; then
          echo "export #{key}=#{value}" >> ~/.bashrc
      fi
    HEREDOC
  end

  return command
end

# MULTI SERVER/VMs environment


Vagrant.configure("2") do |config|

# creating first VM called web
  # config.vm.define "web" do |web|
  #
  #   web.vm.box = "bento/ubuntu-18.04"
   # downloading ubuntu 18.04 image



    # web.vm.hostname = 'web'
    # assigning host name to the VM

    # web.vm.network :private_network, ip: "192.168.33.10"
    #   assigning private IP
    # web.vm.provision "shell", inline: set_env({ DB_HOST: "mongodb://vagrant@192.168.33.11:27017/posts" }), privileged: false
    # config.hostsupdater.aliases = ["development.web"]
    # creating a link called development.web so we can access web page with this link instread of an IP

    # end

# creating second VM called db
  # config.vm.define "db" do |db|
  #
  #   db.vm.box = "bento/ubuntu-18.04"
  #
  #   db.vm.hostname = 'db'
  #
  #   db.vm.network :private_network, ip: "192.168.33.11"
  #
  #   config.hostsupdater.aliases = ["development.db"]
  #   end



# creating third VM called aws using as an ansible controller
  config.vm.define "aws" do |aws|

    aws.vm.box = "bento/ubuntu-18.04"

    aws.vm.hostname = 'aws'

    aws.vm.network :private_network, ip: "192.168.33.12"

    aws.vm.synced_folder "app", "/home/vagrant/app"

    config.hostsupdater.aliases = ["development.aws"]
   end
end