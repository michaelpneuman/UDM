# UDM

## Steps

1.a. Download scripts (NEW INSTALLATION)

    
    cd /data
    curl -L https://github.com/michaelpneuman/UDM/tarball/master > udm.tar.gz
    mkdir udm_source
    tar zvxf udm.tar.gz -C udm_source --strip-components=1
    curl -fsL "https://raw.githubusercontent.com/unifi-utilities/unifios-utilities/HEAD/on-boot-script/remote_install.sh" | /bin/sh
    exit
    cd udm_source
    mv scripts/* /data/on_boot.d
    cd /data
    rm -R udm_source
    rm udm.tar.gz
    
    
1.b. Update scripts (EXISTING INSTALLATION)

    
    cd /data
    curl -L https://github.com/michaelpneuman/UDM/tarball/master > udm.tar.gz
    mkdir udm_source
    tar zvxf udm.tar.gz -C udm_source --strip-components=1
    cd udm_source
    mv scripts/* /data/on_boot.d
    cd /data
    rm -R udm_source
    rm udm.tar.gz
    

2. Modify script parameters (using VI text editor)

    ```bash
    cd /data/on_boot.d/dependencies
    vi unifi_alias.py
    ```    

    * Replace [IP] with the IP address of your UDM UniFi Controller
    * Replace [USER] with the username to log into your controller
    * Replace [PASS] with the password to log into your controller
    * Replace [SITE] with the site name (the standard site is called "default")

3. Set script permissions

    ```bash
    chmod +x /data/on_boot.d/*.sh
    chmod +x /data/on_boot.d/dependencies/*
    ```

4. Reboot the controller and give it a go!


## Testing

* Create an alias for a host in the unifi controller
* Within 1-2 minutes the above scripts will automatically detect and add the hosts to DNSMASQ configurations
* You can check this is successful because there will be a new configuration file containing the host-record[s]

    ```bash
    tail /run/dnsmasq.conf.d/hosts.conf
    ```

* On your local computer, trying pinging the alias using the FQDN:  (example: ping alias.mydomain.local)
