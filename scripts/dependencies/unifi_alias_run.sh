#!/bin/sh
hosts_dir=/run/dnsmasq.conf.d/hosts.conf

while true; do
    /mnt/data/on_boot.d/dependencies/unifi_alias.py > /tmp/current_hosts.conf
    /mnt/data/on_boot.d/dependencies/unifi_alias.py pihole >> /mnt/data/etc-pihole/custom.list

     if [ $? = 0 ] && ! diff -N $hosts_dir /tmp/current_hosts.conf; then
        mv /tmp/current_hosts.conf $hosts_dir
	kill -9 `cat /run/dnsmasq.pid`
	docker exec -it pihole pihole restartdns
     fi

     sleep ${UNIFI_POLL_INTERVAL:-60}
done

