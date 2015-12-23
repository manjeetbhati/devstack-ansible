# devstack-ansible
devstack-ansible will install required packages on remote machine
and install devstack on remote machine.

requirements:

1. make sure you have python-apt installed on remote machine
  ssh to remote machine and apt-get install python-apt

2. make sure you have ansible installed on host from where you running playbook
   on host apt-get install ansible

Steps to install devstack

1. check devstack_ansible/inventory on host
    copy ip of remote machine to 2nd line

2. copy your local.conf to devstack-ansible/files/

3. cd devstack-ansible 

   ansible-playbook -v -v -v devstack.yml
