---
layout: post
title:  "How-to: Implement RADIUS authentication on EdgeOS"
date:   2017-07-10 20:00:00 +0100
categories: it-management ubiquity edgeos openvpn
---

You can secure your OpenVPN implementation by linking it to your Windows domain. In that way you avoid the hassle of managing multiple certificates while still securing the connection by using a secure login. You can also manage the users right from Active Directory, granting and revoking access as you see fit. This authentication solution can be implemented using RADIUS.

## Set-up RADIUS authentication in Windows Server
You need an domain controller running Windows Server 2008 or greater. Install the role "Network Policy and Access Services". This will enable you to configure a RADIUS server. Once installed, probably following a reboot, we can start configuring RADIUS.

We will now allow RADIUS requests from the Ubiquiti. Navigate to "Network Policy and Access Services", "NPS", "Radius clients and servers", "Radius clients". Right click on the node and select "New".

![Windows RADIUS set-up - part 1](/images/blog/2017-07-10-how-to-implement-radius-authentication-openvpn-edgeos/windows-p1.png)

A dialog will open. You need to enter the RADIUS Client a name, generate a secure secret and enter an IP address of DNS name. If the DNS name is resolved by the server running the RADIUS server it should be no problem to enter an DNS name. 

![Windows RADIUS set-up - part 2](/images/blog/2017-07-10-how-to-implement-radius-authentication-openvpn-edgeos/windows-p2.png)

Complete the form and save the RADIUS Client. Next, we need to specify an access policy. Navigate to "Policies", then "Connection Request Policies". Create a new policy.

![Windows RADIUS set-up - part 3](/images/blog/2017-07-10-how-to-implement-radius-authentication-openvpn-edgeos/windows-p3.png)

In the second step of the wizard you can optionally specify some conditions, for instance a time restriction.

In the last step, ensure that "Authenticate users on this server" is selected. 

![Windows RADIUS set-up - part 4](/images/blog/2017-07-10-how-to-implement-radius-authentication-openvpn-edgeos/windows-p4.png)

Next, we need to tell Windows which users may authenticate using RADIUS. Navigate to "Policies", then "Network Policies". Create a new "Unspecified" policy and in the second step of the wizard, assign one or more groups. A good practice is to create a group called "VPN Users" and assign people to that group.

![Windows RADIUS set-up - part 5](/images/blog/2017-07-10-how-to-implement-radius-authentication-openvpn-edgeos/windows-p5.png)

In the next step you need to configure the encryption protocol OpenVPN will use to validate the client credentials.  Unfortunately the FreeRADIUS PAM library only appears to support unencrypted PAP. Depending on your standards and network set-up this may be acceptable.

![Windows RADIUS set-up - part 6](/images/blog/2017-07-10-how-to-implement-radius-authentication-openvpn-edgeos/windows-p6.png)

Let's set-up OpenVPN!

## Set-up OpenVPN
In this guide I assume you that have set-up OpenVPN, even perhaps using a client certificate. You can configure RADIUS even if you are using a client certificate. 

First, create a file at `/etc/pam.d/openvpn` and enter the following contents:
```
auth sufficient pam_radius_auth.so debug
account sufficient pam_permit.so
session sufficient pam_permit.so
```
This will ensure the RADIUS module is loaded for OpenVPN.

Now, enter configure mode and use the `--plugin` option of OpenVPN to point it to the PAM authentication library. We also set-up Radius authentication for the Ubiquiti login, but as long as you don't create any users on the Ubiquiti itself they won't be able to log in via the web interface.

```
sebastiaan@router:~$ configure
[edit]
sebastiaan@router# edit interfaces openvpn vtun0
[edit interfaces openvpn vtun0]
sebastiaan@router# set openvpn-option "--plugin /usr/lib/openvpn/openvpn-auth-pam.so openvpn"
[edit interfaces openvpn vtun0]
sebastiaan@router# top
[edit interfaces openvpn vtun0]
sebastiaan@router# set system login radius-server 10.0.0.66 secret THIS_IS_MY_SECRET
[edit interfaces openvpn vtun0]
sebastiaan@router# commit
```

You need to replace `THIS_IS_MY_SECRET` with a secret password to be used with your RADIUS. In my case `10.0.0.66` is the RADIUS server. 

In the client OpenVPN `.ovpn` configuration file, add the following line:
```
auth-user-pass
```

This will ensure OpenVPN will ask for a username/password.

Test your VPN configuration. Once it works, let's make sure the changes survive an firmware upgrade.

## EdgeOS hardening the solution
As you might know any EdgeOS update will erase the complete system image of the device except for the `/config` directory. This means some of our hard work will disappear following a firmware upgrade.

To mitigate this, EdgeOS provides us with the means to execute scripts before and after configuration is applied. In our case, we will want to write the pam.d OpenVPN file before the configuration is applied and the OpenVPN daemon is started.

```
mkdir -p /config/scripts/pre-config.d
cd /config/scripts/pre-config.d
nano 20openvpn-radius-auth.sh
```

Paste the following contents into the file:

```
#!/bin/bash
echo "Writing OpenVPN PAM file..."

cat >/etc/pam.d/openvpn <<EOL
auth sufficient pam_radius_auth.so debug
account sufficient pam_permit.so
session sufficient pam_permit.so
EOL
```

Then mark it executeable:

```
chmod +x 20openvpn-radius-auth.sh
```

Test the configuration by rebooting your router.

Happy remote working!





