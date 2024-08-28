#!/bin/bash -e
search=${@}

usage() {
	echo "Usage: docker-service-id [search-term(s)]"
	echo
	echo "Description:"
	echo "  This script searches for Docker service IDs based on the provided search terms."
	echo
	echo "Arguments:"
	echo "  search-term(s)  One or more terms to search for within Docker service names."
	echo
	echo "Examples:"
	echo "  docker-service-id my-service"
	echo "  docker-service-id service-name feature-hash"
}

# If no search terms are provided, display the usage instructions
if [[ $search == '' ]]; then
	usage
	exit 1
fi
docker_mgr="alpha-m-1"
cmd="ssh $docker_mgr docker service ls"

for s in $search; do
	cmd+="| grep $s"
done

cmd+="| awk -F' ' '{print \$1}'"

docker_service_id=$(eval ${cmd})

echo "$docker_service_id"
