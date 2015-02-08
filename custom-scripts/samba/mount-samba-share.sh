# Install packages
#apt-get update
apt-get install -y samba
echo -e "password\npassword" | (smbpasswd -a -s chandu)

if [ ! -d /home/chandu/www ]; then
  mkdir /home/chandu/www
  chown chandu /home/chandu/www 
fi
# Initialize samba
[ -d /etc/samba/smb.conf ] && rm /etc/samba/smb.conf

cp  /vagrant/custom-scripts/samba/smb.conf /etc/samba/smb.conf


service smbd restart