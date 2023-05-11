#!/bin/sh
hosts_dir=/run/dnsmasq.conf.d/hosts.conf
customFile=/data/on_boot.d/dependencies/customdns.txt

while true; do
    /data/on_boot.d/dependencies/unifi_alias.py > /tmp/current_hosts.conf
    /data/on_boot.d/dependencies/unifi_alias.py pihole > /tmp/current_hosts_pihole.conf

    cat $customFile | while read entry
    do
       echo "$entry" >> /tmp/current_hosts_pihole.conf
    done

    localVer=$(diff -Na $hosts_dir /tmp/current_hosts.conf)

    if ([ ! -z "$localVer" ] || [ ! -z "$piVer" ]); then
	    echo "changes found"
        mv /tmp/current_hosts.conf $hosts_dir
	    kill -9 `cat /run/dnsmasq.pid`
    fi

    sleep ${UNIFI_POLL_INTERVAL:-60}
done

