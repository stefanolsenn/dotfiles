#!/bin/bash -e
search=${@}
docker_mgr="alpha-m-1"
cmd="ssh $docker_mgr docker service ls"

for s in $search; do
	cmd+="| grep $s"
done

cmd+="| awk -F' ' '{print \$1}'"

docker_service_id=$(eval ${cmd})

echo "$docker_service_id"
