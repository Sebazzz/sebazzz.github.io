---
layout: post
title:  "How-to: RGB on your printer! Mounting a Neopixel to the Creality CR-6 SE"
date:   2021-04-11 15:00:00 +0200
categories: 3d-printing
---

In this article I will show you how to mount an Adafruit Neopixel to your Creality CR-6 SE. A Neopixel allows for printer-firmware controlled light. You can control a Neopixel from gcode, or let the firmware automatically control it (for instance, when heating).

![Neopixel on the CR-6 SE with a E3D Hemera](/images/blog/2021-04-11-how-to-mount-neopixel-to-creality-cr6/intro.jpg)

## Gimmick?

<style scoped>
  img + p, img + em {
    clear: both;
    display: block;
  }
</style>

I had [neopixels on my BIQU B1 printer](/blog/2020/10/18/biqu-b1-review) and thought it was a gimmick, at first. However, Marlin can use the neopixels itself also to communicate the current state.

![Neopixels](/images/blog/2021-04-11-how-to-mount-neopixel-to-creality-cr6/status-led.jpg)
*When heating the hot-end, Marlin shows the progress as an increasingly amount of LEDs being lit, changing color*

You can also fully control it, using the [`M150` - Set RGB(W) Color](https://marlinfw.org/docs/gcode/M150.html) gcode.

![Neopixels](/images/blog/2021-04-11-how-to-mount-neopixel-to-creality-cr6/printer2a.jpg)
*Mounted on my Kickstarter Creality CR-6 SE*

![Neopixels](/images/blog/2021-04-11-how-to-mount-neopixel-to-creality-cr6/printer1a.jpg)
*Mounted on my second CR-6 SE*

## Bill of materials

For installing RGB neopixels you need at least:

- Compatible motherboard. The [BTT SKR CR6](/blog/2021/01/24/bigtreetrech-skr-cr6-review) has a dedicated neopixel port. Supposedly the stock Creality board can do it as well, but I've not tested it and the specifications are not public.
- A Neopixel mount, download from your favorite website or design it yourself. I've made two mounts:
  - [16-LED neopixel ring mount](https://www.thingiverse.com/thing:4821571)
  - [8-pixel neopixel strip mount](https://www.thingiverse.com/thing:4823634)
- A Neopixel strip or ws2812b Neopixel ring. 
  - Note that *officially* the BTT SKR board supports up to 12 LEDs per neopixel [according to the manual](https://github.com/bigtreetech/BIGTREETECH-SKR-CR6/blob/master/Hardware/BTT%20SKR-CR6-User%20Manual.pdf), but I have 16 pixels on both printers. You may overload the voltage regulator on your board, so be careful and be aware of the risks.
  - I used [this 16-pixel ring](https://www.kiwi-electronics.nl/neopixel-ring-16x-ws2812-5050-rgb-led-met-drivers) and [two of these 8-pixel strips](https://www.kiwi-electronics.nl/neopixel-stick-8x-rgb-leds).
- A 3-wire cable
  - I used [this 15cm JST-SM cable](https://www.kiwi-electronics.nl/3-weg-jst-sm-female-connector-met-kabel) with this [1 meter JST-SM cable](https://www.kiwi-electronics.nl/3-weg-jst-sm-verlengkabel-1m). Note that the motherboard has JST-XH connectors, which is a different connector - I just purchased this cable for the wires.

If you don't have soldering equipment, you need some soldering equipment as well, like:

- A soldering iron
- Soldering flux
- Lead-containing soldering tin

If you don't have crimping tools, you need that as well. I used:

- This [Paron crimping tool from Banggood](https://banggood.app.link/MXPKIXxdnfb)
- This [JST-XH connector set from Amazon](https://www.amazon.nl/gp/product/B082ZLYRRN/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&psc=1)
- This [JOKARI wire strippers](https://www.amazon.nl/gp/product/B002BDNL4Q/ref=ppx_yo_dt_b_asin_title_o02_s00?ie=UTF8&psc=1)

![Crimping tools and wire strippers.](/images/blog/2021-01-19-mounting-the-biqu-h2-to-creality-cr6/00-tools.jpg)
*Just a handful of tools you are going to buy some time during your 3D printing life anyway*

We will be doing firmware changes as well, so [make sure you've set-up your development environment](/blog/2021/01/08/how-to-compile-cr6community-marlin-with-vscode-platformio).

## Mounting

The mounting consists of three major steps: 

1. Solder cabling onto the neopixel
2. Routing the cable
3. Crimp connectors onto the cable.

### Soldering

Soldering the neopixel assembly is the most difficult and tedious process, because the soldering pads 

![Soldering neopixels](/images/blog/2021-04-11-how-to-mount-neopixel-to-creality-cr6/mount-soldering.jpg)
*A helping hand (the thing with the crocodile clips) comes in very handy*

I'm not going to explain soldering here, there are much better sources for that on the *interwebz*. You need to solder to the 5V, *data IN* and GND pads of your neopixel. No

Most important to check after soldering:

1. Is the soldering connection solid?
2. Measure with a multimeter that the 5V, GND and data line is not shorted and is properly connected.

### Routing the cable

The first step is routing the cable. There are a few holes on the CR-6 printer that allow cables to go the motherboard. For my purposes, I found routing easiest through the hole where the flatcable also goes. 

![Routing cabling for Neopixels](/images/blog/2021-04-11-how-to-mount-neopixel-to-creality-cr6/mount-cable-routing.jpg)
*Routing it through the hole, it routers along the power supply cables through the motherboard*

Also take this chance to check if all the wiring is still proper. 

### Crimping the cables

Finally, you need to crimp a JST-XH connector onto the neopixel cable. Take note of the pin-out for your particular motherboard. BigTreeTech [publishes the pin-out of their board online](https://github.com/bigtreetech/BIGTREETECH-SKR-CR6/blob/master/Hardware/BTT%20SKR-CR6-Pin.pdf). As far as I know Creality does not have public pin-outs for their board.

![Pin-out cabling for Neopixels](/images/blog/2021-04-11-how-to-mount-neopixel-to-creality-cr6/pinout.png)
*You need the RGB connector. Note that the 5V line must match with the 5V line of the neopixel, data line with the "data in" port.*

If you have the wiring wrong, your board will most likely survive. It did in my cases: my board simply went into protection and did not boot Marlin. Still, double check your wiring.

![Crimping cabling for Neopixels](/images/blog/2021-04-11-how-to-mount-neopixel-to-creality-cr6/mount-crimped-cable.jpg)
*Crimping is not the most fun to do, but everything is very neat and tidy afterwards. It is rewarding 😉*

## Firmware changes

You also need to make some firmware changes. You can check [the guide I published earlier on how to compile firmware](/blog/2021/01/08/how-to-compile-cr6community-marlin-with-vscode-platformio).

There is only one file you must change: Configuration.h.

Find the section that says:

```C++
// Support for Adafruit NeoPixel LED driver
//#define NEOPIXEL_LED
#if ENABLED(NEOPIXEL_LED)
  #define NEOPIXEL_TYPE   NEO_GRBW // NEO_GRBW / NEO_GRB - four/three channel driver type (defined in Adafruit_NeoPixel.h)
//#define NEOPIXEL_PIN     4       // LED driving pin
  //#define NEOPIXEL2_TYPE NEOPIXEL_TYPE
  //#define NEOPIXEL2_PIN    5
  #define NEOPIXEL_PIXELS 30       // Number of LEDs in the strip. (Longest strip when NEOPIXEL2_SEPARATE is disabled.)
  #define NEOPIXEL_IS_SEQUENTIAL   // Sequential display for temperature change - LED by LED. Disable to change all LEDs at once.
  #define NEOPIXEL_BRIGHTNESS 127  // Initial brightness (0-255)
  //#define NEOPIXEL_STARTUP_TEST  // Cycle through colors at startup

  // Support for second Adafruit NeoPixel LED driver controlled with M150 S1 ...
  //#define NEOPIXEL2_SEPARATE
  #if ENABLED(NEOPIXEL2_SEPARATE)
    #define NEOPIXEL2_PIXELS      15  // Number of LEDs in the second strip
    #define NEOPIXEL2_BRIGHTNESS 127  // Initial brightness (0-255)
    #define NEOPIXEL2_STARTUP_TEST    // Cycle through colors at startup
  #else
    //#define NEOPIXEL2_INSERIES      // Default behavior is NeoPixel 2 in parallel
  #endif

  // Use a single NeoPixel LED for static (background) lighting
  //#define NEOPIXEL_BKGD_LED_INDEX  0               // Index of the LED to use
  //#define NEOPIXEL_BKGD_COLOR { 255, 255, 255, 0 } // R, G, B, W
#endif

```

Follow the following steps:
- Uncomment `#define NEOPIXEL_LED`
- Set `NEOPIXEL_TYPE` to `NEO_GRB`, at least for the two neopixels I linked above.
- Set `NEOPIXEL_PIXELS` to the total number of neopixel LEDs that are connected. 16 in my case.
- Uncomment `NEOPIXEL_STARTUP_TEST`, then Marlin will let the pixels change colors as Marlin starts up.

Compile and flash your firmware. 

## Summary 

That's it! You've now successfully installed neopixels on your printer. 

![Neopixels](/images/blog/2021-04-11-how-to-mount-neopixel-to-creality-cr6/printer2b.jpg)
*Mounted on my Kickstarter CR-6 SE*

![Neopixels](/images/blog/2021-04-11-how-to-mount-neopixel-to-creality-cr6/printer1b.jpg)
*Mounted on my second Creality CR-6 SE*

Once [this feature request](https://github.com/CR6Community/Marlin/issues/231) has been implemented in the CR-6 Community Firmware, Neopixels will also be controllable from the touch screen. When you have a BTT TFT, you are already able to control the neopixels from that screen.

