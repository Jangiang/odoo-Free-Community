#!/bin/sh
set -ex



cat > /etc/init.d/start-odoo <<EOF
#!/sbin/openrc-run

name="start-odoo"
description="Start custom Odoo script at boot"

command="/root/start.sh"
command_user="root:root"
pidfile="/run/start-odoo.pid"

depend() {
    need postgresql
}

start_pre() {
    echo "Starting Odoo script..."
}
EOF
chmod +x /etc/init.d/start-odoo
rc-update add start-odoo default

cat > /root/start.sh <<EOF
#!/bin/sh
# /opt/start-odoo.sh
# Script này s? ch?y khi boot, start Odoo
# Start postgresql
rc-service postgresql start
# Start Odoo
source /opt/odoo/venv/bin/activate
/opt/odoo/venv/bin/python /opt/odoo/odoo-bin -c /etc/odoo.conf
EOF
chmod +x start.sh

echo "Sua repositories"
cat > /etc/apk/repositories <<EOF
#/media/cdrom/apks
http://dl-cdn.alpinelinux.org/alpine/v3.22/main
http://dl-cdn.alpinelinux.org/alpine/v3.22/community
EOF

#Cai Dat Full APP
echo "Cai Dat APP"
apk update || true
apk add --no-cache libressl-dev pango-dev cairo-dev fribidi-dev harfbuzz-dev harfbuzz-dev tk-dev  tcl-dev libwebp-dev openjpeg-dev  lcms2-dev tiff-dev freetype-dev jpeg-dev zlib-dev python3-dev py3-pip build-base libffi-dev  postgresql-dev musl-dev openldap-dev git python3 py3-pip py3-setuptools py3-wheel build-base libxslt-dev bzip2-dev zlib-dev openldap-dev jpeg-dev freetype-dev postgresql15 postgresql15-client postgresql15-dev nodejs npm || true
# Fix Loi Init
echo "Cai Dat TIME Fix Loi cho Postgres"
apk add tzdata || true
cp /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime || true
echo "Asia/Ho_Chi_Minh" > /etc/timezone || true
# Init database và ghi log
rm -rf /var/lib/postgresql/data/* || true
su - postgres -c "initdb -D /var/lib/postgresql/data --locale=en_US.UTF-8 --encoding=UTF8 --data-checksums" || true
chown -R postgres:postgres /var/lib/postgresql/data || true
chmod 700 /var/lib/postgresql/data || true
# Thêm service và start PostgreSQL
rc-update add postgresql || true
rc-service postgresql start || true
# Taoo user root
su - postgres -c "createuser -s root" || true
echo "FIX LOI POSTGRES THANH CONG"
#Cai dat odoo18
echo "Cai Dat odoo18"
cd /opt
git clone --depth 1 --branch 18.0 https://github.com/odoo/odoo.git odoo || true
python3 -m venv /opt/odoo/venv || true
source /opt/odoo/venv/bin/activate || true
cd /opt/odoo
pip install -r requirements.txt || true
echo "Cai Dat odoo Hoan Tat"
#Tao file config
echo "Sua /etc/odoo.conf"
cat > /etc/odoo.conf <<EOF
[options]
addons_path = /opt/odoo/addons
data_dir = /var/lib/odoo
db_user = root
db_password = False
xmlrpc_port = 8069
EOF
/opt/odoo/venv/bin/python /opt/odoo/odoo-bin -c /etc/odoo.conf





