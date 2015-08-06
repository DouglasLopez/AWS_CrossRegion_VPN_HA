# AWS CrossRegion VPN HA
Cloudformation template for make a HA VPN connection between two aws regions

This Cloudformation template will create a VPN between two aws regions, using openswan and amazon Linux instances, the template is make for 2 AZ per region, one independent vpn conection will be create for each AZ blue wire and red wire, the blue wire instances will be monitoring the red wire connection, and when the red wire connection goes down, the blue wire will take ownership of the connections, try to put online again rebooting the instance and wait until the connection will be reestablished, and is the same case with the red wire side.

I search everywhere for something like this and. I cannot found it, the main funcionability is pretty simple, and so if you want to collaborate with some improvement you are welcome
