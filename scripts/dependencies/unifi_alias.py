#!/usr/bin/python
import os
import re
import sys

import requests
from requests.packages.urllib3.exceptions import InsecureRequestWarning

requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

baseurl = os.environ.get('UNIFI_BASEURL', 'https://[IP]/proxy/network')
baseloginurl = os.environ.get('UNIFI_BASELOGINURL', 'https://[IP]')
username = os.environ.get('UNIFI_USERNAME', '[USERNAME]')
password = os.environ.get('UNIFI_PASSWORD', '[PASSWORD]')
site = os.environ.get('UNIFI_SITE', '[SITE]')
fixed_only = os.environ.get('FIXED_ONLY', False)

outformat = 'dnscmasq'

if len(sys.argv)==2:
    outformat=sys.argv[1]

def get_configured_clients(session):
    # Get configured clients
    r = session.get('%s/api/s/%s/list/user' % (baseurl,site), verify=False)
    r.raise_for_status()
    return r.json()['data']


def get_active_clients(session):
    # Get active clients
    r = session.get('%s/api/s/%s/stat/sta' % (baseurl,site), verify=False)
    r.raise_for_status()
    return r.json()['data']

def get_domain(session):
    # Get the domain names for networks
    r = session.get('%s/api/s/%s/rest/networkconf' % (baseurl,site), verify=False)
    r.raise_for_status()
    return r.json()['data']

def login():
    s = requests.Session()
    # Log in to controller
    r = s.post('%s/api/auth/login' % (baseloginurl), json={'username': username, 'password': password}, verify=False)
    r.raise_for_status()
    return s

def get_clients():
    clients = {}
    try:
        # Add clients with alias and reserved IP
        for c in get_configured_clients(s):
            if 'name' in c and 'fixed_ip' in c:
    	        clients[c['mac']] = {'name': c['name'], 'ip': c['fixed_ip']}
        if fixed_only is False:
            # Add active clients with alias
            # Active client IP overrides the reserved one (the actual IP is what matters most)
            for c in get_active_clients(s):
                if 'name' in c and 'ip' in c and 'network' in c:
                    clients[c['mac']] = {'name': c['name'], 'ip': c['ip'], 'network': c['network']}
    except:
        pass
    
    # Return a list of clients filtered on dns-friendly names and sorted by IP
    friendly_clients = [c for c in clients.values() if re.search('^[a-zA-Z0-9-]+$', c['name'])] 
    return sorted(friendly_clients, key=lambda i: i['name'])


if __name__ == '__main__':
    try:
        s = login()
        for n in get_domain(s):
            if 'domain_name' in n and n['domain_name']!="":
                for c in get_clients():
                    if 'network' in c and c['network']==n['name']:
                        if outformat=='dnsmasq':
                            print('host-record='+c['name']+'.'+n['domain_name']+','+c['ip'])
                        elif outformat=='pihole':
                            print(c['ip']+' '+c['name']+'.'+n['domain_name'])
						
    except requests.exceptions.ConnectionError:
        print('Could not connect to unifi controller at %s' % baseurl, file=sys.stderr)
        exit(1)

