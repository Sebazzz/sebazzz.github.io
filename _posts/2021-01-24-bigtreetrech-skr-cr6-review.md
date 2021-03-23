---
layout: post
title:  "BigTreeTech SKR CR6 review - an alternative motherboard for the Creality CR-6"
date:   2021-01-24 21:00:00 +0100
categories: 3d-printing
---

After the first users received their Creality CR-6 units it quickly became clear [there were some (severe) teething issues](https://gist.github.com/Sebazzz/ff4d716c8d2ad9bab1e87b3fc4238281) with this new printer. In particular, the motherboard labeled version 4.5.2 sometimes fail. Sometimes simply resulting in the printer not booting, sometimes failures with smoke and sparks. These failures could sometimes cascade to other printer components or connected devices like a computer or Raspberry PI. Early November the BigTreeTech introduced their [BigTreeTech SKR CR6](https://www.aliexpress.com/item/1005001728994394.html) motherboard of which I wrote [an installation guide earlier](https://damsteen.nl/blog/2020/11/25/how-to-btt-skr-cr6-installation). After using this board for several months I will now give my thoughts and considerations.

## The board

<style scoped>
  img + p, img + em {
    clear: both;
    display: block;
  }
</style>

This SKR board is not like the other SKR boards that BigTreeTech provides. This board has been specifically developed for the Creality CR-6. The reason is that the Creality CR-6 uses flatcable connectors instead of separate wires for the hotend, extruder and filament sensor. The volume of the motherboard compartiment is also quite small. A regular SKR mini or turbo board would simply not work or be extremely difficult. 

![The BTT SKR CR6 motherboard](/images/blog/2020-11-25-how-to-btt-skr-cr6-installation/product-display.png)

### What's in the box

In the box you will find:

- The BTT SKR CR6 motherboard.
- Some heatsinks with thermal pads.
- Jumpers - these are generally not used. More on that later.
- A BigTreeTech good luck yellow duck.
- A tiny micro-USB cable.

![BTT SKR CR6 - box](/images/blog/2021-01-24-bigtreetech-skr-cr6-review/box.jpg)
*This is how it is packaged. In my opinion they could have left that tiny USB cable out. Unless you're running a Raspberry PI directly next to your printer it isn't really useful.*


### Specifications

Let's go over some specifications first.

- **Stepper drivers:** TMC2209 silent stepper drivers - fully firmware controlled (UART).
- **Display interface:** Stock CR-6 touch screen and BigTreeTech TFT v3.0 / classic Ender 3-style LCD
- **Expansion ports:** Neopixel (RBG) port and two user-addressable expansion ports. One port is meant for use with power loss functionality, the other is used for a relay so the printer can shut itself off.
- **Drop-in:** The original CR-6 cabling, SD card interface and micro-USB port is maintained.
- **Motherboard fan firmware controlled**: The motherboard fan is controlled by firmware - so it only runs only when the steppers run.
- **On-board EEPROM:** Just like the Creality stock board this has an on-board EEPROM for the Marlin settings.
- **USB composite mode:** Allows an attached computer or Raspberry PI to directly write to the SD card.

The next chapters will drill down on these specifications.

### UART-controlled TMC2209 stepper drivers

On the stock Creality board the stepper drivers - also TMC2209 - are wired in legacy (standalone) mode. This means that the firmware has no control over the behaviour of the stepper drivers. This is quite literally hardwired. If you do a modification to your printer that would require an axis to need more current, [you must use a multimeter and turn tiny potmeters](https://support.bondtech.se/Guide/00.+Stepper+Current+Adjustment+On+CR-10S/46) on the PCB.

In contrast, on this BigTreeTech SKR board it is [as easy as using gcode M906](https://marlinfw.org/docs/gcode/M906.html) to set the stepper driver current. One practical example where I used this, is the [BIQU H2 Direct Drive extruder mod](/2021/01/19/mounting-the-biqu-h2-to-creality-cr6). It is recommended to set the extruder stepper motor current to 800mA - so I issued a `M906 E800` and I was done. Another example is that [many people replace the extruder with an all-metal extruder](https://www.banggood.com/Upgraded-Aluminum-Dual-Gear-Pulley-Dual-Drive-Extruder-Kit-For-Creality-CR-10-or-CR-10S-or-CR-10S-Pro-or-Ender-3-or-Ender-3-Pro-3D-Printer-p-1469345.html?cur_warehouse=CN&rmmds=buy) but then find that the extruder stepper motor gets so hot that their PLA softens in the extruder. In the case of the BTT SKR board it is simply a matter of turning the stepper driver current down. 

The stepper motors, X, Y and E, all run much cooler on the BigTreeTech SKR board.

**Does it result in better print quality?**

No, but yes, but maybe? It is hard to give concrete information about this. I think it boils down to that in near-failure conditions direct stepper control *might* just save your print from having an layer shift. As can also be read on the [Marlin TMC stepper driver page](https://marlinfw.org/docs/hardware/tmc_drivers.html) - Marlin is able to receive a message from the stepper driver when it is nearing an overtemperature condition. Marlin can then lower the stepper driver current which may just prevent the stepper driver from going into a momentary shutdown - which would result in an layer shift. 

You can also choose to run your stepper drivers in spreadCycle mode. This allows for even greater torque (at the expense of noise level) than the default stealthChop mode.

You are also able to configure the stepper driver with how many steps can be interpolated into smaller microsteps. Although [this does not necessarily seem to increase print quality](https://3dprinting.stackexchange.com/a/159/21455), can reduce surface artifacts like moire or reduce the noise level even further.

UART controlled stepper drivers allow for more tweaking and tuning than is otherwise possible.

### Display interface

To make it drop-in replacement this board supports two types of displays.

![BTT SKR CR6 - stock display](/images/blog/2021-01-24-bigtreetech-skr-cr6-review/stock-display.jpg)
*Stock display running [the CR-6 Community Firmware](https://github.com/CR6Community/Marlin)*

![BTT SKR CR6 - BTT TFT](/images/blog/2021-01-24-bigtreetech-skr-cr6-review/btt-tft.jpg)
*With [the BigTreeTech TFT](https://github.com/bigtreetech/BIGTREETECH-TouchScreenFirmware#readme)*

The BTT TFT supports a more "modern" touch mode but also the classic Marlin native user interface some of us know and love.

![BTT SKR CR6 - BTT TFT](/images/blog/2021-01-24-bigtreetech-skr-cr6-review/marlinui.jpg)
*With [MarlinUI](https://marlinfw.org/docs/features/lcd_menu.html) and the rotary knob used for navigating the menus*

### Expansion ports

There are some expansion ports available on the motherboard.

![BTT SKR CR6 - stock display](/images/blog/2021-01-24-bigtreetech-skr-cr6-review/expansion-ports.png)
*BigTreeTech documented the expansion ports [in their pins documentation](https://github.com/bigtreetech/BIGTREETECH-SKR-CR6/blob/master/Hardware/BTT%20SKR-CR6-Pin.pdf)*

The expansion ports can be used with some other BigTreeTech products [for automatic shutdown of the printer](https://www.aliexpress.com/item/33041130631.html) and their [UPS that raises the Z-axis on power loss](https://www.aliexpress.com/item/4000344706917.html). I don't have experience with using these products, so I cannot recommend them. I just know they exist.

![BTT SKR CR6 - stock display](/images/blog/2021-01-24-bigtreetech-skr-cr6-review/neopixel-pins.png)
*Neopixel port*

There is also a neopixel port, this allows you to attach [an Adafruit Neopixel](https://www.adafruit.com/category/168) to bring some color to your 3d printer. There are all kinds of neopixels available, like strips and rings. The neopixels can be connected directly to the board without needing any kind of amplification.

<video controls loop muted>
  <source src="/images/blog/2021-01-24-bigtreetech-skr-cr6-review/neopixel.mp4" type="video/mp4">
</video>

*Neopixel is functional - but it doesn't work 100%*

But unfortunately the software isn't completely ready yet. The neopixel does work, but not fully. For me, usually one LED was a bit off. Either a different color, or it didn't want to turn off. There is [an open issue at Marlin to make Neopixels work reliably](https://github.com/MarlinFirmware/Marlin/issues/19800) on the microcontroller this board uses (STM32F1).

**UPDATE 2021-02-08: A recent patch has landed in Marlin that repairs Neopixel support - this will be included in Community Firmware release 6. My Neopixel is now fully operational.**

### Drop-in replacement

The board is drop-in on the current Creality CR-6 hardware - everything works, including the leveling system. I wrote [a guide how to install it earlier about that](/blog/2020/11/25/how-to-btt-skr-cr6-installation). Because this board is in hardware terms different than the stock Creality board, it comes [with its own firmware](https://github.com/bigtreetech/BIGTREETECH-SKR-CR6). That firmware is based on Creality firmware v1.0.3.7 so it comes with the same limitations as that firmware - but since the end of 2020 [the CR-6 community firmware is also available](https://github.com/CR6Community/Marlin/) for this board.

One thing to note that the optical sensor on the CR-6 gantry doesn't light up anymore. This optical sensor is supposed to run at 5 volt, but is few 3.3V instead. This appears to be a design mistake in the board, but nevertheless the sensor still does its job. *Note: this seems to be silently resolved by BTT in a newer revision of the board*

For me mounting the board was quite easy, I had the hardest time removing all the hot glue Creality used everywhere. The installation itself was quite easy. 

#### Jumpers

The board comes with some jumpers, as [described in the manual](https://github.com/bigtreetech/BIGTREETECH-SKR-CR6/blob/master/Hardware/BTT%20SKR-CR6-User%20Manual.pdf):

![Jumpers](https://user-images.githubusercontent.com/1426097/99859577-b5c7fe80-2b90-11eb-9f60-4dcfd5716db4.png)

I think these [are for the TMC2209 stall guard function](https://github.com/bigtreetech/BIGTREETECH-SKR-CR6/issues/2). This means you can home without endstops. It is nice of BigTreeTech to include the *possibility* but in practice I don't think anyone will use this function on this printer. We have perfectly good endstops on the printer so StallGuard has not much use on this printer.

#### MOSFET repair

However, when I tried to heat the hotend my printer rebooted. It took a while to figure out, but a MOSFET and diode on the board was shorted. I have no experience soldering PCBs at all but I was able to replace the MOSFET and diode. The board worked well after that procedure - but I did get a replacement board. Both boards still work perfectly now - months later.

![BTT SKR CR6](/images/blog/2021-01-24-bigtreetech-skr-cr6-review/mosfet-schematic.png)
*MOSFET Q2 (marked red) is the hotend MOSFET and D1 is a diode. Any of them which caused the other component to fail. The purple arrow points to the heatbed MOSFET Q3 - this one was fine.*

![BTT SKR CR6](/images/blog/2021-01-24-bigtreetech-skr-cr6-review/soldering-job.jpg)
*I used the heatbed MOSFET and diode from my failed Creality v4.5.2 board to replace the failed component. I probably couldn't have done a better soldering job with the tools I had at the time.*

Still, with the short that happened it is _remarkable_ that no cascade failure happened. I know that failures on the Creality v4.5.2 board often cause the leveling sensor mechanism to be damaged as well. No such thing happened here: the board and power supply protected the other components, no other components were damaged.

I'm convinced this was just a case of bad luck, and the BigTreeTech support is quite good I gather, but I needed to mention this of course.

### Motherboard fan is firmware controlled

We know the fans on the Creality CR-6 are not the most silent fans. The motherboard fan on the BigTreeTech SKR CR6 board can however be controlled by the firmware: it is not hardwired to the 24 volt input of the board. On the default BigTreeTech firmware that feature is not enabled - but I've activated this in the community firmware.

On idle you will only hear the hotend fan - this one is hardwired to the 24V power supply. I did notice that the page on AliExpress mentions the extruder fan is also CNC controlled, but maybe they are confusing the part cooling fan. 

### USB composite mode

The board has USB composite mode. That means you can hook up your computer and then access the SD card on the printer while the printer is on.

![BTT SKR CR6](/images/blog/2021-01-24-bigtreetech-skr-cr6-review/libmaple.png)
*With the printer on and connected you can simply access the SD card, put firmware or gcode files on it, and start printing immediately*

It is a small convenience, but I have only one Raspberry Pi with Octoprint, and now I can easily put a gcode file on the SD card without the need to mess with SD card adapters and USB sticks. 

### Firmware flashing

As a firmware developer, probably for regular users this is less of an pro, I like how the firmware flashing process works.  

![Firmware download](/images/blog/2020-11-25-how-to-btt-skr-cr6-installation/before-flashing.png)
*Firmware you want to flash must be named as `firmware.bin` on the flash drive. Anything else will be ignored.*

![Firmware after flashing](/images/blog/2020-11-25-how-to-btt-skr-cr6-installation/after-flashing.png)
*When you have eventually flashed the firmware, you'Il find that the file has been renamed to `FIRMWARE.CUR`*

This way you don't have to doubt whether the firmware got flashed. While the firmware is you can also see "progress" because the LED near the hotend is flashing on and off. 

<video controls loop muted>
  <source src="/images/blog/2020-11-25-how-to-btt-skr-cr6-installation/led-flashing.mp4" type="video/mp4">
</video>

*While the firmware is being flashed, the LED near the hotend will also flash*

### Firmware

Even before the first boards were delivered, BigTreeTech published its own firmware for this board, [which they maintain on Github](https://github.com/bigtreetech/BIGTREETECH-SKR-CR6/). Usually BigTreeTech forks Marlin and works from that, but when this board was introduced, official Marlin had no strain gauge leveling capabilities and Creality has by now (still) only released the source code of their [v1.0.3.7 firmware](https://github.com/CR6Community/Marlin/tree/official-fw/v1.0.3.7). 

I have integrated the changes from BigTreeTech into [the CR-6 Community Firmware](https://github.com/CR6Community/Marlin) and this was released as part of [the 5 beta release](https://github.com/CR6Community/Marlin/releases/tag/v2.0.7.3-cr6-community-release-5-beta). Not all people want to run unofficial firmware - so where does this leave you on the firmware then?

**If you have the BTT TFT:** You can either use the BigTreeTech firmware *or* compile Marlin yourself. [After this pull request from mine](https://github.com/MarlinFirmware/Marlin/pull/20522) official Marlin has gained support for this board.

**If you have the stock Creality TFT:** You can either run the community firmware or the BigTreeTech firmware. I don't think you must expect too many features on the BigTreeTech firmware in terms of feature development. BigTreeTech has their own TFT and in my opinion you can't expect them to develop features in the Creality TFT software. From Creality we cannot hope for any new source code releases either I'm afraid.

## Known issues

There are also some known issues with this board, but none of them are really blocking in my opinion. Just good to be aware of.

- The board can still be back powered from USB when the printer is off - requiring to [apply the 5V USB tape workaround](https://community.octoprint.org/t/put-tape-on-the-5v-pin-why-and-how/13574) - just like on the stock Creality boards. Usually BigTreeTech boards don't have this issue, but this particular board has. This may change in a future hardware revision.

- Some people have experienced fluctuating temperature reports when the printer is cold and has not run yet. Temperatures jump beteen 9 and 15 degrees Celcius - when the temperatures are below 40 degrees C. This does not appear to impact the actual printing though: the printer is able to reach, maintain and measure temperatures just fine. 

## Pro's and cons

**Pro's:**

- **Full firmware control of the stepper drivers** allows for easier modding and tuning - and probably also reliability.
- Stepper motors run much **cooler** by default. 
- USB composite mode allows you **access the SD card without removing it from the printer**.
- Supported option to replace Creality stock TFT with the BigTreeTech TFT.
- Documented expansion options make other functionalities possible like improved power loss recovery and automatic shutdown of the printer.

**Cons:**

- Official firmware development will probably not have the highest priority. The board is fairly niece (Creality CR-6 printers only). However, the CR-6 community firmware is now fully compatible with this board - and this is a worthy alternative for many people [citation needed 😉].
- Depending on your use case and current board, it might be hard to justify the cost of replacement.

**Other thoughts:**

- I had hoped on replaceable stepper drivers when this board was announced - but this is simply not possible in the space available for the motherboard.
- BigTreeTech has published documented diagrams of the board, specifying all the pinouts. 

If there would be another iteration in this board, I'd like to see:

- 12V power supply for the motherboard fan. That would help with replacing fans with more silent versions.
- That tiny 20 centimeter USB cable the BTT SKR CR6 board comes with is not really useful.

## Conclusion - Should I upgrade?

In general: I'd say __"yes, probably"__. I'Il try to answer this question specifically based on the board you might have in your printer.

### When you have a Creality v4.5.2 board (most likely case)

**Replace your board.** It will most likely fail partially or completely sooner or later - often resulting [in a puff of smoke](https://gist.github.com/Sebazzz/ff4d716c8d2ad9bab1e87b3fc4238281#lets-count). This has been shown on multiple occasions, and the failures are often not USB related. Often when this particular motherboard fails, it takes the strain gauge leveling hardware with it too. That means that at point to need to buy a new motherboard *and* a new board for the hot-end.

Related this board seems to have many issues reading SD cards. This might be related to electrical interference, but also due to fact that SDIO is used on this board [and the STM32F103RET6 processor on the board has many "errata" (known issues) listed](https://www.st.com/resource/en/errata_sheet/cd00197763-stm32f101xcde-and-stm32f103xcde-highdensity-device-limitations-stmicroelectronics.pdf) in terms of using SDIO for reading SD cards. As an user you will see this as prints stalling or firmware updates not flashing correctly.

As a firmware developer I've seen many reports of boards that simply ignore firmware updates, apply these firmware updates just partially (corrupted update), or that firmware spontaneously becomes corrupted, resulting in stepper motors not working or random functions of the firmware not working. In fact, this is how my v4.5.2 board died. One day, after it froze while heating up, it simply refused to boot into Marlin - but using a debugger (ST-Link) I was able to confirm that Marlin was flashed. I never got it to work again though.

### When you have a Creality v4.5.3 board 

This board is the "stability iteration" of the v4.5.3 board and solves many of the issues that the v4.5.2 board (see above) has. It most certainly resolves the "smoke" issue. 

That said, this board generally seems to be more stable, and I haven't heard much about SD card issues - but many people don't have this board so the sample size I base this conclusion on is also smaller.

Still, not considering any potential stability issues on the v4.5.3 board - for the price the BTT SKR CR6 board sells for **I'd still recommend it**. Full firmware control over the stepper drivers makes tuning things a lot easier, especially once you want to start modding your printer (like [adding a direct drive](/blog/2021/01/08/biqu-h2-direct-drive-extruder-first-look)). If you don't mod your printer, the cooler stepper drivers or the ability to use all the potential of Marlin through the BigTreeTech TFT might still be worth it.

### When you have a Creality v1.1-ERA board

This board is completely unknown and is really the odd man out. Creality has not released source code for the firmware on this board, and unless someone starts poking them really hard to release the source code, they won't release it. That means you are tied to the Creality limited firmware updates Creality provides - and Creality doesn't seem to be interested into providing many new features.

In terms of stability this board still needs to be proven - but its design seems similar to the v4.5.3 board so that will probably be alright. So, my advice on the v4.5.3 board applies here too.

## Where to buy

The board is [available on AliExpress](https://www.aliexpress.com/item/1005001728994394.html) for about €33 ($39) including shipping. It might also be available on your local Amazon or other reseller. From time to time there it is sold at a discount price and the board is available for about €10 / $10 cheaper.