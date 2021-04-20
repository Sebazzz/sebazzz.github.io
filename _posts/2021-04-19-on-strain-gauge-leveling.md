---
layout: post
title:  "On strain gauge leveling on (Creality) 3D printers: How it works and notes on accuracy"
date:   2021-04-19 15:00:00 +0200
categories: 3d-printing
---

"Strain gauge leveling demystified!" or insert some other clickbait title 😉 Let's look at how strain gauge leveling works on Creality printers, what influences the accuracy, and how to interpret the results!

## Introduction


<style scoped>
  img + p, img + em {
    clear: both;
    display: block;
  }
</style>

Creality introduced leveling **using the nozzle of the printer** with the Creality CR-6 3D printer. I've had two Creality CR-6 printers for over six months now and have [also been developing the Community Firmware](/blog/2021/03/27/creality-cr6-community-firmware-release-6-is-here) for this printer. Currently I'm testing a Creality CR-10 Smart printer which has strain gauge leveling as well.

![CR-6 strain gauge weighting](/images/blog/2021-01-19-mounting-the-biqu-h2-to-creality-cr6/01-disassembled.jpg)
*The naked strain gauge bracket on the Creality CR-6 SE X-carriage*

I've received a lot of questions regarding the leveling on the printer - [especially regarding the new leveling screen](https://github.com/CR6Community/Marlin/releases/tag/v2.0.7.3-cr6-community-release-6#new-features) introduced in the printer. This prompted me to write this article regarding leveling.

In this article I write about how to interpret the results, how the strain gauge leveling works and how to improve accuracy.

## Interpreting bed leveling results

What I write below applies to any bed leveling probe, but to the CR-6 strain gauge in particular. 

**The bed leveling results say _nothing_ about the physical state of the bed, if the probing results are not accurate.** You can have all points near-zero, but if the probing isn't accurate, you still cannot print well. If your bed isn't perfect, the numbers are not perfect, but the probing is accurate - then you are above to print well. 

![Good mesh vs bad mesh, leveling results](/images/blog/2021-04-19-on-strain-gauge-leveling/good-mesh-bad-mesh.jpg)
*Bad mesh vs good mesh? Is any of these good or bad? The numbers can lie. Thanks to @ztakis on Github providing the picture on the right. Both meshes print right though.*

**Bad bed leveling is not Marlin not compensating for the mesh, but rather the mesh not being accurate.** Interfere during bed leveling, then go printing and note how Marlin compensates perfectly well for the mesh. We will look into probing accuracy issues down below.

What can you do with this information then? 

1. You can run bed leveling multiple times and check if the numbers change much. If they do, you have a probe accuracy issue.
2. You can tap a number and manually enter a new value. The values are relative to the homing position, and represents in which direction and how much the Z-axis should move to compensate for an unleveled bed.

**Bottom line: If your printer prints fine, then it is no issue that the bed leveling mesh looks like a rainbow.**

## What is a strain gauge?

A strain gauge measures deformation on an object. The object measured is usually some kind of metal bracket or metal extrusion. On the wires of the strain gauge a voltage is applied, and when the objects experiences deformation, a millivolt signal can be read back.

![Strain gauge in a kitchen scale](/images/blog/2021-04-19-on-strain-gauge-leveling/kitchen-scale.jpg)
*A digital kitchen scale has a strain gauge internally*

