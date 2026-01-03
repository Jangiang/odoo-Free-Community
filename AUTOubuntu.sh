#!/bin/bash
#update and Cai app can thiet
sudo apt install -y nano git python3 python3-pip build-essential wget curl python3.12-dev python3-dev python3-venv libx>
wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.24_amd64.deb
sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2.24_amd64.deb
sudo apt update && sudo apt upgrade -y
sudo apt install firewalld -y
sudo firewall-cmd --zone=public --add-port=8069/tcp --permanent
sudo firewall-cmd --reload
#Tao user Cho odoo
sudo -u postgres createuser -s odoo
sudo adduser --system --home=/opt/odoo --group odoo

#Tao Thư Mục addons_Custom
sudo mkdir -p /mnt/odoo/addons
sudo chown -R odoo:odoo /mnt/odoo/addons
sudo chmod -R 755 /mnt/odoo/addons
#Tao Moi Truong Python
sudo mkdir /opt/odoo
sudo chown odoo:odoo /opt/odoo
sudo -u odoo python3 -m venv /opt/odoo/venv
sudo -u odoo git clone https://www.github.com/odoo/odoo --depth 1 --branch 18.0 /opt/odoo/odoo
sudo -u odoo /opt/odoo/venv/bin/pip install wheel
sudo -u odoo /opt/odoo/venv/bin/pip install -r /opt/odoo/odoo/requirements.txt
#Tạo file cấu hình Odoo
cat > /etc/odoo.conf <<EOF
[options]
; Database
db_host = False
db_port = False
db_user = odoo
db_password = False
passwd_admin = giangquynh2001
; Paths
addons_path = /opt/odoo/odoo/addons,/mnt/odoo/addons
logfile = /var/log/odoo.log
EOF
sudo chown odoo:odoo /etc/odoo.conf
#Tao service cho odoo
cat > /etc/systemd/system/odoo.service <<EOF
[Unit]
Description=Odoo
After=network.target postgresql.servnanice
[Service]
Type=simple
User=odoo
ExecStart=/opt/odoo/venv/bin/python3 /opt/odoo/odoo/odoo-bin -c /etc/odoo.conf
Restart=always
[Install]
WantedBy=multi-user.target
EOF
sudo -u odoo /opt/odoo/venv/bin/pip install Babel
sudo systemctl daemon-reexec

sudo systemctl enable --now odoo
