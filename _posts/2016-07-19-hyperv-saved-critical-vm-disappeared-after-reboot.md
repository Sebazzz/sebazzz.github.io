---
layout: post
title:  "Hyper-V VMs disappeared after reboot and unknown entries showing 'saved-critical'"
date:   2016-07-19 5:00:00 +0200
categories: sysmanagement
---

Among my development tasks, I have also the responsibility to manage the development systems my collegues are working with. After installing regular security updates on our Hyper-V Server 2008 R2 and a subsequent reboot I found myself having a corrupt Hyper-V instance.

## "Saved-critical" VMs
There were two virtual machines listed as "saved-critical" with the description of "cannot connect to the vm configuration storage". The first course of action in this case is to open the event viewer. 

In the event viewer I found this:

![Event viewer showing cause of saved-critical VM](/images/blog/2016-07-19-hyperv-saved-critical-vm-disappeared-after-reboot-sc.png)

The odd thing here is that this VM has been removed for several months (I deleted it since it was obsolete)! I haven't been able to find the cause of this issue, so I decided to remove these entries.

## Virtual machines which disappeared
I also missed a virtual machine in the list. Our development SQL machine (we call it SQLDEV) was missing. 

Again, the event viewer proved to be useful:

![Event viewer showing cause of disappearing virtual machine](/images/blog/2016-07-19-hyperv-saved-critical-vm-disappeared-after-reboot-perm.png)

I mounted the network disk to one of the servers and navigated to C$\VM\SQLDEV. After popping up the permission list it all became clear:

![Missing permissions being the cause of disappearing virtual machine](/images/blog/2016-07-19-hyperv-saved-critical-vm-disappeared-after-reboot-perm2.png)

Notice that the "Virtual Machines" entries shows no permissions at all! Fix this by giving it at least modify and read permissions. You should also grant the same permissions to the computer account.

## Conclusion
With the above solutions I fixed the issues I had. Nevertheless, always keep your backup and recovery plan ready in case you're not so lucky as I am.
