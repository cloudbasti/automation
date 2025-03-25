#!/bin/bash 

case "$1" in
	"ping")
		ansible -i inventories/inventory.yml all -m ping
		;;
	"cluster_common")
		ansible-playbook -i inventories/inventory.yml playbooks/k8_cluster_common_install.yml
		;;
	*)
		echo "Usage: $0 {ping|cluster_common}"
		exit 1
		;;
esac
