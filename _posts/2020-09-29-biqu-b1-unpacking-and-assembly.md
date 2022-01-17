---
layout: post
title:  "BIQU B1: Unboxing and assembly"
date:   2020-09-29 20:31:00 +0200
categories: 3d-printing review
image: /images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-packaging-1.jpg
---

Finally I received the BIQU B1 from BIGTREETECH. It was stuck in Dutch customs for almost a month - also partially blaming Fedex for this. But, it is finally here! Let's unbox and assemble this printer!

## BIQU?

BIQU is not yet very known in the 3D printing market... when it comes to fabricating printers. But the parent company, BIGTREETECH, must sound some bells with any 3D printing geek. For those who don't know it: They are well-known for their 3D printer upgrades, like motherboards (the "brains" of the operation) and (touch) screen upgrades for the printer. 

With the BIQU B1, BIGTREETECH wants to make an entrance in the 3D printing market. This is a very potent, growing, market. Printers are being produced for lower and lower prices - and at the same time the quality of these machines increases dramatically. Another manufacturer of less expensive 3D printers is Creality, which has gotten a big foothold of the market with their Ender 3. I had a [very bad first impression of them](/blog/2020/08/29/3d-printers-incoming) though.

With this being said, let's get to unboxing!

## Packaging

3D printers are sensitive devices and work on very tight tolerances. Because of this, it is important that a printer is packaged well. BIQU has understood this.

![BIQU B1 - Box](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-packaging-1.jpg)

The BIQU B1 comes in a firm box, wrapped in packaging tape. Although it might not have been intended for resilience against water or moisture, I do think it doesn't hurt. From what I've seen from delivies from some other printers so far, when a printer is in a sea container, it may get exposed to water even! Still, a lot of tape did make it a bit harder to unpack. Nothing a Stanley blade can't handle though.

![BIQU B1 - Foam packaging](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-packaging-2.jpg)
*Take a moment to appreciate the thick foam that is used as the first layer of the packaging. It keeps the printer safe while being handled rough by the delivery service.*

![BIQU B1 - Top layer packaging](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-packaging-3.jpg)

With the top layer of foam removed you can see right off the bat that this printer requires some assembly. This is a *good* thing. If you put a printer together yourself *you* are in control and you've touched every part. With all the vibrations during shipping, you can't assume a pre-assembled printer will be alright - so you need to check every nut and bolt *anyway*. Printers need to work with very small tolerances - so any loose bolt can potentially ruin your print. I am not very mechanically inclined - I might call myself a klutz even - but I did manage to assembly this printer. I think that anyone can put this 3D printer together - and you learn a lot while you do assembly it. 

The first layer contains some parts you need for later in the assembly process and the main parts that will form the gantry.

![BIQU B1 - Second layer packaging](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-packaging-4.jpg)

The second layer contains the most exciting parts: the printer base itself, stepper motors, and feeder. Carefully lift the parts, and finally the base out of the box. 

![BIQU B1 - Touch base](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-packaging-5.jpg)
*The base is already pre-assembled, but we will tighten the necessary bolts later in this guide.*

![BIQU B1 - Tools](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-packaging-6.jpg)
*As you can see, this printer comes with a some tools - so have them ready. Note the Allen keys have a ball head at the end. This helps adjusting nuts which you can get to at a 90-degrees angle.*

### Nuts and bolts

