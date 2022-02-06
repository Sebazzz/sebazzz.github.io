---
layout: post
title:  "Creality CR-6 SE and BIQU B1 comparison"
date:   2020-10-24 10:00:00 +0200
categories: 3d-printing
---

In this short article I compare the BIQU B1 and the Creality CR-6. The BIQU B1 I received as a review unit, the Creality CR-6 I got as a reward for backing the Creality CR-6 SE Kickstarter, [which did not go too well](/blog/2020/08/29/3d-printers-incoming). Let's look at various aspects of the printers, like the looks, the technical part, the software and print quality.

## BIQU B1

As mentioned, the BIQU B1 was a review unit and I've written both an [unboxing & assembly](/blog/2020/09/29/biqu-b1-unpacking-and-assembly) guide and [a full review](/blog/2020/10/18/biqu-b1-review). The BIQU B1 is the first full printer of BIGTREETECH and costs about €220 currently. The price may be different by the time you read this article.

### Known issues

Like any product, the BIQU B1 one has some known issues I found skimming through the Facebook group:

- BIQU got a bad batch of fans, so some fans may make some additional noise after startup. This noise disappears after a while. I expect this is fixed on later units.
- Some users experienced a slightly warped bed - though this may seem to be user error due to not tightening the bed screws evenly. In any case, if you have a BLTouch as bed leveling probe, you will not have this issue - or alternatively you can use manual mesh bed leveling.

## Creality CR-6 SE

