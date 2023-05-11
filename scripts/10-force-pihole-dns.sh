#!/bin/bash

## configuration variables:
IPV4_IP="[DNSIP]"

FORCED_INTFC="[INTERFACE]"

# (optional) IPv4 force DNS (TCP/UDP 53) through DNS container
for intfc in ${FORCED_INTFC}; do
  if [ -d "/sys/class/net/${intfc}" ]; then
    for proto in udp tcp; do
      #prerouting_rule="PREROUTING -i ${intfc} -p ${proto} ! -s ${IPV4_IP} ! -d ${IPV4_IP} --dport 53 -j LOG --log-prefix [DNAT-${intfc}-${proto}]"
      #iptables -t nat -C ${prerouting_rule} 2>/dev/null || iptables -t nat -A ${prerouting_rule}
      prerouting_rule="PREROUTING -i ${intfc} -p ${proto} ! -s ${IPV4_IP} ! -d ${IPV4_IP} --dport 53 -j DNAT --to ${IPV4_IP}"
      iptables -t nat -C ${prerouting_rule} 2>/dev/null || iptables -t nat -A ${prerouting_rule}
    done
  fi
done
