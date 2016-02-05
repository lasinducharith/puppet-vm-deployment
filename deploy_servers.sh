#!/bin/bash

puppet_home="/home/lasindu/wso2/puppet-modules"
key_file="/home/lasindu/wso2/key-file"
destination_path="/home/ubuntu"
user="ubuntu"

while read server_config; do
  IFS=',' read -r -a array <<< $server_config
  echo "----------------- Server Configurations -----------------"
  echo "IP: ${array[0]}"
  echo "Product Name: ${array[1]}"
  echo "Product Version: ${array[2]}"
  echo "Product Profile: ${array[3]}"
  echo "Environment: ${array[4]}"

  echo "----------------- Copying Puppet-modules to Server -----------------"
  scp -o "StrictHostKeyChecking=no" -i $key_file -r $puppet_home $user@${array[0]}:$destination_path
  
  ssh -o "StrictHostKeyChecking=no" -i $key_file $user@${array[0]} << EOF
  sudo -i
  echo "----------------- Installing puppet, unzip and tree -----------------"
  apt-get update
  apt-get -y install puppet unzip tree
  echo "----------------- Installing dependent puppet modules --------------------"
  puppet module install puppetlabs/stdlib --version 4.11.0
  puppet module install 7terminals-java --version 0.0.8
  echo "----------------- Copying files to /etc/puppet -------------------"
  cp -r $destination_path/puppet-modules/modules/* /etc/puppet/modules/
  cp -r $destination_path/puppet-modules/hieradata/ /etc/puppet/
  cp $destination_path/puppet-modules/hiera.yaml /etc/puppet/
  cp $destination_path/puppet-modules/manifests/site.pp /etc/puppet/manifests/
  echo "----------------- Exporting Facters --------------------"
  export FACTER_product_name=${array[1]}
  export FACTER_product_version=${array[2]}
  export FACTER_product_profile=${array[3]}
  export FACTER_environment=${array[4]}

  cd /etc/puppet
  echo "----------------- Run puppet apply --------------------------"
  puppet apply --modulepath=/etc/puppet/modules/ -e "include ${array[1]}" -v --detailed-exitcodes

EOF
done < server_configs.conf
