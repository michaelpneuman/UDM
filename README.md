# UDM

## Steps

1. Get into the unifios shell on your udm

    ```bash
    unifi-os shell
    ```

2. Download [udm-boot_1.0.1-1_all.deb](packages/udm-boot_1.0.1-1_all.deb) and install it and go back to the UDM

    ```bash
    curl -L https://github.com/michaelpneuman/UDM/blob/master/udm-boot_1.0.1-1_all.deb -o udm-boot_1.0.1-1_all.deb
    dpkg -i udm-boot_1.0.1-1_all.deb
    exit
    ```

3. Create directory structure

    ```bash
    cd /mnt/data/on_bood.d
    mkdir dependencies
    ```

4. Download scripts

5. Modify script parameters (using VI text editor)

    Replace [IP] with the IP address of your UDM UniFi Controller
    Replace [USERNAME] with the username to log into your controller
    Replace [PASSWORD] with the password to log into your controller
    Replace [SITE] with the site name (the standard site is called "default")

6. Set script permissions

    ```bash
    chmod +x *.sh
    chmod +x dependencies/*.sh
    ```

7. Reboot the controller and give it a go!


## Testing

* Create an alias for a host in the unifi controller
* Within 1-2 minutes the above scripts will automatically detect and add the hosts to DNSMASQ configurations
* On your local computer, trying pinging the alias using the FQDN:  (example: ping alias.mydomain.local)