The Creality CR-6 SE is the first printer of Creality funded (or should I say pre-ordered) through Kickstarter. It was funded over [3 million dollars](https://www.kickstarter.com/projects/1001939425/creality-cr-6-se-leveling-free-diy-3d-printer-kit/) with over 10.000 backers backing this project. It is also the first printer of Creality with built-in bed leveling. Creality has innovated a bit and built the bed leveling using a strain gauge attached to the hot-end, allowing the bed leveling to happen through the nozzle.

### Known issues

The Creality CR-6 SE is also not free of known issues. Being an admin of [the Creality CR-6 Facebook community](https://www.facebook.com/groups/cr6community) I already had an early overview of the issues this printer has. The Creality CR-6 comes pre-assembled, than that is where part of the issues come from. During shipping some parts may come loose - but the pre-assembly part was also not done right in some cases. Because of this I wrote a [Creality CR-6 unboxing & assembly checklist](https://gist.github.com/Sebazzz/030d21c606413e22cbd77d8df9fb8b17). 

Still, not all issues can be attributed to the fact that this printer is pre-assembled. I've made quite [a list of issues I've found throughout the time](https://gist.github.com/Sebazzz/ff4d716c8d2ad9bab1e87b3fc4238281), but these are the most severe issues:

- Motherboard malfunctions: Stepper drivers not functioning, the bed heating up unexpectedly, or even components going up in smoke. Also, for some users, connecting the printer to a Raspberry PI or computer has been giving issues ranging from the printer not working anymore or the host USB ports permanently malfunctioning.
- Switch malfunctions: Creality got a bad batch of switching, which spark, make bad contact, or permanently are fused in the "on" state. In [the TH3D live stream](https://www.youtube.com/watch?v=37Jnwo1ZQgY) such switch was disassembled and it showed a very bad construction.
- Bed leveling not working: This is inconvenient because you can't level the bed manually - in some cases the gantry is not parallel to the frame, in other cases the underlying aluminium bed is warped. Still, it is unclear why the bed leveling does not compensate for this.

If Creality did properly respond to this issues, it wouldn't be a problem. However, Creality has been mostly absent from Facebook, not responding well on the support e-mail as well. Creality has also barely acknowledged the issue, causing confusion whether this issue is actually fixed on later printers. 

In my case I got my printer shipped late in the Kickstarter (only in the end of September), yet I got the 457th printer produced with still the bad switch in it. Creality did not bother to replace this switch, nor throw a spare switch into the box - even though this issue with the switch was already known well by then.

## The looks

![Creality CR-6 SE](/images/blog/2020-08-29-3d-printers-incoming/cr6-se.jpg)

The Creality CR-6 SE has a black finish, a large color touch screen and belt tensioners. The X-axis rides on two Z-lead screws, but not on separate stepper drivers, requiring a belt at the top to connect the two lead screws.

![BIQU B1](/images/blog/2020-08-29-3d-printers-incoming/biqu-b1.jpg)

The BIQU B1 is pink, has a small dual-mode (Marlin and touch mode) screen with rotary knob. There is a belt tensioner for the Y-axis, and manual tensioning for the X-axis. 

Personally I like the looks of the Creality CR-6 SE more - the CR-6 SE looks more premium than the BIQU B1 due to the moving parts being hidden behind plastic covers. The CR-6 uses a custom aluminium profile, so the extrusions are only on the places where it is needed. 

### Build volume and bed size

Both printers have the same build volume (235x235x250), but the CR-6 SE has a larger bed size (245x255). I'm not sure why this is, I suppose it is to make room for the bed leveling clips. It also means that the Creality CR-6 has a larger footprint.

## Technical

The BIQU B1 uses a standard BTT SKR motherboard with replaceable stepper drivers. Moreover, the TMC2208 (TMC2225) stepper drivers are connected in UART mode, so control over the stepper drivers is possible via the firmware. The stepper motors also run more silent (due to stealthchop being possible) and the stepper motors run at a low temperature (almost indistuingishable temperature).

![BIQU B1 - Motherboard](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly/inside-5.jpg)

Because to the stepper drivers being replacable, it is possible to upgrade the stepper drivers to TMC2209 versions. For the X, Y and Z axis this might not matter much - but for the extruder stepper motor it would allow the use of linear advance. This is [unfortunately not supported on TMC2208](https://github.com/teemuatlut/TMCStepper/issues/45) drivers.

![CR-6 SE - Motherboard](/images/blog/2020-10-24-biqu-b1-creality-cr6-se-comparison/cr6-board.jpg)

The Creality CR-6 SE v4.5.2 motherboard dated 2020-05-23 has TMC2209 drivers connected in *legacy* mode. The drivers are soldered onto the board and cannot be replaced. The drivers have potentiometers on the board to set the current send to the motors and allow no firmware control. 

In my experience the stepper motors are a bit noisier on the Creality CR-6 compared to the BIQU B1, probably because stealthchop is not possible on the Creality CR-6 SE. That makes the BIQU B1 a clear winner on this front.

## Inputs

The BIQU B1 allows for up to two microSD cards and an USB stick to be used. There is also an USB-B connection for connecting a computer or Raspberry PI with Octoprint.

![BIQU B1 - Touchscreen inputs](/images/blog/2020-11-18-biqu-b1-review-touchscreen-inputs.jpg)

The Creality CR-6 SE has a full size SD card slot and a micro-USB port for connecting a computer.

In terms of inputs the BIQU B1 is a clear winner. Although I don't like the small microSD cards, there is a USB port and you can simply plug in the USB to SD card adapter - which happens to come with the printer. I still would have liked it more if there was a full size SD card slot. The USB connector is also better: USB-B is a bit more reliable than micro-USB.

## Software

### Open source - source sharing 

Both printers run Marlin - but the BIQU B1 has an official firmware based on Marlin 2.0.6, which is [developed in the open on GitHub](https://github.com/bigtreetech/Marlin/tree/B1-2.0.6). The touch screen and motherboard firmware packages for consumption are [downloadable from a separate Github repository](https://github.com/bigtreetech/BIQU-B1). The BTT Touch screen firmware is also [open source](https://github.com/bigtreetech/BIGTREETECH-TouchScreenFirmware).

The Creality CR-6 on the other hand... I had to ask for the source code and [was told it was not going to be released](https://www.facebook.com/groups/cr6community/permalink/910687289457663), then after quite a bit of social media uproar it finally got released. [Based on my analysis](https://github.com/CR6Community/Marlin/commit/f3876e81a74b8ffebdef7776e721f7c25e0ce770) the Creality CR-6 source code is based on a pre-release version of Marlin 2.0.0. The touch screen software is not open source - the binary components of the touch screen are not released to the public.

The BIQU B1 is a clear winner in this regard - BIGTREETECH develops the firmware in the open and appears to love open source. They develop and improve the firmware after the printer is released, and also contribute back upstream to Marlin. I consider compliance to the open source license very important - the license is GPL and all parties need to comply to that license. It is also important because it lets the user own and use the printer long after the manufacturer decides to stop firmware development for it.

### Functionality

The BIQU B1 features the popular BTT Touch screen hardware. This is a very feature rich touch screen, allowing to handle all kinds of aspects of the printer, handling from percentage based fan and flow control during printing till tweaking the specific settings like stepper driver current. When selecting a file for printing you can navigate through the folders and even get a 3D preview thumbnail of the particular file. Even if you don't like the touch screen, you can still switch to Marlin mode, by which the menu from Marlin itself is rendered on the screen. You can then use the rotary knob to navigate the menus.

![BIQU B1 - Touchscreen](/images/blog/2020-11-18-biqu-b1-review-touchscreen.jpg)

The Creality CR-6 SE offers a larger touch screen, but with currently limited functionality. Some of the functionality that exists is broken, like the preheat setttings. When printing you can set the bed and hot-end temperature, and turn the fan on and off. If you want to select a file for printing, there is a character limit on the file names and there is no folder support at all. In many places and messages broken English is used (we have [corrected this in the community firmware](https://github.com/CR6Community/CR-6-touchscreen)).

Again the BIQU B1 is a clear winner. The touch screen software is much more mature and rich in functionality.

## Build surface

The BIQU B1 has a [super spring steel sheet](https://www.aliexpress.com/item/4001061964266.html) as default build surface. This is a flexible sheet build surface with some kind of coating on it (I think it is some kind of paint?). I'm very happy with this build surface because it has perfect adhesion when hot and releases easy when cooled. The thermal mass of this build surface is also low, so as soon as you pull it from the magnetic hotbed, it cools down and you can remove the print.

By default the Creality [has a coated glass bed](https://www.creality3dofficial.com/collections/cmagnet-tempered-glass/products/creality-new-upgraded-heated-bed-build-plate-surface) with little dimples. The dimples should prevent the prints from coming loose. From what I've experienced it let go too early I had prints fail because of the bed. I had ordered a PEI bed add-on with my CR-6 and that has been printing okay (though the top surface is too coarse). Also I've seen many members of my CR-6 community group experience that the bed surface detaches and sticks to the print instead of the bed.

The BIQU B1 is a clear winner with the default bed surface. Although a glass plate is less prone to issues with the underlying aluminium bed and is supposed to be perfectly flat, I think that any warping can be overcome and does not directly result in failed prints.

## Print quality

This is a difficult one to talk about without doing many side by side prints. Still, I have some findings to share here. 

The BIQU B1 has TMC2225 drivers (TMC2208 in a smaller package) - these drivers do not support linear advance so you will have rougher corners when printing at high speed. You can upgrade the extruder driver for about €5 though and then you would have linear advance. For print cooling, the BIQU B1 has two small fans which redirect air through an air duct onto the printed part. This works, apparently, because if you look at the tip of this spaceship model I printed: it is perfect.

![BIQU B1 - Cool cooling](/images/blog/2020-11-18-biqu-b1-review-kids2b.jpg)

The Creality CR-6 SE has a single fan and only provides part cooling from a single direction. This has its limitations, because the CR-6 SE was not able to print this spaceship in the same manner as the BIQU B1.

![CR-6 SE bad cooling](/images/blog/2020-10-24-biqu-b1-creality-cr6-se-comparison/cr6-spaceship.jpg)

I already had foreseen this, so before the print reached the tip, I lowered the print temperature to 185 degrees and even manually tried to blew the air I exhaled on the print but I could not make it better than this.

So, regarding print quality there is not a clear winner, because the CR-6 SE should be able to extrude filament more precisely due to linear advance, but the BIQU B1 is upgradable and provides better part cooling by default.

## Conclusion

I won't make a conclusion here, but let you decide for yourself. 

On one hand you have the €339 priced Creality CR-6, from an established printer manufacturer, on the oher hand you have a €220 BIQU B1, from an established printer upgrade manufacturer. I've compared them on a few aspects. I've seen the issues and the behavior of the Creality company on the CR-6 Kickstarter, behavior I will not forget.

The only thing left for me to say: 

1. Software can always be updated, but there is no guarantee that it will be updated. I can imagine Creality quickly losing interest, because Creality appears to launch new printer models almost every few weeks.
2. If you start cheap, you have more money to upgrade as you see personally see fit. 
3. Think of the community - the Creality CR-6 SE has the largest community - but the *parts* of the BIQU B1 have the largest community. Besides that, the BIQU B1 is essentially following the same profile as an Ender 3 - so good chance that any upgrades (like linear rails) are compatible.

Good luck making your choice.





