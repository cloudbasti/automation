#!/bin/bash 

case "$1" in
	"ping")
		ansible -i inventories/inventory.yml all -m ping
		;;
	"k8_cluster_foundation")
		ansible-playbook -i inventories/inventory.yml playbooks/k8_cluster_common_install.yml
		;;
        "k8_master_install")
	        ansible-playbook -i inventories/inventory.yml playbooks/k8_master_install.yml
	        ;;	
	*)
		echo "Usage: $0 {ping|k8_cluster_foundation|k8_master_install}"
		exit 1
		;;
esac
