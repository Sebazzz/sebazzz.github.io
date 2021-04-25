---
layout: post
title:  "How-to: Connect the Creality CR-10 Smart to a computer or Octopi"
date:   2021-04-24 21:00:00 +0100
categories: 3d-printing
---

The Creality CR-10 Smart is a printer with a built-in [Creality Wifi Box](https://www.creality3dofficial.com/products/creality-wi-fi-box) for [Creality Cloud](https://model.creality.com/model).  For troubleshooting it is however more useful to directly talk to the firmware, using [an Octoprint console](https://octoprint.org/) or [Pronterface on Windows/Linux/Mac](https://www.help.prusa3d.com/en/article/pronterface-and-usb-cable_2222). But where is the USB connector? It is hidden! In this post I'Il show you how to connect to your Creality CR-10 Smart printer!

<style scoped>
  img + p, img + em {
    clear: both;
    display: block;
  }
</style>

The Creality CR-10 Smart is obviously a printer that nudges you to use it via the Creality cloud. However, when troubleshooting your printer or collecting log information, you need a bit more power. The Creality Cloud currently doesn't allow connecting to your printer - but you can through [an Octoprint console](https://octoprint.org/) or [Pronterface on Windows/Linux/Mac](https://www.help.prusa3d.com/en/article/pronterface-and-usb-cable_2222)!

--

**Warning:** It is possible I had pre-release hardware and therefore in the final hardware this procedure is slightly different or not possible at all. I also can't speak to what this change will do in terms of warranty.

--

To find the internal USB connector, remove the power plug, put the printer on its side and take off the bottom. 

![Creality CR-10 Smart internals](/images/blog/2021-04-24-connect-creality-cr-10-to-computer-or-octopi/bottom-all.jpg)
*The internals of the CR-10 Smart, a Creality wifi box board, power relay, Creality-branded Meanwell LRS-350-24 and Creality CRC-2405V1.1 motherboard can be seen. We are interested in the purple part however: the USB junction board.*

The USB junction board provides the Creality wifi box with a steady 5V power supply and allows us to change the USB connection.

![Creality CR-10 Smart USB junction board](/images/blog/2021-04-24-connect-creality-cr-10-to-computer-or-octopi/closeup.jpg)
*We find in <strong style="color: orange">in orange the connection to the Creality wifi box</strong>, <strong style="color: blue">in blue the connection from the junction board to the internal USB header of the motherboard</strong> and in <strong style="color: hotpink">in pink a header and micro-USB connector</strong> for an external computer.*

To allow an external computer to connect we must simply do two things:

1. Move the connection from the motherboard to the PC connector
2. Route the USB cable outside

![Creality CR-10 Smart USB junction board](/images/blog/2021-04-24-connect-creality-cr-10-to-computer-or-octopi/complete.jpg)
*Pry the hot glue loose by using some tweezers and a few drops of IPA, then find the connector that leads to the motherboard, disconnect it from "MCU" and plug it into the receptacle labeled "PC". Plug your USB cable into the micro USB connector.*

![Creality CR-10 Smart USB cable routing](/images/blog/2021-04-24-connect-creality-cr-10-to-computer-or-octopi/cable-routing.jpg)
*Route the USB cable out of the electronics compartment through a hole in the front*

**Be careful:** The USB cable, when connected this way, has no strain relief. It is possible for the USB connector to become loose.

## Summary

This quick post showed how to connect a USB cable to the printer. For guidance on Octoprint or Pronterface you can look at the respective documentation linked above.
