---
layout: post
title:  "Audible notification at the end of your print with the Creality CR-6 SE"
date:   2021-03-13 21:00:00 +0100
categories: 3d-printing
---

A quick little tip today: If you don't use Octoprint (or even if you do) you may want to have an audible notification when your 3D print has ended. I'Il show you how!

## Beep!

There is a simple gcode that you can use in your end-gcode in your slicer: [M300](https://marlinfw.org/docs/gcode/M300.html).

Every M300 command will output a beep. On the CR-6 with the Community Firmware you can't control the frequency, but can control the duration.

For instance, use this in at the end of your end gcode.

```gcode
M117 Notifying
M300 P100
G4 P500
M300 P250
```

This will have two beeps at the end of the print - one short and one long.

Notice I used gcode [G4](https://marlinfw.org/docs/gcode/G004.html), which tells Marlin to wait for a bit.

These gcodes works as follows:

    G4 P[time in milliseconds]
    M300 P[time in milliseconds]

So, if you want to beep for a half second, then wait a full second, and do two short beeps, try:

```gcode
M300 P500
G4 P1000
M300 P100
G4 P500
M300 P100
```

I hope it helps!