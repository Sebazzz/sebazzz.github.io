---
layout: post
title:  "Adjustable retractions during printing with Marlin Firmware Retract"
date:   2021-05-06 21:00:00 +0200
categories: 3d-printing]
image: /images/blog/2020-11-12-when-in-doubt-change-your-filament/retraction.jpg
---

The ability to adjust retractions during a print is invaluable when tuning in new filaments. You can also use it save a print that experiences too much stringing. Marlin supports adjusting retractions while a print is running - when you [have "firmware retraction" enabled](https://marlinfw.org/docs/features/fwretract.html). In this article I show you how to use it!

<style scoped>
  img + p, img + em {
    clear: both;
    display: block;
  }
</style>

![Firmware retraction guide](/images/blog/2021-05-06-adjustable-retractions-during-printing-with-marlin-firmware-retractions/cover.jpg)
*Tuning retractions while a print is running with [Community Firmware release 6](/blog/2021/03/27/creality-cr6-community-firmware-release-6-is-here)*

A retraction during 3D printing is the act of pulling back filament in order to prevent oozing of filament out of the nozzle. The retraction reduces pressure in the nozzle. Generally a retraction is done before a travel move. If retraction is not sufficient (assuming the filament is decent), then you "bridge" a small amount of filament across the travel move. This is called stringing. The worst thing is that stringing can cause more stringing, because when the nozzle hits stringing on the next layer more filament is pulled out. This causes the classic "lightning" arcs you see in a stringing test.

Different filaments have different retraction behaviors. You may find you need to adjust multiple parameters to prevent oozing: 

- Temperature
- Amount of filament to retract
- The speed at which to retract
- An optional Z-hop

![Retraction tests side-by-side](/images/blog/2020-11-12-when-in-doubt-change-your-filament/retraction.jpg)
*Retraction tuning [can drive you crazy](/blog/2020/11/12/when-in-doubt-change-your-filament) and needs a lot of manual slicer work if you want to try multiple parameters.*

![Stringing in a print](/images/blog/quick-filament-reviews/basicfil-pla-blue/stringy-engine.jpg)
*Retractions can sometimes be burned away - but they will always leave some marks on a print*

## Enter firmware retraction

Firmware retraction allows you to control any retraction parameters during a print. The slicer enters [gcode G10](https://marlinfw.org/docs/gcode/G010.html) any time a retraction is needed and [gcode G11](https://marlinfw.org/docs/gcode/G011.html) at the end of the travel move. Marlin then does a retraction and optional Z-hop.

First you need to configure your slicer to emit firmware retraction commands. I'm using PrusaSlicer here:

![Firmware Retract in PrusaSlicer](/images/blog/2021-05-06-adjustable-retractions-during-printing-with-marlin-firmware-retractions/prusa-slicer.png)
*In PrusaSlicer you can find the firmware retraction setting in the "General -> Advanced" section.*

I also recommend you add this to your start gcode, so the slicer retraction settings are set as default for the firmware retraction feature:

```gcode
; Setup firmware retraction settings
M207 F{ retract_speed[0] * 60} S[retract_length_0] Z[retract_lift_0]
M208 F{ deretract_speed[0] * 60} S[retract_restart_extra_0]
```

Then, slice your [typical retraction test](https://www.thingiverse.com/thing:2080224) and start the print.

### Printing

On the touchscreen you can tap the "retraction" button in the bottom or navigate through "Tune -> Advanced tuning -> Retractions".

![Firmware retraction guide](/images/blog/2021-05-06-adjustable-retractions-during-printing-with-marlin-firmware-retractions/tft1.jpg)
*Did you know you can actually tap anything in the footer to either navigate to the relevant screen or change the value?*

![Firmware retraction guide](/images/blog/2021-05-06-adjustable-retractions-during-printing-with-marlin-firmware-retractions/tft2.jpg)
*On the firmware retraction screen you can change the most important parameters. Not shown at the bottom: temperature.*

When tuning retractions, try playing with these parameters:

- Temperature
- Amount of filament to retract
- The speed at which to retract
- An optional Z-hop

Note that it may take a few moments for any changes to take effect.

![Firmware retraction guide](/images/blog/2021-05-06-adjustable-retractions-during-printing-with-marlin-firmware-retractions/result.jpg)
*The result of playing with multiple retraction settings during the same print*

### Overriding slicer retractions

There is also a way for Marlin to override existing retractions. You can use this in the case you don't want to or cannot use firmware retractions. Marlin calls this feature "auto retract", I called this in the Community Firmware "override slicer retractions".

The basic principle on which it operates is that any retractions (which is expressed as a negative movement of the extruder) within a certain amount are overridden. It can't undo Z-hops you enter in the slicer, but it can completely override the retractions. Simply tap the "override" button at it will apply different retraction settings. Since it needs to override extruder movements, it might work a bit less efficient than true firmware retractions. 

It might be enough to save a failing print though. 

## Conclusion

In this article I've shown how to use firmware retraction. It is one of the most undersold features of Marlin. It allows completely tuning retraction within a single print.

Use it to your advantage and happy printing!
