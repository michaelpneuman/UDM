#!/bin/sh
hosts_dir=/run/dnsmasq.conf.d/hosts.conf
hosts_dir_pihole=/mnt/data/etc-pihole/custom.list
customFile=/mnt/data/on_boot.d/dependencies/customdns.txt

while true; do
    /mnt/data/on_boot.d/dependencies/unifi_alias.py > /tmp/current_hosts.conf
    /mnt/data/on_boot.d/dependencies/unifi_alias.py pihole > /tmp/current_hosts_pihole.conf

    cat $customFile | while read entry
    do
       echo "$entry" >> /tmp/current_hosts_pihole.conf
    done

    localVer=$(diff -Na $hosts_dir /tmp/current_hosts.conf)
    piVer=$(diff -Na $hosts_dir_pihole /tmp/current_hosts_pihole.conf)

     if ([ ! -z "$localVer" ] || [ ! -z "$piVer" ]); then
	echo "changes found"
        mv /tmp/current_hosts.conf $hosts_dir
	mv /tmp/current_hosts_pihole.conf $hosts_dir_pihole
	kill -9 `cat /run/dnsmasq.pid`
	docker exec -it pihole pihole restartdns
     fi

     sleep ${UNIFI_POLL_INTERVAL:-60}
done

