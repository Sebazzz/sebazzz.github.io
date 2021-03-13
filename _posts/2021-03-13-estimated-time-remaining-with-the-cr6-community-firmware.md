---
layout: post
title:  "Remaining time display on the Creality CR-6 SE"
date:   2021-03-13 21:00:00 +0100
categories: 3d-printing
---

With the upcoming CR-6 Community Firmware release 6 (as of this writing in prerelease) it will be possible for supporting Octoprint plugins or slicers to directly inject the remaining time so the firmware understands it. This short article will show you how you can use it!

## How it looks

<style scoped>
  img + p, img + em {
    clear: both;
    display: block;
  }
</style>

The amount of time remaining can either be calculated by the slicer, or by a host like Octoprint that prints to the printer. It would show up like this, when printing:

![Print remaining when printing](/images/blog/2021-03-13-estimated-time-remaining-with-the-cr6-community-firmware/print-screen.jpg)
*If you don't have any commands that tell the remaining time to the firmware then no time indication would be shown*

The advantages are that you can free up your yellow M117 message for other things, like information about the current layer being printed.

## How to get the firmware to show the remaining time

**So, how do you get the firmware to show this?** There are two options: Through the slicer, or through an Octoprint plugin.

### Slicer settings

When it comes to slicers, this is only possible in **PrusaSlicer** and its derivative **SuperSlicer** as far as I'm aware. Within the printer settings, the "General tab", "Firmware" section, find this option:

![Print remaining when printing](/images/blog/2021-03-13-estimated-time-remaining-with-the-cr6-community-firmware/prusaslicer.png)
*Don't forget to save the changes to your printer profile after you're done*

When you have set this, PrusaSlicer will emit a `M73 P[percentage] R[remaining time in minutes]` in the gcode. The firmware will pick it up and show it on the display.

To improve time estimation accuracy, you must let PrusaSlicer be in control of the accelerations, within the printer settings in the "Machine limits" tab:

![Print remaining when printing](/images/blog/2021-03-13-estimated-time-remaining-with-the-cr6-community-firmware/prusaslicer2.png)
*The amount of time remaining will be more accurate if PrusaSlicer is in full control of the kinematics*

Now you're using the "time remaining" feature, you can use something like this in your "After layer change G-code" in PrusaSlicer to show the current layer:

    M117 printing layer {layer_num+1}/[total_layer_count]


### Octoprint settings

When using Octoprint you can use either of these two plugins:

- [Detailed Progress](https://plugins.octoprint.org/plugins/detailedprogress/) v0.2.8 or higher *or*
- [M73 Progress](https://plugins.octoprint.org/plugins/m73progress/)

For the **Detailed progress** plugin you must wait for [my contribution to be merged and published as version 0.2.8](https://github.com/tpmullan/OctoPrint-DetailedProgress/pull/37) - until then you can download [my fork of it](https://github.com/cr6community/OctoPrint-DetailedProgress) by clicking "Code" then "Download ZIP" and uploading that ZIP into Octoprint. You may need to remove the current installed plugin first, and restart Octoprint afterwards.

[Detailed Progress](/images/blog/2021-03-13-estimated-time-remaining-with-the-cr6-community-firmware/detailed-progress.png)
*The option as shown in the Detailed Progress plugin*

For the **M73 Progress** plugin you must enable "Output time left" in the settings.

To make the time estimates even more accurate, you can also install the [PrintTimeGenius](https://plugins.octoprint.org/plugins/PrintTimeGenius/) plugin.

## Conclusion

I hope this helps anyone, in looking for getting the remaining time on the print screen!

To download the CR-6 community firmware, [go to the home page on Github](https://github.com/CR6Community/Marlin/#readme). If you like to support the developers you can check the [credits section of the README](https://github.com/CR6Community/Marlin/#credits).

