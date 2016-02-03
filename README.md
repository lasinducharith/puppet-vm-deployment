# puppet-vm-deployment

A single shell script to deploy wso2 products in the cloud via puppet

## What does it do?

Once you prepare the puppet modules and hieradata, this script will ..

 - Install required bundles (puppet/unzip) in the remote instance
 - Install dependent puppet modules (stdlib/java)
 - copy puppet modules and hieradata from local machine to remote server
 - export facters
 - Run puppet (puppet apply): does not use a puppet master

## How to use

1. Clone puppet-vm-deployment repository

   ````
   git clone https://github.com/lasinducharith/puppet-vm-deployment.git
   ````

2. Clone WSO2 puppet modules repository and consider this path in local machine as puppet_home:

   ````
   git clone https://github.com/wso2/puppet-modules.git
   ````

3. Download and copy Oracle JDK 1.7 distribution to the following path:

    ````
    [puppet_home]/modules/wso2base/files/jdk-7u80-linux-x64.tar.gz
    ````

4. Download and copy required product distributions, patches, dropins etc. to each puppet module
    
    ````
    [puppet_home]/modules/wso2esb/files
    [puppet_home]/modules/wso2am/files
    [puppet_home]/modules/wso2as/files
    ````

5. Update puppet_home/hieradata with hostnames, ipaddresses and other configuration information
    
    ````
    [puppet_home]/hieradata/dev/wso2/wso2esb/4.9.0
    [puppet_home]/hieradata/dev/wso2/wso2am/1.9.0
    ````

6. Update server configuration details in server_configs.txt. You can include details of each server instance, starting from a new line
    
    ````
    #instance_ip,product_name,product_version,product_profile,environment
    192.168.100.1,wso2esb,4.9.0,manager,dev
    192.168.100.2,wso2esb,4.9.0,worker,dev
    ````

7. Update puppet_home, key_file, destination_path, user in deploy_servers.sh

8. Execute deploy_servers.sh
