#!/bin/bash
#update and Cai app can thiet
sudo apt install -y nano

sudo apt install -y git python3 python3-pip build-essential wget curl
sudo apt install python3.12-dev -y
sudo apt install -y python3-dev python3-venv libxml2-dev libxslt1-dev zlib1g-dev libsasl2-dev
sudo apt install -y libldap2-dev libjpeg-dev libpq-dev libffi-dev libtiff5-dev libopenjp2-7-dev
sudo apt install -y liblcms2-dev libfreetype6-dev libwebp-dev libharfbuzz-dev libfribidi-dev
sudo apt install -y libxcb1-dev libpng-dev
sudo apt install build-essential -y
sudo apt install libpq-dev -y
sudo apt install libssl1.1
sudo apt update && sudo apt upgrade -y
wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.24_amd64.deb
sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2.24_amd64.deb

#Cai dat postgresql
sudo apt install -y postgresql

#Tao user Cho odoo
sudo -u postgres createuser -s odoo

#Tao user va foder cho odoo
sudo adduser --system --home=/opt/odoo --group odoo

#Tao Moi Truong Python
sudo mkdir /opt/odoo
sudo chown odoo:odoo /opt/odoo
sudo -u odoo python3 -m venv /opt/odoo/venv

#Clone odoo 1 phien ban moi nhat
sudo -u odoo git clone https://www.github.com/odoo/odoo --depth 1 --branch 18.0 /opt/odoo/odoo

#Cai dat python Full
sudo -u odoo /opt/odoo/venv/bin/pip install wheel
sudo -u odoo /opt/odoo/venv/bin/pip install -r /opt/odoo/odoo/requirements.txt


#Cai wkhtmltopdf(xuất PDF)
sudo apt install -y xfonts-75dpi xfonts-base
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb
sudo apt install -y ./wkhtmltox_0.12.6-1.focal_amd64.deb

#Tạo file cấu hình Odoo
cat > /etc/odoo.conf <<EOF
[options]
; Database
db_host = False
db_port = False
db_user = odoo
db_password = False

; Paths
addons_path = /opt/odoo/odoo/addons
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
