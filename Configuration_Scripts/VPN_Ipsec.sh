#!/bin/bash
#this script install and configure openswan
# needed  variables

CONNECTION_NAME=
LOCAL_PRIVATE_IP=
LOCAL_PUBLIC_IP=
LOCAL_VPC_CIDR=
REMOTE_PUBLIC_IP=
REMOTE_VPC_CIDR=
PRE_SHARED_KEY=

#update and install openswan 
echo `date` "--Install and configure openswan"
/usr/bin/yum update -y && /usr/bin/yum install openswan -y
chkconfig ipsec on


# Turn on network  needed directives
echo `date` "--Turn on needed directives"

cat <<EOF >>/etc/sysctl.conf 
net.ipv4.conf.all.accept_redirects = 0 
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.eth0.send_redirects = 0
net.ipv4.conf.default.accept_redirects = 0 
net.ipv4.conf.eth0.accept_redirects = 0
EOF
sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' /etc/sysctl.conf
sysctl -p /etc/sysctl.conf

# Modify the vpn configuration file /etc/ipsec.conf
echo `date` "-- Writing $CONNECTION_NAME tunnel Settings"

sed -i "s~virtual_private=~virtual_private=%v4:$LOCAL_VPC_CIDR,%v4:$REMOTE_VPC_CIDR ~g" /etc/ipsec.conf
cat <<EOF >>/etc/ipsec.conf
conn $CONNECTION_NAME
   authby=secret
   auto=start
   type=tunnel
   left=$LOCAL_PRIVATE_IP
   leftid=$LOCAL_PUBLIC_IP
   leftsubnet=$LOCAL_VPC_CIDR
   right=$REMOTE_PUBLIC_IP
   rightsubnet=$REMOTE_VPC_CIDR
   ike=aes256-sha1;modp2048
   phase2=esp
   phase2alg=aes256-sha1;modp2048
EOF
echo `date` "-- Writing $CONNECTION_NAME vpn security pre-shared key"
/bin/echo "$LOCAL_PUBLIC_IP $REMOTE_PUBLIC_IP:PSK \"$PRE_SHARED_KEY\"" >>/etc/ipsec.secrets

# Configure NAT for vpn traffic
echo `date` "--Modify the vpn configuration file"

iptables --table nat --append POSTROUTING --source $LOCAL_VPC_CIDR -j MASQUERADE


echo `date` "-- Configuration successfully"