[![Strain gauge in a kitchen scale](/images/blog/2021-04-19-on-strain-gauge-leveling/strain-gauge-kitchen-scale.jpg)](https://youtu.be/Iyh6ZCYQnX0?t=294)
*This [excellent video of Diode Gone Wild](https://youtu.be/Iyh6ZCYQnX0?t=294) explains how a digital kitchen scale works.*

The CR-6 / CR-10 Smart has a similar strain gauge, which is used for leveling. That also makes that the strain gauge has a trigger weight, which is also one of the characteristics.

### Characteristics of strain gauge leveling

With this knowledge, some of the characteristics of strain gauge leveling are:

- Triggers at a certain weight
  - This makes it by extension more susceptible inaccuracy due to mechanical issues and slop in the system.
- It can be tared / zeroed, just like kitchen scale
  - This is necessary to reduce false readings caused by the bowden tube pulling on the hotend as the X-carriage moves during the probing sequence.
- Because the nozzle effectively is the probe, there is no X/Y probe offset.
  - This has the advantage that regardless how large your hot-end is, you will always be able to probe every point the nozzle can reach.

### How strain gauge probing works on the CR-6

You can already guess how this works on the Creality printers with strain gauge leveling. On a very high level it works like this:

1. The hot-end is mounted on the strain gauge.
2. The hot-end moves down to the build plate.
3. When the hot-end touches the build plate and the strain gauge bracket deforms.
4. The firmware knows now that the build plate has been touched.

The optical sensor of the gantry determines *when* to listen to the strain gauge. It is however possible to compile the firmware so that it ignores the optical sensor (check the troubleshooting section for that).

### Strain gauge leveling components

There are three major components to the CR-6 strain gauge leveling:

1. The strain gauge.
2. The hot-end daughter board / breakout board. This board sends a Z-endstop signal to the motherboard.
3. The optical sensor on the gantry, (in my option incorrectly) called the Z-endstop.

![Optical sensor of the CR-6 SE](/images/blog/2021-04-19-on-strain-gauge-leveling/opto-sensor.jpg)
*The optical sensor on the gantry.*

When the optical sensor is blocked, the firmware tares the strain gauge and starts listening to the Z-endstop signal. 

![Overview of the CR-6 strain gauge](/images/blog/2021-04-19-on-strain-gauge-leveling/overview.jpg)
*The strain gauge bracket and the hot-end daughter board.*

The following components can be identified here: 

1. The [HX711 "Analog-to-Digital converter for weigh scales" chip](https://github.com/CR6Community/Hardware/blob/master/CR-6%20SE%20hotend%20PCB/CR-6%20SE%20hotend%20PCB%20V0.1/Datasheets/IC's/HX711%20ADC%20-%20SOP16.pdf) which reads the strain gauge itself.
2. A 32-bit ARM [STM32F030F4 microprocessor](https://github.com/CR6Community/Hardware/blob/master/CR-6%20SE%20hotend%20PCB/CR-6%20SE%20hotend%20PCB%20V0.1/Datasheets/IC's/STM32F030F4%20Microcontroller%20-%20TSSOP20.pdf) that runs firmware written by Creality. It reads the signal of the HX711 chip, listens to the motherboard for a tare signal, and returns a Z-endstop signal. 
3. The strain gauge itself, glued onto a metal bracket.
4. The bowden tube fitting and mount of the hotend. Some people put a washer at the screw marked by (4) to help with leveling.
5. The 4-wire connection to the strain gauge.
6. [A potentiometer](https://github.com/CR6Community/Hardware/blob/master/CR-6%20SE%20hotend%20PCB/CR-6%20SE%20hotend%20PCB%20V0.1/Datasheets/Passives/BOURNS-3313J-1-103E%2010kohm%20potentiometer.pdf) that can be used to set a threshold for the strain gauge to trigger. It does _not_ control a sensitivity. The potentiometer is read by the firmware on the STM32 chip (2).

If you're interested in the firmware blob or reverse engineered schematics of this board, you [can find them in the CR6Community hardware repository](https://github.com/CR6Community/Hardware).

## Strain gauge leveling - accuracy factors

When strain gauge leveling works, it does work perfect. When it doesn't, it leaves a lot of things to check.

That said, I recommend to leave things as they if you don't have bed leveling issues. There is no shame in an imperfect bed leveling mesh 😉

### Trigger weight

What I've shown in [my BIQU H2 DD mount article](https://damsteen.nl/blog/2021/01/19/mounting-the-biqu-h2-to-creality-cr6) is that you can weight the strain gauge. 

To weight your strain gauge:

1. Remove the cover, so that the PCB is well visible.
2. Move the X-carriage to the center position.
3. Turn the printer off and then on. This is important. The strain gauge is tared when the printer is turned on.
4. Place a digital kitchen scale on your printbed.
5. Lower the Z-axis manually, by turning the couplers, down onto the scale. 
6. While lowering Z-axis, watch the scale and the hot-end daughter board. At some point after the nozzle hits the scale, and you keep lowering the Z-axis a LED will turn on. At that exact moment note the weight.

![Bed leveling - perfect (for me)](/images/blog/2021-01-19-mounting-the-biqu-h2-to-creality-cr6/strain-gauge-weight.jpg)
*For me a weight of 160 grams worked well. Your mileage may vary.*

![Bed leveling - too much weight](/images/blog/2021-01-19-mounting-the-biqu-h2-to-creality-cr6/strain-gauge-weight-too-much.jpg)
*560 grams was too much for me. During bed leveling, the bed was bending in the corners.*

If you want to adjust the sensitivity of the strain gauge you can adjust the RP1 potmeter on the board. Adjust it a tiny bit, preferably with a plastic screwdriver, then repeat steps 3 onwards. It is very important you turn the printer off and on again.

### Mechanical factors

![X-carriage](/images/blog/2021-04-19-on-strain-gauge-leveling/x-carriage.jpg)
*The X-carriage has eccentric nuts. If they are loose (try to move it up and down!) it will affect bed leveling, even when it might not always affect printing.*

![X-carriage (front)](/images/blog/2021-04-19-on-strain-gauge-leveling/x-carriage-front.jpg)
*I had the screws on the strain gauge (1 and 2) coming loose once, during a long vase print. It caused a pretty bad layer shift. In addition you may want to consider adding a washer on (3).*

![Hotbed](/images/blog/2021-04-19-on-strain-gauge-leveling/bed.jpg)
*Spacers and eccentric nuts*

Under the hotbed there are the eccentric nuts. These need to be tightened.

#### Spacers under the hotbed
There are also the spacers on which the hotbed rests. Some people have reported that their spacers don't have the same height. That can cause "bending" of the bed during probing.

You can either use aluminum foil or sand paper to make sure they are of the same height. The point is that the bed must be supported well. Some people have replaced the spacers with silicone spacers and reported success. Others have tightened or loosened (some of) the screws of the hotbed.

#### X-axis not level

When the X-axis is not leveled, the bed leveling might be inaccurate.

[![Leveling X-axis](/images/blog/2021-04-19-on-strain-gauge-leveling/x-leveling.jpg)](https://www.youtube.com/watch?v=MUmqPfcxLv0&t=2s)
*This [video of Creality](https://www.youtube.com/watch?v=MUmqPfcxLv0&t=2s) explains how to level the X-axis.*

I use a slightly different procedure for leveling the X-axis:

1. Lower the X-axis to the bed.
2. I loosen the grub screws of the timing belt on the *left side*.
3. I loosen the grub screws holding the lead screw to the coupler of the *right side* stepper motor.
4. Then I level the X-axis as shown in the video, but by turning the timing belt.
5. I verify everything is good and tighten the grub screws again.

### Firmware

It is a bit like [Toilet duck advising Toilet duck](https://en.wikipedia.org/wiki/Wij_van_Wc-eend_adviseren_Wc-eend), but I do recommend the [Community Firmware for the CR6](https://github.com/CR6Community/Marlin/). 

We've found out during the development of the beta 5 release that electrical noise can greatly interfere with the accuracy of the probe. Electrical noise like the PID signal to the hotend heater cartridge, while the HX711 chip reads a tiny millivolt signal from the strain gauge itself. 

For this reason the firmware turns the heaters off while actual probing happens. Turn turning "better accuracy" off from the leveling settings and re-level the bed. Note how much the leveling points change. 

## Troubleshooting

Some common issues and troubleshooting steps below. Note that "your mileage may vary".

### My bed leveling is inaccurate

Check the previous chapter ["Strain gauge leveling - accuracy factors"](#strain-gauge-leveling---accuracy-factors).

#### If all else fails

If you still can't get proper bed leveling results, you may want to try manual bed leveling. It might also be worth to buy a new strain gauge. I've had one bad strain gauge myself, and replacing it fixed the problem (on my CR-10 Smart).

![Manual bed leveling on the CR-6](https://user-images.githubusercontent.com/1426097/110147870-72f70300-7ddc-11eb-842a-af92069bb076.png)
*You can always resort to manually correcting the leveling mesh*

When viewing the bed mesh, tap a number and manually enter a new value. The values are relative to the homing position, and represents in which direction and how much the Z-axis should move to compensate for an unleveled bed. You can also do this from Octoprint via gcode `G29 W I[number] J[number] Z[z-height]`.

### During homing the nozzle is pushed into the bed and doesn't stop

It is possible either your hot-end breakout board or the optical sensor (or its cable) has failed.

If you happen to run the Community Firmware, then you can issue gcode `M119` from Octoprint or computer with Pronterface. You will receive a response:

```
Reporting endstop status
x_min: open
y_min: open
z_min: open
probe_en: open
filament: open
```

**Verify functionality of optical sensor:** Block the optical sensor, with an Allen key for instance and issue `M119`, and check if `probe_en` says `TRIGGERED`. Ensure the optical sensor is plugged into the correct port (J2 for v4.5.3 boards). If you have determined your optical sensor is broken, you can [compile the firmware](/blog/2021/01/08/how-to-compile-cr6community-marlin-with-vscode-platformio) and place `\\` before `#define PROBE_ACTIVATION_SWITCH`. This allows the firmware to ignore the optical sensor. 

**Verify functionality of strain gauge mechanism:** Push the nozzle up and issue `M119` while you do that. Check if `z_min` says `TRIGGERED`. You can also try to decrease [the trigger weight](#trigger-weight).

### During leveling the bed is bending in the corners

You need to decrease [the trigger weight](#trigger-weight) of the strain gauge.

### My nozzle always homes above the bed and during leveling it always raises in height

If you have already tried to decrease [the trigger weight](#trigger-weight) of the strain gauge, your strain gauge or hot-end breakout board may be broken. Check ["During homing the nozzle is pushed into the bed and doesn't stop"](#during-homing-the-nozzle-is-pushed-into-the-bed-and-doesnt-stop) above. In the output of command `M119` the value of `z_min` would always show `TRIGGERED`.

### My nozzle (sometimes) homes above the bed or sometimes raises in height during leveling

You need to increase [the trigger weight](#trigger-weight). I suspect this is a bug in the hot-end breakout board firmware. It seems to be happening if during a tare, the difference between the pre-taring and post-taring weight is not large enough.

In addition, remove any custom bowden clips or anything that interferes with the cabling or bowden tube. I recommend [to print this CR-6 cable support *without the bowden support*](https://www.thingiverse.com/thing:4744241). 

### I need to adjust my Z-offset every print

Try the [Community Firmware for the CR6](https://github.com/CR6Community/Marlin/) and make sure "Better accuracy" is enabled in the *leveling settings screen*. I also recommend to [use the recommended start gcode](/blog/2021/02/11/creality-cr6-community-firmware-start-print-without-drooping) and then disable "Stabilize temperatures".

## Conclusion

The strain gauge leveling system is sometimes a difficult beast to tame. However, I hope I've provided some useful guidance in getting more accurate bed leveling results.

That said, maybe there is even more to it than this, so if you have any additions, please write a comment down below!
