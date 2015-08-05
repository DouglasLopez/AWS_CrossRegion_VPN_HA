# AWS_CrossRegion_VPN_HA
Cloudformation template for make a HA VPN connection between two aws regions

This Cloudformation template will create a VPN between two aws regions, using openswan and amazon linux instances, the template is make for 2 AZ per region, one independent vpn conection will be create for each AZ blue wire and red wire, the blue wire instances will be monitoring the red wire conection, and when the red wire conection goes down, the blue wire will take ownership of the conections, try to put online again rebooting the instance and wait until the conection will be restablished, and is the same case with the red wire side.
