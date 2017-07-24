---
layout: post
title:  "How-to: Use a serial connection to your Netgear ReadyNAS"
date:   2015-01-01 10:00:00 +0100
categories: it-management readynas
redirect_from: "/blog/how-to-use-a-serial-connection-to-your-netgear-readynas"
---

It is possible to connect to the command-line interface of your Netgear ReadyNAS using a serial connection. I have seen a very old blog post on the internet describing how to connect via [serial to a Infrant ReadyNAS NV](http://debugmo.de/2007/07/running-own-code-on-the-infrant-readynas/) but it wasn't very clear how to connect to a Netgear ReadyNAS NVX Pioneer Edition, which I have. I guess I'm not the only one who wants to connect to their ReadyNAS, so I'm sharing my knowlegde here :)

The obvious advantages of a serial connection to your ReadyNAS is that you can experiment with network settings without the fear of rendering your NAS inaccessible. I believe it is also possible to recover the firmware in the event an update fails, although I haven't tried this myself.

## Requirements

You need the following components in order to establish a serial connection to your ReadyNAS:

* A serial RS232 cable and port or an USB-to-RS232 cable. Such cables are available on [DealExtreme](http://www.dealextreme.com/p/usb-to-rs232-serial-adapter-cable-94539).
* You also need an RS232 to TTL converter or cable. Also available on [DealExtreme](http://www.dealextreme.com/p/rs232-serial-port-express-card-adapter-blue-black-silver-101467).
* Finally, you need a piece of software to connect to a serial terminal. You can use HyperTerminal, PuTTYor minicom.

## Connect the cables
First step is of course to connect the cables to your computer and to your ReadyNAS. On the back side of the NAS, you can find a small gray sticker about two centimeters long and half centimeter high. This sticker covers the serial port of the NAS. If you used the RS232-to-TTL cable from DealExtreme, you need to put the cable that comes with it in it. Put the connector without the loose ends into this port. You can put the connector with the loose ends on the converter. Below the sequence is shown how the cables should connect (converter USB side to edge -> NAS reset button to connector).

```
1 ⇨ 1  (TXD)
2 ⇨ 4  (RXD)
3 ⇨ 2
4 ⇨ 3
```
If you count from one side of the connector to the other side, pin 1 on the NAS needs to be mapped to pin 1 on the converter etc. Finally, connect the cable from your computer to the converter.

## Set-up the port

You need to set-up the serial port this way:
```
Speed        9600
Data bits    8
Stop bits    1
Parity       None
Flow control XON/XOFF
```
It should now be possible to connect.

When using PuTTY, it is possible you need to hit the 'Enter/Return' key on your keyboard first before you see a login prompt. When using minicom, you may see some garbage in the console first before you press the enter key. After pressing enter you can login with any account you would login with via SSH. If you have problems viewing certain characters, try setting the encoding on UTF-8. 

If you can't get it to work at all, try rebooting both computer and ReadyNAS. If it still doesn't work, try turning the connector on the NAS-side the other way around. Don't hesitate to contact me or comment here if this still doesn't work. :)

*This article was previously posted on damsteen.nl under a different url and taken offline.*