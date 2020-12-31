# UDM

## Steps

1.a. Download scripts (NEW INSTALLATION)

    
    cd /mnt/data
    curl -L https://github.com/michaelpneuman/UDM/tarball/master > udm.tar.gz
    mkdir udm_source
    tar zvxf udm.tar.gz -C udm_source --strip-components=1
    unifi-os shell
    curl -L https://raw.githubusercontent.com/boostchicken/udm-utilities/master/on-boot-script/packages/udm-boot_1.0.1-1_all.deb -o udm-boot_1.0.1-1_all.deb
    dpkg -i udm-boot_1.0.1-1_all.deb
    exit
    cd udm_source
    mv scripts/* /mnt/data/on_boot.d
    cd /mnt/data
    rm -R udm_source
    rm udm.tar.gz
    
    
1.b. Update scripts (EXISTING INSTALLATION)

    
    cd /mnt/data
    curl -L https://github.com/michaelpneuman/UDM/tarball/master > udm.tar.gz
    mkdir udm_source
    tar zvxf udm.tar.gz -C udm_source --strip-components=1
    cd udm_source
    mv scripts/* /mnt/data/on_boot.d
    cd /mnt/data
    rm -R udm_source
    rm udm.tar.gz
    

2. Modify script parameters (using VI text editor)

    ```bash
    cd /mnt/data/on_boot.d/dependencies
    vi unifi_alias.py
    ```    

    * Replace [IP] with the IP address of your UDM UniFi Controller
    * Replace [USERNAME] with the username to log into your controller
    * Replace [PASSWORD] with the password to log into your controller
    * Replace [SITE] with the site name (the standard site is called "default")

3. Set script permissions

    ```bash
    chmod +x /mnt/data/on_boot.d/*.sh
    chmod +x /mnt/data/on_boot.d/dependencies/*
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
