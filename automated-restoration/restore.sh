#!/bin/bash

set -e

timestamp(){
   echo -n `date --date="8 hours" "+%Y-%m-%d %H:%M:%S,"`
}

db_name=$2
dest_full_path=$1
su_password='Dus4#Xt2N9y'
db_user='odoo'
dest_path='/backup'
filestore_path='/home/odoo/.local/share/Odoo/filestore'
sql_query="update ir_mail_server set smtp_host='@@smtp.gmail.com'"
sql_query1="update res_partner set email='aaa@gmail.com'"


# Restore the database if it is dump file or else use zip file
timestamp; echo "Restoring $db_name ..."
timestamp; echo " Unzipping the file to $dest_path."
timeout 3600 echo 'A' | tar -zxvf $dest_path'/'$dest_full_path'.tar.gz'
timestamp; echo " Unzip done."

# Change filestore name and move to filestore folder
timestamp; echo " Changing the filestore name."
timeout 10000 echo "$su_password" | mv $dest_path'/'$dest_full_path'/filestore/MARKANT_NL_prod_odoo12_v1' $filestore_path'/'$db_name
timestamp; echo " Copying the filestore folder"

# Create a new database
timestamp; echo "Create a new database named $db_name with owner $db_user!"
echo "$su_password" | sudo -S -u postgres createdb -O $db_user $db_name
timestamp; echo " Restore start."
timeout 7200 echo "$su_password" | sudo -S -u postgres pg_restore --no-acl -O --role=$db_user -v -d $db_name < $dest_path'/'$dest_full_path'/DB/MARKANT_NL_prod_odoo12_v1.dump' || true
timestamp; echo " $db_name is restored."
timeout 3600 echo "$su_password" | chown odoo:odoo $filestore_path'/'$db_name

# run the query if the user has any query
echo "$su_password" | sudo -S -u postgres psql -d $db_name -c "$sql_query"
echo "$su_password" | sudo -S -u postgres psql -d $db_name -c "$sql_query1"
timestamp; echo "Deactivated SMTP Outgoing and change partner email"

