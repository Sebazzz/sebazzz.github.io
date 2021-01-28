---
layout: post
title:  "Anet ET4 Pro review"
date:   2020-11-30 20:00:00 +0100
categories: 3d-printing
---

The 3D printer manufacturer [Anet](https://www.anet3d.com/) asked me to review their [Anet ET4 Pro 3D printer](https://www.3dprima.com/3d-printers/manufactures/anet/), a 3D printer with the build volume of 220x220x250mm, TMC2208 silent stepper drivers and built-in automatic bed leveling. I've had the printer for about a month now, and since my Creality CR-6 SE [unfortunately also has a defective motherboard](https://gist.github.com/Sebazzz/ff4d716c8d2ad9bab1e87b3fc4238281), I've had a lot of opportunity to print and use this printer. At this moment, Anet asks just €176 for this 3D printer, delivered from an European warehous, so no taxes. Is this printer a good deal for this price? What can Anet do better? And what is awesome? Read on.

<style scoped>
  img + p, img + em {
    clear: both;
    display: block;
  }
</style>

## Specifications

First, the basic specifications:

- Build volume of 220x220x250 centimeter. This is 15mm smaller in the X and Y axis than most "mid-size" printers.
- TMC2208 silent stepper drivers
- Heated bed
- PTFE lined hot-end with UM2/M6 nozzle
- Spool holder on top
- Full color touch screen
- Auto bed leveling using a capacitive probe

The page of the official Anet ET4 Pro store also [has some additional information](https://shop.anet3d.com/products/et4-pro).

## Assembly and first impressions

The Anet ET4 Pro comes in a sturdy cardboard box, taped shut at all sides. 

![Anet ET4 Pro unboxing and assembly - the box](/images/blog/2020-11-30-anet-et4-pro-review/box-1.jpg)
*The cat was not included with the shipment*

Inside the box you are greeted with a 20 gram roll of sample PLA and a plastic bag with two manuals and some parts you need for assembly.

![Parts list](/images/blog/2020-11-30-anet-et4-pro-review/parts-list.jpg)
*What's in the box*

![Anet ET4 Pro unboxing and assembly - the box](/images/blog/2020-11-30-anet-et4-pro-review/box-2.jpg)
*The contents of the box are protected by a thick piece of foam again the violence of package delivery*

We can already see that a part of the printer is pre-assembled. That saves some time.

After the gantry has been removed from the box, we have the printer itself, with the bed already pre-assembled.

![Anet ET4 Pro unboxing and assembly - the box](/images/blog/2020-11-30-anet-et4-pro-review/box-3.jpg)
*The printer comes with a build plate, which you'Il attach to the glass bed with a 3M sticker - more on that later*

![Anet ET4 Pro unboxing and assembly - the box](/images/blog/2020-11-30-anet-et4-pro-review/box-4.jpg)
*The printer itself - it has a small metal base and a glass bed, which it kept on the aluminium base plate with 4 clips. The clips have a small footprint and look a bit more professional than the paper clips that come with printers like the Ender 3.*

The manual of the Anet ET4 Pro is decent. The setup manual is a bit terse, so you must remember that there are a lot of instructions in the same picture. However, I was pleasantly surprised to find a user manual as well, detailing how maintenance should be done, how to level the bed, and general guidelines on how to use a 3D printer. This makes it for a beginner much more accessible to start printing.

![Anet ET4 Pro unboxing and assembly - the box](/images/blog/2020-11-30-anet-et4-pro-review/manual.jpg)
*This is the user manual and setup manual shown side-by-side.*

![Anet ET4 Pro unboxing and assembly - the base](/images/blog/2020-11-30-anet-et4-pro-review/base-1.jpg)
*The bottom of the base shows the cabling for the gantry and the cover with the electronics under it*

The gantry is connected via a single flat cable, keeping the wiring nice and tidy.

### Electrical & inside the base

For this review I have also reviewed the electronics, because electrical safety matters.

![Anet ET4 Pro unboxing and assembly - the base](/images/blog/2020-11-30-anet-et4-pro-review/base-2.jpg)
*There is a warranty void sticker which is destroyed when the base is opened. Although the legal value of this sticker is debatable, Anet obviously discourages you from peeking inside.*

The Anet ET4 Pro has a good power supply: the MeanWell LRS-350-24. This is a 350W power supply delivering 24V. Anet already sets the correct voltage for your country/continent, so regarding that there is nothing to worry about. The power supply has a temperature controlled fan, which only turns on if necessary.

![Anet ET4 Pro unboxing and assembly - power supply](/images/blog/2020-11-30-anet-et4-pro-review/base-3.jpg)
*This is the same power supply as in my Creality CR-6 SE - Creality used this as a marketing vehicle too*

There is a 3.5 inch TFT full color touch screen, attached with two ribbon cables to the motherboard.

![Anet ET4 Pro unboxing and assembly - touch screen](/images/blog/2020-11-30-anet-et4-pro-review/base-4.jpg)
*The back side of the touch screen*

The motherboard features a TMC2208 silent stepper drivers. The processor is quite speedy [STM32F407VG Cortex M4](https://www.st.com/en/microcontrollers-microprocessors/stm32f407vg.html) microprocessor at 168Mhz. For comparison: my Creality CR-6 SE has a slower [72Mhz STM32F103RET Cortex M3](https://www.st.com/en/microcontrollers-microprocessors/stm32f103re.html) processor. 

![Anet ET4 Pro unboxing and assembly - motherboard](/images/blog/2020-11-30-anet-et4-pro-review/base-5.jpg)
*All the wiring has been done using decent crimped connectors. The connectors are locking connectors, so the connections can't degrade due to vibrations or moving the printer. The motherboard has a fuse to protect its components against a cascade failure.*

The motherboard has an USB-B connector for connecting it to your computer, and an micro-SD card slot.

![Anet ET4 Pro unboxing and assembly - switch](/images/blog/2020-11-30-anet-et4-pro-review/base-6.jpg)
*The Anet ET4 Pro has a proper wired switch, correct color coded wires, and both the live and neutral is wired through the switch. I also tested the grounding to the frame, which measured correctly at less than 50 Ohms.*

![Anet ET4 Pro unboxing and assembly - bed strain relief](/images/blog/2020-11-30-anet-et4-pro-review/bed-strain-relief.jpg)
*The bed is not insulated (but nor is it on my €200 more expensive Creality CR-6) - but in terms of electrical works - it has strain relief so you are unlikely to have electrical issues in the long run*

### Gantry assembly

The assembly steps for the gantry include:

1. Putting the gantry on the base and tightening the screws
2. Installing the pre-assembled hot-end and installing the belt
3. Plugging in the wiring according to the manual.

What I found interesting to see is that the Anet ET4 Pro uses a quite unique design when it comes to belt tensioning. Instead of having a completely manual belt tensioning system like on the BIQU B1, or a belt tensioning knob like on the Creality CR-6, you change the position of the stepper motor. 

![Anet ET4 Pro unboxing and assembly - belt tensioning X-axis](/images/blog/2020-11-30-anet-et4-pro-review/gantry-1.jpg)
*The belt is quite easy to tension, because you can grab the entire axis of the stepper motor and pull it to the left, then you simultaneously tighten one bolt, then the rest.*

![Anet ET4 Pro unboxing and assembly - belt tensioning Y-axis](/images/blog/2020-11-30-anet-et4-pro-review/gantry-2.jpg)
*The Y axis uses the same belt tensioning system as the X-axis.*

Once you have the single flat cable plugged into the junction board, you can wire up the hot-end. The cables and the sockets are clearly labeled, and keyed, so this eliminates the chance of any mistakes. The cable to the hot-end has its wires consolidated into a mesh, so it is all nice and tidy.

![Anet ET4 Pro unboxing and assembly - belt tensioning Y-axis](/images/blog/2020-11-30-anet-et4-pro-review/gantry-3.jpg)
*Next to the feeder there are two holes so you can provide some guidance and strain relief for the cable that goes to the hot-end.*

![Anet ET4 Pro unboxing and assembly - hot-end](/images/blog/2020-11-30-anet-et4-pro-review/hot-end.jpg)
*The hot-end with a fairly silent and temperature controller 40mm fan, a capacitive bed leveling probe, and a single 3D printer fan duct*

### Post-assembly

This is it essentially for the assembly. Once you have ensured that all the wires are plugged in, the belt are tight, and the eccentric nuts on both the hot-end and bed are tight (as per setup instructions in the manual), you're ready to go. The assembly is quite easy to do.

The first step after powering on is manually lowering the Z-axis until the nozzle is just above the bed. Then it is a matter of turning the sensistivity screw on the capacitive probe until just lights up. Then it is on to automatic leveling and printing!

#### Bed leveling

The bed leveling process probes in a 5 by 5 grid on the bed. The X-axis of the printer is a bit longer - this allows the hot-end to "overshoot" the bed, and properly measure the outer edges at the right hand side as well. 

During the leveling process you only see the results in a 3x3 grid though. 

The capacitive bed leveling probe is also used as the Z-endstop. What I did notice is that the probe seems to be sensitive to temperature. For this reason it is advisable to always home when the bed is warm, so your Z-offset is always consistent.

## Basic printing

The printer prints well, and if it is not, it is all due to the filament. One of my first prints was this giant Cute Octopus.

![Octopus printed with bad filament](/images/blog/2020-11-12-when-in-doubt-change-your-filament-octo.jpg)
*All the stringing was due to the filament, as [I later found out](/blog/2020/11/12/when-in-doubt-change-your-filament).*

The black PEI style surface works well for holding prints to the build surface, and I haven't had a failed print due to this build surface.

![PEI sheet on Anet ET4 Pro](/images/blog/2020-11-30-anet-et4-pro-review/octo.jpg)
*The first layers of the cute octopus, well, perhaps not so cute if it so big. As you can see, the small segments stick well on the build surface.*

### Bed surface

Anet ET4 Pro comes with a glass plate, on which you can stick a sticker with a textured bed surface.

![PEI sheet on Anet ET4 Pro](/images/blog/2020-11-30-anet-et4-pro-review/textured-bed.jpg)
*The textured bed surface works well and don't require any adhesion promotors - but if you have the Z-offset too low it can stick a bit too well*

Due to a few mistakes I made with Z-offset being too low (which are all on me), I managed to wear the bed surface out. Later I switched to the plain glass surface.

This glass surface also works well, just a matter of using a little bit of hairspray and low first layer speed and the printers stick well.

![PEI sheet on Anet ET4 Pro](/images/blog/2020-11-30-anet-et4-pro-review/bed-glass.jpg)
*Printing the alien face hugger on the glass bed surface. A little bit of hairspray makes the little segments of the print stick well.*

## Firmware

The firmware is very basic, but it does work for basic printing. It has filament runout detection and power loss recovery.

![Anet ET4 Pro unboxing and assembly - firmware 1](/images/blog/2020-11-30-anet-et4-pro-review/fw-1.jpg)
*The basic printing screen. The abilities to tune things while printing is not much, but sufficient: there are fan, extrusion and temperature controls.*

![Anet ET4 Pro unboxing and assembly - firmware 2](/images/blog/2020-11-30-anet-et4-pro-review/fw-2.jpg)
*My sample roll of filament quickly ran out, but it demonstrated filament run-out works properly.*

![Anet ET4 Pro unboxing and assembly - firmware 3](/images/blog/2020-11-30-anet-et4-pro-review/fw-3.jpg)
*There is currently no folder support, so you need to drop the files in the root directory of the SD card*

![Anet ET4 Pro unboxing and assembly - firmware 4](/images/blog/2020-11-30-anet-et4-pro-review/fw-4.jpg)
*You can use assisted manual bed leveling, but there is also auto bed leveling present.*

![Anet ET4 Pro unboxing and assembly - firmware 5](/images/blog/2020-11-30-anet-et4-pro-review/fw-5.jpg)
*There is guided filament load and unload - this works well.*

![Anet ET4 Pro unboxing and assembly - firmware 6](/images/blog/2020-11-30-anet-et4-pro-review/fw-6.jpg)
*You can also manually control the heat of the nozzle, for instance, if you need to change the nozzle.*

### Firmware limitations

That said, there are some limitations, which you only run into if you step outside the beaten tracks. 

- For instance, I was worried that homing with the nozzle being very low would scratch the bed. So, before the homing code `G28` I added `G0 Z5` to raise the X-axis by 5mm. However, this gcode caused the printer to move one of the axis and a random direction, and often out of bounds. I needed to turn off the printer then.

- The bed leveling mesh is not saved, so you need to run the leveling procedure each time the printer is turned on. The Z-offset is remembered though.

- Another example is that I like to fine tune a printer using a serial monitor like Pronterface. However, it is not possible to do so by default, because no commands give any output although the printer does respond to the commands:

![Anet ET4 Pro unboxing and assembly - firmware Pronterface](/images/blog/2020-11-30-anet-et4-pro-review/pronterface.jpg)
*The firmware does appear to support some commands, but fine tuning is not possible without any output on your commands.*

Anet is working to get native Marlin on these printers.

## Hello, Marlin

Luckily Anet is not deaf to the feedback they've had on the software and they've actively collaborated with the open-source community on getting Marlin ready for this printer. Although flashing Marlin on this printer [is a little bit more involved than just putting a file on your SD card](/blog/2020/11/06/flash-marlin-on-anet-et-printers) it is still fairly doable and I highly recommend it once you are used to the printer and know there are no mechanical or electrical issues.

![Marlin on the Anet ET series](/images/blog/2020-11-30-anet-et4-pro-review/marlin-fw.jpg)
*Marlin touch home screen after I had just ran a succesful probe accuracy test, with the status icons and heating buttons*

![Marlin on the Anet ET series](/images/blog/2020-11-30-anet-et4-pro-review/marlin-fw-in-action.jpg)
*Marlin firmware in action during printing*

Once you have Marlin installed, you have the full capabilities of Marlin, including fancy things like filament change during a print, custom commands and any custom commands to further tune your printer.
According to [this pull request](https://github.com/MarlinFirmware/Marlin/pull/20280) in Marlin, Anet will deliver full Marlin on future printers.

## Print quality

Now for the most important bit, how does this printer print? In summary quite well: the UM2 nozzles delivered with the printer tend to string a little bit, but you can replace them. I've also tried a M6 nozzle that came with my Creality CR-6 SE printer and that works well.

I had quite some problems at first, but [I later found out this was due to the filament](/blog/2020/11/12/when-in-doubt-change-your-filament) - once I changed to different filament, I was very happy with the print quality.

### Benchy

For print comparison with the other filament, I printed a benchy. This came out very nice.

![Anet ET4 Pro test prints - Benchy (1)](/images/blog/2020-11-30-anet-et4-pro-review/benchy1.jpg)
*A tiny hair of filament from retraction after printing, but otherwise a very clean benchy*

![Anet ET4 Pro test prints - Benchy (2)](/images/blog/2020-11-30-anet-et4-pro-review/benchy2.jpg)
*The smoke stack came out perfectly - no underextrusion or bad cooling - the small holes line the lines at the back came out good as well*

### Face hugger

For Halloween, I printed the articulated Alient Facehugger. It came out with a little bit of blobs, which I later found out was due to the nozzle.

![Anet ET4 Pro test prints - face hugger](/images/blog/2020-11-30-anet-et4-pro-review/face-hugger.jpg)
*The joints of this model were immediately able to bend without issues*

### Doll house shower

For my daughter I printed a shower for her doll house. 

![Anet ET4 Pro test prints - doll house shower](/images/blog/2020-11-30-anet-et4-pro-review/doll-house-shower-1.jpg)
*This will turn out to be an unintended bridging test. Will it go all right?*

![Anet ET4 Pro test prints - doll house shower](/images/blog/2020-11-30-anet-et4-pro-review/doll-house-shower-2.jpg)
*Bridging in progress - note how much distance the nozzle has to cover until it is able to meet up at the other side!*

![Anet ET4 Pro test prints - doll house shower](/images/blog/2020-11-30-anet-et4-pro-review/doll-house-shower-3.jpg)
*Filling in the gaps - still doing very well*

![Anet ET4 Pro test prints - doll house shower](/images/blog/2020-11-30-anet-et4-pro-review/doll-house-shower-4.jpg)
*The end result. It came out very clean.*

This print came out very clean. It features extreme bridging, not to mention also an overhang test with the little shower head.

### Traffic cone

I wanted to play with the filament change feature in Marlin. Using white Creality PLA and blue BASICFIL PLA, I printed a traffic cone in two filaments.

![Anet ET4 Pro test prints - traffic cone](/images/blog/2020-11-30-anet-et4-pro-review/traffic-cone-1.jpg)
*Traffic cone in progress*

![Anet ET4 Pro test prints - traffic cone](/images/blog/2020-11-30-anet-et4-pro-review/traffic-cone-2.jpg)
*Traffic cone - final result*

### Christmas hat

This Christmas hat can be put on top of a bottle cap.

![Anet ET4 Pro test prints - christmas hat](/images/blog/2020-11-30-anet-et4-pro-review/hat-1.jpg)
*Hat in progress - using a brim for better adhesion to the glass*

![Anet ET4 Pro test prints - christmas hat](/images/blog/2020-11-30-anet-et4-pro-review/hat-2.jpg)
*Hat - final result*

I also printed this with the Marlin filament change option. As you can see the printer has the accuracy to resume printing without issue.

### Bearing

Next, I wanted to test the printer for accuracy. For the first test, I printed a bearing with 0.15mm tolerance.

![Anet ET4 Pro test prints - bearing](/images/blog/2020-11-30-anet-et4-pro-review/bearing-1.jpg)

I actually needed two attempts before I had a working bearing. That is due to this model needing a perfect Z-offset: if you are too far from the bed you lose adhesion and the printed model curls up, if you are too close to the bed the gears fuse together. I didn't have my Z-offset perfect, so I didn't manage it the first try.

However, the rest of the gears spin free fully, as you can also observe in the short video below.

<video controls muted loop>
  <source src="/images/blog/2020-11-30-anet-et4-pro-review/bearing-2.mp4" type="video/mp4">
</video>

### V-Twin Engine

Because the bearing went well, I printed the [V-Twin Engine from Sunshine](https://www.thingiverse.com/thing:4620846). 

![Anet ET4 Pro test prints - V-twin engine](/images/blog/2020-11-30-anet-et4-pro-review/v-twin-1.jpg)
*Notice the stringing: At first I thought this was the cheap BASICFIL I printed this with, but it appears that the nozzle I had installed was the primary cause of this*

<video controls muted loop>
  <source src="/images/blog/2020-11-30-anet-et4-pro-review/v-twin-2.mp4" type="video/mp4">
</video>

*This print came out fine and the engine runs fine!*

### Print in Place Engine Benchmark

The previous tests went so well, that I decided to put this printer to its limit. For this, I printed the [Print in Place Engine Benchmark](https://www.thingiverse.com/thing:4575774) which features a full functioning 3 cilinder engine. 

<video controls muted loop>
  <source src="/images/blog/2020-11-30-anet-et4-pro-review/print-in-place-engine.mp4" type="video/mp4">
</video>

As you can see in the video above, the engine is able to turn freely. I was also able to blow air through the crankshaft, which is also one of the requirements to pass this test.

## Noise levels

Due to the limited amount of space on my desk, I have the printer next to me while I'm working. 

### Fans

The printer has 4 fans: 
- A 40mm hot-end fan. This fan is temperature controlled and is only running when the hot-end is heated above 50 degrees C.
- A radial part cooling fan. This fan is silent and turned on according to your slicer settings.
- A 40mm motherboard fan. This fan is always on.
- A fan inside the MeanWell LRS-350-24 power supply. This fan is temperature controlled and turns on when the power supply is getting hotter.

When the printer is idle, you only hear the motherboard fan. When the printer is printing, you can hear the power supply fan turn on and off every 10-20 minutes (because it is temperature controlled). Not something Anet can fix, but the power supply fan is definitely the noisiest. Still, it is not so noisy you can't work next to it and it does not interrupt conference calls.

### Stepper motor noise

Unless you have fast travels between models, the stepper motors cannot be heard. Noise due to fast travels are unavoidable - and even then the noise is quite acceptable. 

## Pros and cons

Based on what I have observed, the pros and cons of this printer:

### Pros

- Offers good print quality out of the box
- The firmware does the minimally what is necessary for basic printing
- Auto bed leveling, filament run-out and power loss recovery is included
- It is still possible to manually adjust the bed
- Manual bed leveling uses strong springs, so you have less play causing inaccuracies
- User manual offers basics on 3d printing, making it easier for beginners to start using their machine
- Textured and glass build surface offer choice to the user
- Belt tensioning is as easy as it gets for this price point
- Temperature controlled fans make for acceptable noise levels
- Small footprint makes it fit on every desk
- Hot-end appears to be easily upgradable

### Cons

- The default firmware is quite limited and upgrading to Marlin should be easier
- The default nozzles are not bad, but could be better
- Small bed size of 220x220mm is not for everyone
- Included slicer is ancient - Anet should point to the latest version of Cura instead
- Auto bed leveling probe seems to be temperature dependent - this influences the Z-offset

### Other thoughts

Flush cutters are not included, but you probably already have some. The instructions in the manual are quite terse, you need to read them carefully so you don't miss a step. Use Cura 4.6.x or higher - this will make for better quality prints.

## Conclusion

During this month of ownership I've been able to make plenty of prints. This printer was also my work horse, because my Creality CR-6 SE mainboard had failed and I'm still waiting on a warranty replacement. 

![Anet ET4 Pro test prints - full in action](/images/blog/2020-11-30-anet-et4-pro-review/full-printer.jpg)
*In action, printing a calibration cube. I've added some blue strips in the extrusions for the looks.*

This printer is not perfect. I've had some issues, like you would have on any printer, but this isn't a bad printer if you consider that this printer only costs €176. It has auto bed leveling, a decent amount of instructions, and you surely can get started quite easily. This printer is the best and most extensive feature set you are going to get for the price point. 

## Where to buy

There are several places where you can buy this printer:

- [Official EU reseller (3DPrima)](https://www.3dprima.com/3d-printers/manufactures/anet/)
- [The Official Anet shop at anet3d.com](https://shop.anet3d.com/products/et4-pro)
- [AliExpress](https://www.aliexpress.com/item/4000033214131.html)

The printer can ship from local warehouses, so what you pay is the price. No unexpected customs fees afterwards.