There are about 20 steps to follow in [the instruction manual](https://github.com/bigtreetech/BIQU-B1/raw/master/TF%20card%20data/English/USER%20MANUAL/BIQU-B1%20USER%20MANUAL%2020200907.pdf). There are a lot of bolts, nuts and screws to use - but BIQU includes all the tools you need. Every part you need is in a separate plastic bag with a label on it referring the relevant step.

<video controls muted loop>
  <source src="/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-packaging-4.mp4" type="video/mp4">
</video>
*A lot of bag and bolts - it looks a bit daunting at first - but you're guided step-by-step!*

## Base disassembly and electrical work

Before we go into assembly I like to do a little disassembly first. This can give a good judgement about the quality of the rest of the printer. If there are issues with electrical wiring - it doesn't give much hope on the rest of the printer. But, as it stands **BIQU does a good job** at the wiring.

For starters, look at the electrical switch and how it is wired.

![BIQU B1 - Electrical switch](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-inside-2.jpg)

What manufacturers often forget is to wire *both* neutral and live through the switch. Why is this important? Because in European countries like the Netherlands there is *no* guarantee which wire is live or neutral. If you only switch one off, then the device is still on power. BIQU switches both wires, and also uses a fuse to protect the wiring of the printer. If you take Creality for instance, [they do it wrong and only wire live](https://gist.github.com/Sebazzz/ff4d716c8d2ad9bab1e87b3fc4238281#power-switch-failure).

![BIQU B1 - Power supply](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-inside-4.jpg)

The wiring to the power supply is also very neat. Note that there are two wires used for grounding: one wire goes to the power inlet, the other wire is used for grounding the frame and base of the printer. I've used my multimeter to check whether this is actually done right and it shows a very low resistance (a few Ohms at most). Regarding electrical safety, I have no concerns about the BIQU B1.

![BIQU B1 - Touch screen](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-inside-1.jpg)
*The touch screen of the BIQU B1 is made by BTT - and this touch screen is a popular upgrade for Creality Ender printers*

![BIQU B1 - Motherboard](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-inside-5.jpg)

The motherboard of this printer is interesting. This a SKR v1.4 motherboard from BTT with removable stepper drivers. This means that at some point you can choose to swap out your stepper drivers with a newer or better model, or if the stepper driver is defect simply replace it. It is very nice this option is there - so you can use it when you need to.

However, replacing stepper drivers right away is not necessary. The BIQU B1 comes with the Trinamic TMC2208 stepper drivers. These stepper drivers are silent, so you don't have to worry about any 1980's "dot matrix" noise while the printer runs.

![BIQU B1 - Bed](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-inside-6.jpg)
*The BIQU B1 features a heated bed. This is optional - but recommended - for PLA printing, but necessary for PETG and ABS printing. The heated bed is insulated at the bottom, so as much heat as possible is distributed on the bed.*

You can also see that the printer is manually leveled and has the "extra tight" spring upgrade that is popular on Creality Ender printers. Even the Ender 3 V2 does not come with such upgraded springs. *Note: The foam shown here is used for securing the printer in the box - at this point I hadn't removed it yet.*

## Assembly

Let's get onto assembly. The first thing to you is to plug in the bed. Why the bed? Because the connector on the bed has long pins, and you don't want to bump into them while assembling.

![BIQU B1 - Bed heating](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-3.jpg)
*Note that this cable has no strain relief - but I don't expect it to have much strain at all during daily use - so I find that acceptable.*

### Gantry part 1
First take the largest aluminium extrusions and screw them to the pink end caps. These two extrusions form the vertical part of the gantry.

![BIQU B1 - Extrusion 1](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-4.jpg)
*First screw in the bolts at the side but **don't tighten them yet**.*

![BIQU B1 - Extrusion 2](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-5.jpg)
*Next, screw in the bolts at the bottom and tighten these. Now tighten the bolts at the side*

![BIQU B1 - Extrusion 4](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-6.jpg)
*Do the above steps for the extrusion with the stepper motor as well but **note that the small hole in the extrusion must be aligned outside**. This hole will later be used to fit the Z-endstop.*

![BIQU B1 - Extrusion 3](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-6b.jpg)
*The stepper motor is already mounted to the pink end cap where you mount the aluminium extrusion on.*

### Bed rollers
Before we continue, let's first properly tension the bed rollers. The Y-axis of the printer moves on four wheels. Two wheels are fixed, two wheels are mounted with eccentric nuts. 

![BIQU B1 - Eccentric nuts](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-7.jpg)
*Eccentric nuts are off-center and allow moving the wheels away or to the aluminium extrusion*

Now we don't have the gantry mounted yet, it is a bit easier to reach the bed rollers. Most likely you will need to tension or loosen them. 
To determine that, try to wobble your bed. 

![BIQU B1 - Bed wobble](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-9.png)
*Try to wobble the bed in both lateral and and horizontal direction. If you fell any movement except for movement parallel to the Y-axis, you need to tension the wheels.*

![BIQU B1 - Eccentric nuts on the bed](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-10.jpg)
*With the wrench you can tension the nuts under the bed.*

When tensioning your bed, you need to do this **Very Carefully**. You turn the eccentric nut a bit, test again and then repeat as necessary. When there is no wobble, check whether you can still move the wheels by hand. If you can't, you need to loosening the wheel by turn the eccentric nut a *tiny bit*. You can't skip this step, because you may wear out your wheels otherwise. 

When the bed is sturdy, check if it isn't binding when you move it back and forth and you're good to go.

### Gantry part 2 - going up!
Mount the aluminium extrusions to the side of the printer. This is easy, because you don't need to lift the printer up to do this. 

<video controls muted loop>
  <source src="/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-1.mp4" type="video/mp4">
</video>

*Don't tighten the screws fully yet, it may have a bit of play because the X-axis will be mounted and that will determine how we will tighten these screws*

Next, take the connecting piece for the lead screw (in the bag named "Coupling device"). It has very small nuts, called "grub screws", which you need to screw out a little bit.

![BIQU B1 - Z-rod coupling device](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-9.jpg)
*In this case the grub screw was screwed in*

The lead screw will be mounted on top of the coupling device. The stepper motor axis has one flat side, and you need to align the grub screw to that.

![BIQU B1 - Z-rod coupling device too low](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-11a.jpg)
*Note the flat side on the stepper motor axis. The coupling device is far too low in this picture though, the lead screw does not have anything to hold onto.*

![BIQU B1 - Z-rod coupling device too low](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-11b.jpg)
*Center the coupling device so that the motor axis is midway of the coupling device, then tighten the grub screw.*

Now you can take the lead screw and put it in the coupling device. 

![BIQU B1 - lead screw](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-12.jpg)
*Note how the lead screw is protected by the rubber packaging? Some manufacturers already lubricate the lead screw. For this reason, handle lead screw **only** with the rubber protection.*

![BIQU B1 - lead screw attachment to coupling device](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-13.jpg)
*Put the lead screw in the coupling device, then tighten the grub screws. There are two of them.*

### Gantry part 3 - X-axis
A part of the X-axis assembly has already been pre-assembled. It contains the X-axis stepper motor, the feeder stepper motor, the filament run-out sensor, and the feeder itself.

![BIQU B1 - X-axis assembly](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-14.jpg)
*Align the X-axis assembly with the lead screw and the aluminium extrusion - then turn the lead screw manually*

<video controls muted loop>
  <source src="/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-2.mp4" type="video/mp4">
</video>

*Gently lower the X-axis assembly by turning the lead screw using the coupling device*

![BIQU B1 - X-axis assembly](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-14a.jpg)
*Don't forget to properly tension the wheel on the X-axis assembly!*

There is another part of the X-axis assembly which goes on the other aluminium extrusion. The side with the two fixed wheels goes on the right side of the gantry, the single wheel on the "inside".

![BIQU B1 - X-axis assembly](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-14b.jpg)
*The other part of the X-axis assembly has needs to be tensioned as well*

If both items have been mounted, we can mount the top bar.

![BIQU B1 - top of the gantry](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-15.jpg)
*Guess which one?*

Mount the top bar, but do not tighten the screws just yet.

![BIQU B1 - top of the gantry](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-16.jpg)
*We don't tighten the screws just yet - we will let the X-axis determine how this needs to sit*

Now we are ready to mount the X-axis. Align the extrusion with the right side first and mount it.

![BIQU B1 - X-axis right side](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-17.jpg)
*The aluminium extrusion has a small extrusion that matches the nut at the roller side.*

The T-nuts are a bit tricky to get right if you're doing this for the first time. To get them in the aluminium extrusion, first loosen the nut so that the T-nut turns, then tighten it. The T-nut will grab onto the inside of the aluminium extrusion.

The left side of the X-axis, at the feeder, is quite simple. These are just some bolts.

![BIQU B1 - X-axis left side](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-18.jpg)
*Note that you also need to mount this aluminium nut that will act as the X-axis endstop trigger*

Now the X-axis is fully mounted - turn the Z-rod so that the X-axis moves fully to the top. After that, tension the grantry top.

![BIQU B1 - X-axis and gantry top](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-19.jpg)
*By tensioning the top last, everything is exactly positioned without any binding happening.*

Now we have a nice square gantry, we can tighten the screws that hold the gantry to the frame.

![BIQU B1 - X-axis and gantry bottom attachment 1](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-20a.jpg)
*Tighten the screws at the bottom, then the screws at the top. Don't apply too much force though.*

![BIQU B1 - X-axis and gantry bottom attachment 2](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-20b.jpg)
*After you've tensioned the screws, don't forget to plug in the Z-stepper motor.*

## X-axis - pulley assembly
The gantry is ready, let's get the X-axis pulley ready. The hot-end will ride on the pulley along the X-axis. The pulley is driven by a belt, which is driven by a stepper motor. Before doing anything, you can put it on the X-axis first and once again tension the wheels using the eccentric nut.

![BIQU B1 - X-axis pully belt mounting](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-21a.jpg)
*The belt has a metal crimp on each end. This metal crimp goes into the slot - aiming to the bottom.*

The belt goes over the stepper motor gear, then in the aluminium extrusion back to the pulley. When you have one side of the belt attached to the pulley, you can put the pully on the X-axis. 

![BIQU B1 - X-axis pully  belt mounting](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-21e.jpg)
*Note that the X-stepper motor has teeth which grab into the teeth of the belt*

![BIQU B1 - X-axis pully  belt mounting](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-21b.jpg)
***Wrong** - In this case you have put the pully on the X-axis first before the belt. The belt must be situated below the wheels.*

![BIQU B1 - X-axis pully  belt mounting](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-21c.jpg)
***Wrong** - The belt goes under the wheels - not parallel to them.*

![BIQU B1 - X-axis pully  belt mounting](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-21d.jpg)
***Correct** - The belt is situated below the wheels.*

## X-axis - belt tensioning
The belt of the X-axis must be tensioned correctly, otherwise the printer will not be accurrate. For this you need to mount the belt tensioner, which also contains the idler on which the belt runs.

![BIQU B1 - X-axis pully belt tensioning](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-22.jpg)
*The trick I use for creating enough force is to take the Allen key and use that as leverage. Then you can first tension the innermost bolt, then the outermost bolt.*

The belt is properly tensioned when it has almost no movement when you press on it. Don't overtension it though, because it will wear out early or even snap.

![BIQU B1 - X-axis pully belt tensioning](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-22b.jpg)
*Properly tensioned. Do verify that the idler, aluminium extrusions are in the same straight path and don't allow the belt to rub.*

## Hot-end and spool holder
The hot-end is already pre-assembled. Mounting this is as easy as mounting the two bolts.

![BIQU B1 - Hot-end assembly](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-23.jpg)
*Ensure not to drop the hot-end while assembling. It might be the most delicate equipment on this printer.*

The spool holder goes on the top of the printer - it has T-nuts that grab onto the aluminium extrusion.

![BIQU B1 - Spool holder](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-24.jpg)
*Note that the spool holder goes near the Z lead screw and essentially has a overhang.*

![BIQU B1 - Hot-end assembly](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-25.jpg)
*The path for the filament, the bowden tube, is wrapped in plastic. Unwrap it.*

![BIQU B1 - Hot-end assembly](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-26.jpg)
*The bowden coupler screws into the feeder. Just hand tighten it. It will experience almost no rotational forces, so it won't need to be screwed in with a wrench.*

The hot-end gets its power from a USB-C cable. A very clean solution to what would be a mess of cables otherwise.

![BIQU B1 - Hot-end USB-C](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-27a.jpg)
*There is only one place it can go. Support the hot-end while plugging in the USB-C cable.*

![BIQU B1 - Hot-end USB-C](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-27b.jpg)
*The USB-C cable goes to the back-side of the printer.*

## End-stop

Install the Z-axis endstop. It goes in the small hole on the gantry.

![BIQU B1 - Z-axis endstop](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-28.jpg)
*The Z-axis endstop is a spring with a bolt. This allows changing it if necessary (for instance, if you change to a higher buildplate)*

This is a good opportunity to calibrated the Z-endstop. The combination of the bed leveling, the Z-endstop, and the height of the nozzle has the result of the nozzle hitting and scratching the bed, not hitting the bed at all, or having a nice even first layer. 

![BIQU B1 - Z-axis endstop](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-28b.jpg)
*Turn the Z-axis coupler to slowly decrease the position of the X-axis until either the switch hits the endstop or the pink metal hits the endstop holder.*

If the switch on the X-axis hits the endstop first, it is fine. Otherwise you will need to either unscrew the endstop bolt a bit so the switch is hit first. Ensure the nozzle does not hit the bed - or tension the bed screws as necessary.

![BIQU B1 - Z-axis endstop](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-28c.jpg)
*The switch clicks when it hits the endstop.*

## Cabling
There is some cable management to perform. First plug in the cables, then tidy them.

![BIQU B1 - Cabling](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-29.jpg)
*Plug in the extruder stepper motor (1), the X-axis stepper motor (2) and the filament runout sensor (3). The cables are labeled.*

![BIQU B1 - Cabling](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-30.jpg)
Use the included cable wraps to tie the USB-C cable to the bowden tube (2x), the USB-cable to the slot at the extruder, and the X-axis cabling to the pink metal.

![BIQU B1 - POWERRR](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-31.jpg)
***Don't forget* to set the correct voltage for your country on the power supply.*

## First boot
Now is the moment on truth... did you do everything right? Plug in the C13 connector at the rear side of the printer and turn it on. 

![BIQU B1 - POWERRR](/images/blog/2020-09-29-biqu-b1-unpacking-and-assembly-assembly-32.jpg)
*It's alive! At the point I took this photo I already went to the movement screen to test the stepper motors.*

Before you do anything, go to the "Motion" menu and home all axis. This command will move all axis to their respective end-stop sensors. At the point the position of each of the steppers is known to the printer.

After that, the next steps, which I will not cover today, are:

- [Leveling the bed](https://teachingtechyt.github.io/calibration.html)
- Doing a first test print

Until the next - where I will review the BIQU B1!