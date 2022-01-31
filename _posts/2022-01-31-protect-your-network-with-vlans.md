---
layout: post
title:  "Protect your network with virtual LANs - trying out the Creality Wifi Box"
date:   2022-01-31 21:00:00 +0100
categories: 3d-printing
image: /images/blog/2022-01-31-protect-your-network-with-vlans/cover.jpg
---

Just for fun and giggles I wanted to try the Creality Wifi Box. After [Teaching Tech' critical review last year](https://www.youtube.com/watch?v=SBr0ArgDztc) I was curious how the state of the Creality Cloud ecosystem is today. The Creality Wifi Box essentially connects your printer to the Creality Cloud, and the device cannot be accessed locally. For this reason, it has no business being on my network other than to use my internet connection. So, to protect my network from any possible vulnerabilities we can use virtual LANS - VLANs. Let's see how!

<style scoped>
  img + p, img + em {
    clear: both;
    display: block;
  }
</style>

## The Situation

The image below shows the situation. I have some devices, like my computer, a home server and a Zigbee gateway. The Creality Wifi Box has no business accessing these devices. I may trust Creality, but I still want isolation of cloud-accessed devices, because you can never underestimate the internet.

![Simplified network diagram](/images/blog/2022-01-31-protect-your-network-with-vlans/Network-simplified.svg)
*Simplified network diagram. How can we make it so the Creality Wifi Box can only access the internet and not any other devices?*

In this article I will show you how to configure it in your network. However, if you don't have a switch you can skip that particular section. If you connect your device over wifi, I will show that as well.

## The Solution

There is a simple solution for this. Just run a dedicated ethernet cable to a dedicated router, or use a dedicated wireless router and connect the wifi box to that. However, this so cumbersome to have multiple devices and ethernet cables - just to isolate some devices! 

There is a good and almost free alternative for this: Virtual LANs - also known as a _vlan_. With virtual LANs each ethernet packet from a particular device is receives a tag, and will then be isolated and handled separately. *Note: The default VLAN for all devices (also the devices you are already using right now) is VLAN 1.*

![How VLANs work](/images/blog/2022-01-31-protect-your-network-with-vlans/VLAN-diagram.svg)
*The network endpoints don't necessarily need to be aware of the existence of the VLAN. The network switch can tag the traffic, and then the router can sort it out. The network packets from the Creality Wifi box is marked in <span style="color: purple;font-weight: bold">purple</span>.*

In the above diagram the network port assigns a tag "VLAN 2" to all data packets from the Creality Wifi Box. The port from my computer is not assigned any VLAN, so it defaults to VLAN 1. The packets travel together on the shared network connection between the switch and the router. The networks are not aware of each other - only the router is aware, on which the VLAN also has been configured.

## How to configure it

I will show you how to configure it. In my network I have a [Netgear GS108Ev3 managed switch](https://www.netgear.nl/support/product/gs108ev3.aspx) and an [Unifi Dream Machine](https://store.ui.com/products/unifi-dream-machine) as a router. You may have different network devices, but conceptually it all works the same. The buttons and inputs might just be in a different order 😉

### Configuring the switch

On my switch, I have my Creality Wifi Box on **port 1**, my outgoing line that eventually ends up at my router is on **port 8**. In your switch configuration interface you enable *802.1Q VLAN*. You also add the VLAN, in this case I give it VLAN the ID **2**.

![VLAN configuration in Netgear switches](/images/blog/2022-01-31-protect-your-network-with-vlans/switch-config-01.png)
*In this first step we define _that_ we want a second VLAN*

Next, we must define how each port responds to each VLAN. We call this: assigning membership to a port. We do this for each VLAN (both default and the new VLAN 2).

![VLAN configuration in Netgear switches](/images/blog/2022-01-31-protect-your-network-with-vlans/switch-config-02.png)
*VLAN 1 (default VLAN) needs all ports to be assigned as _untagged_. This means the switch will not interfere with any traffic that carries the default VLAN tag.*

![VLAN configuration in Netgear switches](/images/blog/2022-01-31-protect-your-network-with-vlans/switch-config-02b.png)
*For VLAN 2 I set port 8 (which goes to my router) as _tagged_, so traffic destined for VLAN 2 will be accepted. For port 1, which goes to the Creality Wifi Box, I set it as _untagged_ so that it may receive traffic which is untagged and can tag it (purple in the earlier diagram).*

Finally, we must tell the switch that we want all untagged traffic to receive a tag. Remember, the Creality Wifi Box doesn't know and cannot be configured to send traffic on VLAN 2, so we have the switch tag the traffic.

![VLAN configuration in Netgear switches](/images/blog/2022-01-31-protect-your-network-with-vlans/switch-config-03.png)
*We tell the switch we want all traffic from port 1 (where the Creality Wifi Box is) that has no tag, to be tagged as VLAN 2 (purple)*

That finishes the switch configuration. Now we need to tell our router that we have an additional network.

### Configuring the router

Next up, configuration of the router. The router is what brings it all together.

We need to tell the router that we have an additional network.

![Unifi - add network](/images/blog/2022-01-31-protect-your-network-with-vlans/router-config-01.png)
*Add a new network*

![Unifi - add network](/images/blog/2022-01-31-protect-your-network-with-vlans/router-config-02.png)
*I called this network __UntrustedLAN__ - you can recognize this later when setting up the firewall.*

Next is the most critical part - we assign a VLAN to this network.  We also assign a separate IP address range. When the Creality Wifi Box asks for an IP address, that request will be tagged with VLAN ID 2, and it will end up getting an address assigned in this range.

![Unifi - set network VLAN](/images/blog/2022-01-31-protect-your-network-with-vlans/router-config-03.png)
*I also assigned a domain name to this network, that's not very important.*

Next, we will make sure the firewall blocks any traffic from the VLAN 2 to our regular network.

![Unifi - set firewall](/images/blog/2022-01-31-protect-your-network-with-vlans/router-config-04.png)
*Choose to add a new rule*

![Unifi - block VLAN traffic](/images/blog/2022-01-31-protect-your-network-with-vlans/router-config-04b.png)
*__Block__ all traffic __matching our LAN__ that comes from our __VLAN 2 (UntrustedLAN)__*

That's it from the router.

### Wifi

If you like a wifi network to be isolated, then you can assign that wifi network to the network we've created earlier.

![Unifi - VLAN configuration for wifi network](/images/blog/2022-01-31-protect-your-network-with-vlans/router-config-wifi.png)
*When you assign the entire wifi network to the UntrustedLAN, it becomes part of the VLAN. You can then connect the Creality Wifi Box to that wifi network.*

## Summary

This article has shown how you can secure your network by placing isolating certain network devices to a separate virtual LAN. It is only software configuration in your router and wireless access point or switch. Afterwards, the device will be limited in what network devices it can access.

Though I have a UDM and Netgear switch, the procedure will be similar on other devices, like [OpenWRT-based devices](https://openwrt.org/docs/guide-user/network/vlan/switch_configuration). You need devices which support 802.1q based VLANs though, port based VLANs work differently and do not tag traffic. 

Happy networking!