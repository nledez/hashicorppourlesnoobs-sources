#!/bin/bash
WORKSPACE=$1
shift

case "${WORKSPACE}" in
	"staging")
		echo "work on ${WORKSPACE}"
		;;
	"prod")
		echo "work on ${WORKSPACE}"
		;;
	*)
		echo "Unknown workspace ${WORKSPACE}"
		exit 1
esac

source ovh.sh
terraform workspace select ${WORKSPACE}
terraform apply -var-file=${WORKSPACE}.tfvars $@
