---
layout: post
title:  "BIQU H2 direct drive extruder: first look and initial impressions"
date:   2021-01-08 20:00:00 +0100
categories: 3d-printing
image: /images/blog/2021-01-08-biqu-h2-direct-drive-extruder-first-look/whole-package.jpg
---

BigTreeTech sent me [their BIQU H2 direct drive extruder](https://www.bigtree-tech.com/products/biqu-h2-direct-extruder.html) for review. This extruder is very similar to the extruder on their [BIQU BX 3D printer](https://www.bigtree-tech.com/products/biqu-bx.html). Let's take an initial look at what this solution from BigTreeTech offers - what they call the "World's lighest direct extruder".

## Package

<style scoped>
  img + p, img + em {
    clear: both;
    display: block;
  }
</style>

The BIQU BX comes in a nice small box, but it will turn out this extruder itself isn't actually that big.

![BIQU H2 package](/images/blog/2021-01-08-biqu-h2-direct-drive-extruder-first-look/the-box.jpg)
*A nice clean package*

If we open the box we are immediately greeted by the extruder, and some accessoires.

![BIQU H2 box contents](/images/blog/2021-01-08-biqu-h2-direct-drive-extruder-first-look/box-open.jpg)
*Well packaged we find the extruder at the left side - accesoires at the right side*

### The extruder

Removing the extruder from the box, the first thing that I notice is how solid it is. It feels as one solid chunk of metal - but it isn't very heavy, and it also isn't very big.

![BIQU H2 extruder comparison to battery](/images/blog/2021-01-08-biqu-h2-direct-drive-extruder-first-look/battery-comparison.jpg)
*Size of the extruder compared to a regular AA battery*

![BIQU H2 extruder comparison to CR-6 fan shield](/images/blog/2021-01-08-biqu-h2-direct-drive-extruder-first-look/cr6-comparison.jpg)
*Size of the extruder compared to the Creality CR-6 3D printer fan shroud*

The extruder weights about 220 grams in its default configuration, including the fan. For comparison: the metal CR-6 fan shroud itself - without the hotend and fan - already weights about 80 grams. I doubt the weight will be an issue when I'Il install this on my CR-6.

Note the extruder comes with a silicon sock to protect the heater block from filament sticking to it.

One thing that I immediately note is that the cooling fan that is mounted to the side doesn't blow directly over the hot-end itself. It isn't is designed to blow against the metal case of the extruder, which is connected to the hot-end. We'Il have to see how this holds up - but the filament path is quite short so this might not be a problem.

### Included in the box

Included in the box we find the manual. 

![BIQU H2 manual](/images/blog/2021-01-08-biqu-h2-direct-drive-extruder-first-look/manual.png)

The manual lists the specifications. 

Most notible is that this is a double gear extrusion with a 7:1 gear ratio. That means that unlike the normal "cheap" extruder that comes with almost every 3D printer, this extruder is supposed to have much more torque. You also need a different e-steps setting - this setting determines who much the stepper motor must rotate for a given amount of filament - in this case near 939 steps as opposed to the regular 93 steps.

What I can't see in the manual is specifications on the thermistor. What is also not mentioned in the manual is that you can buy an all-metal throat for this hot-end in the future - allowing printing of higher temperature filaments.

Next we find the mandatory BigTreeTech Good Luck Duck.

![BIQU H2 duck](/images/blog/2021-01-08-biqu-h2-direct-drive-extruder-first-look/mandatory-duck.jpg)
*This isn't a BigTreeTech product without its duck*

We also find some tools, a few ballhead allen keys, a few bolts, and a few grub screws.

![BIQU H2 tools](/images/blog/2021-01-08-biqu-h2-direct-drive-extruder-first-look/tools.jpg)
*Three allen keys and two pairs of M3 bolts*

Next we find the components related to heat and cold.

![BIQU H2 fan, heater and thermistor](/images/blog/2021-01-08-biqu-h2-direct-drive-extruder-first-look/heater-fan-thermistor.jpg)
*A 40W heater, a thermistor cartridge, and a hotend cooling fan*

Finally, we find a cable for the pancake extruder stepper motor.

![BIQU H2 stepper motor cable](/images/blog/2021-01-08-biqu-h2-direct-drive-extruder-first-look/stepper-motor-cable.jpg)
*A stepper motor cable, with on one end a female dupont connector and on the other end a JST-XT connector*

## Whole package

The whole package as delivered is what you see below. 

![BIQU H2 whole package](/images/blog/2021-01-08-biqu-h2-direct-drive-extruder-first-look/whole-package.jpg)

Note that there is no part cooling fan solution - you'Il have to provide that yourself.

## Mounting on the CR-6

Currently I'm working on getting this extruder mounted on my Creality CR-6 SE printer. This is not very trivial due to the bed leveling system and the breakout board near the hot-end - but I also want to show that you can essentially mount this anywhere.

![BIQU H2 whole package](/images/blog/2021-01-08-biqu-h2-direct-drive-extruder-first-look/cr6-mount-proto-1.png)
*Work in progress on the CR-6 mount for the BIQU H2*

![BIQU H2 whole package](/images/blog/2021-01-08-biqu-h2-direct-drive-extruder-first-look/proto-1-mounted.jpg)
*First measuring prototype already printed*

Currently I'm waiting for some crimping tools to arrive so I can start cutting the cabling to the correct length. The extruder comes with full length cables for the "classic" 3D printers without any combined (or I should say proprietary?) cables and breakout boards - so this will take a little bit more effort to figure out.

Until the review! 😄