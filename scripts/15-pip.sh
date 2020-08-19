#/bin/sh
cd /tmp
curl -L https://bootstrap.pypa.io/get-pip.py -o get-pip.py
ln -s $(podman inspect unifi-os -f {{.GraphDriver.Data.MergedDir}})/usr/lib/aarch64-linux-gnu/libssl.so.1.1  /usr/lib64/
ln -s $(podman inspect unifi-os -f {{.GraphDriver.Data.MergedDir}})/usr/lib/aarch64-linux-gnu/libcrypto.so.1.1  /usr/lib64/
python get-pip.py

ln -s $(podman inspect unifi-os -f {{.GraphDriver.Data.MergedDir}})/usr/local/bin/pip3 /usr/bin/pip

pip install requests
