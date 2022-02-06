---
layout: post
title:  "How-to: Set-up a site-to-site IPSec connection with Ubiquiti Edgerouter and NAT translation/masking"
date:   2017-07-22 10:00:00 +0100
categories: it-management ubiquity edgeos ipsec site-to-site vpn
---

To connect business networks to each other a site-to-site IPSec is often employed. An IPSec connection is widely supported by corporate routing appliances like Cisco ASA, Sonicwall, Kerio and others. In some cases the remote and local subnet may overlap. In that case you need to use NAT translation to virtual IP addresses. This guide will show you how you can set-up an IPSec connection using NAT translation with a Ubiquiti Edgerouter to a Cisco ASA.

## The case
We start with the case [from the previous guide](/blog/2017/07/21/setup-site-to-site-ipsec-vpn-with-edgerouter-cisco-asa). 

![Network diagram - Cisco ASA vs EdgeRouter IPSec](/images/blog/2017-07-21-setup-site-to-site-ipsec-vpn-with-edgerouter-cisco-asa/diagram.png)

To recap:
- The Edgerouter is NATted behind the ISP modem. 
- The public IP address of the EdgeRouter and modem is 99.99.99.99. 
- The internal NAT network between Edgerouter and the ISP modem is 192.15.1.0/24. 
- The local LAN behind the EdgeRouter is 10.0.0.0/24. 
- In addition, we allow collegues working at home to connect using OpenVPN. Those users are connected through the 192.168.179/28 subnet. 

We need to set-up a classic IPSec connection to a Cisco ASA gateway at 88.88.88.88. We also like the VPN users of the 192.168.179/28 subnet to be able to the resources at 88.88.88.88.

The following information is agreed upon about the IPSec connection:

**Allowed remote subnets** | 10.16.71.0/24 ; 10.16.74.0/24 ; 10.16.75.0/24 ; 10.16.191.0/24
**Allowed local subnets**  | _10.1.65.0/24_ (10.0.0.0/24 is not possible)
**Authentication**         | Pre-shared secret ABCDEF123
**ESP encryption and hash**| AES256 / SHA1
**ESP lifetime**		   | 3600
**IKE encryption and hash**| AES256 / SHA1
**IKE lifetime**		   | 86400
**Mode**				   | Tunnel

Note that we translate our internal IP network 10.0.0.0/24 to 10.1.65.0/24. 

## Set-up some definitions
In Edgerouter you can define networks and address ranges as groups, so you do not have to redefine them everywhere.  Let's do that first. In addition to the [network groups of the previous guide](/blog/2017/07/21/setup-site-to-site-ipsec-vpn-with-edgerouter-cisco-asa#set-up-some-definitions), set-up the network group representing our translated IP addresses:

	set firewall group network-group vpn-cisco-asa-virtual-ip-net description 'Virtual IP range for Cisco-ASA B2B IPSec VPN'
	set firewall group network-group vpn-cisco-asa-virtual-ip-net network 10.1.65.0/24

