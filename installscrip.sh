# !/bin/bash
echo  "ACTUALIZANDO UBUNTU" 
sudo apt update && sudo apt upgrade -y
clear
echo -e "INSTALANDO DEPENDECIAS NESESARIAS ODOO Y FACTURACCION ELECTRONICA"
sleep 3s
sudo apt-get install python3 python3-pip -y
sudo apt-get install wget git bzr python-pip gdebi-core -y
sudo apt-get install libpq-dev python-dev
sudo apt-get install python-pypdf2 python-dateutil python-feedparser python-ldap python-libxslt1 python-lxml python-mako python-openid python-psycopg2 python-pybabel python-pychart python-pydot python-pyparsing python-reportlab python-simplejson python-tz python-vatnumber python-vobject python-webdav python-werkzeug python-xlwt python-yaml python-zsi python-docutils python-psutil python-mock python-unittest2 python-jinja2 python-pypdf python-decorator python-requests python-passlib python-pil -y
sudo pip3 install pypdf2 Babel passlib Werkzeug decorator python-dateutil pyyaml psycopg2 psutil html2text docutils lxml pillow reportlab ninja2 requests gdata XlsxWriter vobject python-openid pyparsing pydot mock mako Jinja2 ebaysdk feedparser xlwt psycogreen suds-jurko pytz pyusb greenlet xlrd
echo -e "\n---- Install python libraries ----"
# This is for compatibility with Ubuntu 16.04. Will work on 14.04, 15.04 and 16.04
sudo apt-get install python3-suds
echo -e "\n--- Install other required packages"
sudo apt-get install node-clean-css -y
sudo apt-get install node-less -y
sudo apt-get install python-gevent -y
sudo apt-get install libssl-dev libxml2-dev libxmlsec1-dev build-essential libssl-dev libffi-dev python3-dev python-suds swig python-dev python-cffi libxml2-dev libxslt1-dev libssl-dev python-lxml python-cryptography python-openssl python-certifi python-defusedxml python3-pip wget -y
sudo apt-get install python3-pip -y
sleep 3s
clear
echo -e "descargando e installdo script odoo 11"
sudo wget https://raw.githubusercontent.com/Yenthe666/InstallScript/11.0/odoo_install.sh
sudo chmod +x odoo_install.sh
sudo ./odoo_install.sh
echo "Odoo 11 Instalado"
sleep 3s
clear
echo "INICIO GIT CLONE repos DTE"
cd /odoo/custom/addons
echo -e "Clonando mudulos en /odoo/custom/addons"
sleep 3s
sudo git clone --branch 11.0 https://gitlab.com/dansanti/l10n_cl_dte_point_of_sale.git
sudo git clone --branch 11.0 https://gitlab.com/dansanti/l10n_cl_fe.git
sudo git clone --branch 11.0 https://gitlab.com/dansanti/payment_khipu.git
sudo git clone --branch 11.0 https://gitlab.com/dansanti/payment_webpay.git
#sudo git clone https://gitlab.com/dansanti/l10n_cl_stock_picking.git
sudo git clone --branch 11.0 https://github.com/OCA/reporting-engine.git 
sudo git clone --branch 11.0 https://github.com/KonosCL/addons-konos.git
#sudo mv addons-konos/l10n_cl_chart_of_account/ /odoo/custom/addons/
#sudo rm -rf addons-konos/
echo "AGREGANDO PERMISOS CARPETA ADDONS"
sleep 3s
##fixed parameters
#odoo
OE_USER="odoo"
OE_HOME="/$OE_USER"
OE_HOME_EXT="/$OE_USER/${OE_USER}-server"
#The default port where this Odoo instance will run under (provided you use the command -c in the terminal)
#Set to true if you want to install it, false if you don't need it or have it already installed.
INSTALL_WKHTMLTOPDF="True"
#Set the default Odoo port (you still have to use -c /etc/odoo-server.conf for example to use this.)
OE_PORT="8069"
#Choose the Odoo version which you want to install. For example: 11.0, 10.0, 9.0 or saas-18. When using 'master' the master version will be installed.
#IMPORTANT! This script contains extra libraries that are specifically needed for Odoo 11.0
OE_VERSION="11.0"
# Set this to True if you want to install Odoo 11 Enterprise!
IS_ENTERPRISE="False"
#set the superadmin password
OE_SUPERADMIN="admin"
OE_CONFIG="${OE_USER}-server"
sudo rm -f /etc/odoo-server.conf
echo -e "* Create server config file"
sudo touch /etc/${OE_CONFIG}.conf
echo -e "* Creating server config file"
sudo su root -c "printf '[options] \n; This is the password that allows database operations:\n' >> /etc/${OE_CONFIG}.conf"
sudo su root -c "printf 'admin_passwd = ${OE_SUPERADMIN}\n' >> /etc/${OE_CONFIG}.conf"
sudo su root -c "printf 'xmlrpc_port = ${OE_PORT}\n' >> /etc/${OE_CONFIG}.conf"
sudo su root -c "printf 'logfile = /var/log/${OE_USER}/${OE_CONFIG}.log\n' >> /etc/${OE_CONFIG}.conf"
if [ $IS_ENTERPRISE = "True" ]; then
    sudo su root -c "printf 'addons_path=${OE_HOME}/enterprise/addons,${OE_HOME_EXT}/addons\n' >> /etc/${OE_CONFIG}.conf"
else
    sudo su root -c "printf 'addons_path=${OE_HOME_EXT}/addons,${OE_HOME}/custom/addons,${OE_HOME}/custom/addons/reporting-engine,${OE_HOME}/custom/addons/addons-konos\n' >> /etc/${OE_CONFIG}.conf"
fi
sudo chown $OE_USER:$OE_USER /etc/${OE_CONFIG}.conf
sudo chmod 640 /etc/${OE_CONFIG}.conf
echo -e "REINICIANDO SERVICIO ODOO"
sleep 3s
cd /odoo/custom/addons
sudo pip3 install client
sudo pip3 install pyOpenSSL
sudo wget https://raw.githubusercontent.com/tdcomcl/Script_instalar_odoo11_dte/master/requirements.txt
sudo pip3 install -r requirements.txt
sudo chown -R odoo: /odoo/custom/addons/* 
sudo chmod +x /odoo/custom/addons/*
sudo /etc/init.d/odoo-server stop
sleep 3s
sudo /etc/init.d/odoo-server start
clear
ls -l
sleep 2s
echo
echo
echo -e "* Starting Odoo Service"
sudo su root -c "/etc/init.d/$OE_CONFIG stop"
sleep 5s
sudo su root -c "/etc/init.d/$OE_CONFIG start"
echo "-----------------------------------------------------------"
echo "Done! The Odoo server is up and running. Specifications:"
echo "Port: $OE_PORT"
echo "User service: $OE_USER"
echo "User PostgreSQL: $OE_USER"
echo "Code location: $OE_USER"
echo "Addons folder: $OE_USER/$OE_CONFIG/addons/"
echo "Start Odoo service: sudo service $OE_CONFIG start"
echo "Stop Odoo service: sudo service $OE_CONFIG stop"
echo "Restart Odoo service: sudo service $OE_CONFIG restart"
echo "-----------------------------------------------------------"
echo
echo -e "Iniciando LOGS"
sleep 2s
tailf /var/log/odoo/odoo-server.log

