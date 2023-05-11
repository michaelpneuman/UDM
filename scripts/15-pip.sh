#/bin/sh
cd /tmp
curl -sSL https://bootstrap.pypa.io/pip/3.5/get-pip.py -o get-pip.py
python get-pip.py

pip install requests