## Set-up the VPN connection
Please refer to the [previous guide](/blog/2017/07/21/setup-site-to-site-ipsec-vpn-with-edgerouter-cisco-asa#set-up-the-vpn-connection) to set-up the IKE and ESP groups.

Set-up the VPN tunnels. Note we refer to our translated subnet here:

	set vpn ipsec site-to-site peer 88.88.88.88 tunnel 0 local prefix 10.1.65.0/24
	set vpn ipsec site-to-site peer 88.88.88.88 tunnel 0 remote prefix 10.16.71.0/24
	set vpn ipsec site-to-site peer 88.88.88.88 tunnel 1 local prefix 10.1.65.0/24
	set vpn ipsec site-to-site peer 88.88.88.88 tunnel 1 remote prefix 10.16.74.0/24
	set vpn ipsec site-to-site peer 88.88.88.88 tunnel 2 local prefix 10.1.65.0/24
	set vpn ipsec site-to-site peer 88.88.88.88 tunnel 2 remote prefix 10.16.75.0/24
	set vpn ipsec site-to-site peer 88.88.88.88 tunnel 3 local prefix 10.1.65.0/24
	set vpn ipsec site-to-site peer 88.88.88.88 tunnel 3 remote prefix 10.16.191.0/24

## Set-up the firewall and external gateway
Do not forget to set-up the [firewall too](/blog/2017/07/21/setup-site-to-site-ipsec-vpn-with-edgerouter-cisco-asa#set-up-the-vpn-connection#set-up-the-firewall) too.

## Set-up NAT
This is where the real NAt trickery comes in. We need first to translate our own IP addresses to the agreed virtual network. 

First, ensure your WAN masquerading rule is the last rule in the list:

	set service nat rule 5100 description 'WAN outbound traffic'
	set service nat rule 5100 outbound-interface eth1
	set service nat rule 5100 type masquerade

Translate internal LAN ip network 10.0.0.0/24 to 10.1.65.0/24. Unfortunately we cannot use network groups here, so we need to define the IP networks explicitly.

	set service nat rule 5001 destination group network-group cisco-asa-vpn-network-tunnels
	set service nat rule 5001 outbound-interface eth1
	set service nat rule 5001 outside-address address 10.1.65.0/24
	set service nat rule 5001 protocol all
	set service nat rule 5001 source address 10.0.0.0/24
	set service nat rule 5001 type source

If we would not define an additional NAT rule, this NAT rule would also apply for our IPSec traffic. This means the traffic to our external subnets would get masqueraded and Strongswan would not kick-in and encrypt our traffic. Instead, the traffic would get masquerades and send to the ISP modem which wouldn't know what to do with it.

	set service nat rule 5002 description 'Exclude IPSec packets from masquerade NAT'
	set service nat rule 5002 destination group network-group cisco-asa-vpn-network-tunnels
	set service nat rule 5002 exclude
	set service nat rule 5002 outbound-interface eth1
	set service nat rule 5002 protocol all
	set service nat rule 5002 source group network-group vpn-cisco-asa-virtual-ip-net
	set service nat rule 5002 type masquerade

Note the rule number (5002) is lower than the masquerading rule (5100). With the `exclude` directive we exclude the rule from being NATted further. Also note translation rule 5001 comes before the exclusion rule 5002.

In addition, we need to translate incoming connections from the virtual IP to the local LAN:
	
	set service nat rule 15 destination address 10.1.65.0/24
	set service nat rule 15 inbound-interface eth1
	set service nat rule 15 inside-address address 10.0.0.0/24
	set service nat rule 15 protocol all
	set service nat rule 15 source group network-group cisco-asa-vpn-network-tunnels
	set service nat rule 15 type destination

## Enable OpenVPN users to access the IPSec tunnel
By default, OpenVPN users would not be able to access the remote subnets because their traffic originates from the 192.168.179.0/28 subnet. We need to masquerade, so it looks like they come from the 10.1.65.0/24 subnet. We can add a NAT rule for that. 

	set service nat rule 5000 destination group network-group cisco-asa-vpn-network-tunnels
	set service nat rule 5000 outbound-interface eth1
	set service nat rule 5000 outside-address address 10.1.65.1
	set service nat rule 5000 protocol all
	set service nat rule 5000 source group network-group openvpn-users
	set service nat rule 5000 type source

We sacrifice local IP address 10.0.0.1 to act on behalf of the VPN users. VPN users will be seen on the remote network as 10.0.0.1. 

Complete the configuration and exit configuration mode:

	commit
	save
	exit

## Testing the VPN connection
If you run the VPN diagnostic commands you get no output:

	show vpn ipsec sa

This happens because the VPN tunnel is lazily initialized. If no traffic is generated to the remote subnets the tunnel is not initialized. Try pinging to a host at the other side from a host in your local LAN or use the following command:

	/bin/ping -I 10.0.0.4 10.16.71.7

We instruct the OS to ping from the LAN interface (br0) to 10.16.71.7. The ping will originate from the LAN IP 10.0.0.4, which it translated by NAT to 10.1.65.4 and is then be routed through the tunnel. 

If the ping is successful you should see that the VPN tunnel is now online:

	show vpn ipsec sa

You can also see the NAT translations in effect:

	sebastiaan@router:~$ show nat translations source address 10.0.0.4
	Pre-NAT src          Pre-NAT dst        Post-NAT src         Post-NAT dst
	10.0.0.4             10.16.71.7         10.1.65.4            10.16.71.7

## Troubleshooting
Please refer to [the previous guide](/blog/2017/07/21/setup-site-to-site-ipsec-vpn-with-edgerouter-cisco-asa#troubleshooting) for general IPSec troubleshooting. 

### No IKE is attempted
In troubleshooting the IPSec connection we have extra complexity to take into account. As mentioned earlier the IPSec tunnel is lazily initialized. If the NAT translation rules are incorrect no connection might be set-up because no packets come from subnet 10.1.65.0/24.

When you find no internet key exchange is happening (because `swanctl --log` does not output anything), your NAT translation rules might be wrong. To diagnose this, first disable your NAT translation rules, then set-up a pseudo-ethernet interface in the virtual IP subnet.

	set interfaces pseudo-ethernet peth0 address 10.1.65.4/24
	set interfaces pseudo-ethernet peth0 link eth1
	commit

Then ping an address on the other side using that interface:

	/bin/ping -I 10.1.65.4 10.16.71.7

If you find that the connection is now properly set-up, check your NAT rules. All NAT rules are set-up internally using `iptables`, so you might want to start troubleshooting there.

	sudo -i
	iptables -t nat -L PREROUTING
	iptables -t nat -L POSTROUTING

The above command will dump the translation tables for DNAT ("PREROUTING") and SNAT ("POSTROUTING"). I started by manually adding a rule for my internal host 10.0.0.33 in both tables.

	iptables -t nat -I PREROUTING 1 -d 10.1.65.33 -j DNAT --to-destination 10.0.0.33
	iptables -t nat -I POSTROUTING 1 -s 10.0.0.33 -j SNAT --to-source 10.1.65.3

After that I was able to ping from 10.0.0.33. So clearly something was wrong with the NAT rules. Explore every jump that is made in the iptables rules. For instance:

	root@router# iptables -t nat -L UBNT_VPN_IPSEC_SNAT_HOOK
	Chain UBNT_VPN_IPSEC_SNAT_HOOK (1 references)
	target prot opt source destination
	ACCEPT all -- 10.0.0.0/24 10.16.71.0/24
	ACCEPT all -- 10.1.65.0/24 10.16.74.0/24
	ACCEPT all -- 10.1.65.0/24 10.16.75.0/24
	ACCEPT all -- 10.1.65.0/24 10.16.191.0/24

As you can see, the top rule is wrong. This might be a bug (currently chatting with Ubiquiti support about that). Adding the correct rule and deleting the incorrect rule: 

	iptables -t nat -I UBNT_VPN_IPSEC_SNAT_HOOK 1 -s 10.1.65.0/24 -d 10.16.71.0/24 -j ACCEPT
	iptables -t nat -D UBNT_VPN_IPSEC_SNAT_HOOK 2

After this the VPN was fully up and running!

## Wrapping up
In this guide you have read how you can set-up an IPSec connection from EdgeOS to a Cisco ASA appliance, with the Edgerouter being NATted. In addition we have seen how we can translate our internal IP range to a virtual IP range in order to mitigate overlapping subnets. I had spent quite a lot of time setting this up, due to missing examples online so I hope this is useful to someone!
