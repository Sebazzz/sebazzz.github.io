---
layout: post
title:  "Creality CR-6 Community Firmware: Start a print without drooping filament on the build plate while homing"
date:   2021-02-11 22:00:00 +0100
categories: 3d-printing
---

The auto-bed leveling feature of the Creality CR-6 SE uses a strain gauge connected to the hot-end for leveling. This is also used for homing the hotbed - in combination with the optical Z-endstop the nozzle strain gauge status is probed to determine the zero position for the Z axis. [I wrote earlier about a recommended](/blog/2020/10/25/creality-cr6-start-print-without-drooping) start gcode that resolves this issue. Changes in [the CR-6 Community Firmware](https://github.com/CR6Community/Marlin) 5 beta and higher make some parts of the gcode unnecessary.

![Little droop](/images/blog/2020-10-25-creality-cr6-start-print-without-drooping-1.jpg)
*This is just a little droop of filament, but depending on the filament and temperature it can be a good bit more*

![Little droop](/images/blog/2020-10-25-creality-cr6-start-print-without-drooping-2.jpg)
*Drooping can cause first layer artifacts*

The recommended gcode for the CR-6 Community Firmware is shown below. The most important changes is that the purge line is now at the side of the bed and preheating the nozzle before homing already happens in firmware. So - what we only need to do is home, then heat up, and then draw a purge line. Any filament that droops at the side won't stick to the bed.

The start gcode for Cura, PrusaSlicer and Simplify3D contain placeholders which the slicers will automatically replace.

## Cura

Use the gcode below for Cura and replace your existing "start gcode" with this.

```
; Preamble
M201 X500.00 Y500.00 Z100.00 E5000.00 ;Setup machine max acceleration
M203 X500.00 Y500.00 Z10.00 E50.00 ;Setup machine max feedrate
M204 P500.00 R1000.00 T500.00 ;Setup Print/Retract/Travel acceleration
M205 X8.00 Y8.00 Z0.40 E5.00 ;Setup Jerk
M220 S100 ;Reset Feedrate
M221 S100 ;Reset Flowrate

; - Home - this is used with the strain gauge as a zero position for the Z-offset
G28

; Remove the ";" before the next line if you want to level before each print (not recommended because it is not necessary)
;G29

; Now we know the positions we can move out of the way and happily droop at the side of the bed
M104 S{material_print_temperature_layer_0}
M140 S{material_bed_temperature_layer_0}

G0 Z25
G0 X0 Y0

; Now wait for the temperatures to reach
M190 R{material_bed_temperature_layer_0}
M109 S{material_print_temperature_layer_0}

; And we can now draw our purge line
G92 E0 ;Reset Extruder
G1 Z2.0 F3000 ;Move Z Axis up
G1 X0 Y20 Z0.28 F5000.0 ;Move to start position
G1 X0 Y200.0 Z0.28 F1500.0 E15 ;Draw the first line
G1 X0.3 Y200.0 Z0.28 F5000.0 ;Move to side a little
G1 X0.3 Y20 Z0.28 F1500.0 E30 ;Draw the second line
G92 E0 ;Reset Extruder
G1 Z2.0 F3000 ;Move Z Axis up
```

## PrusaSlicer

Use the gcode below for PrusaSlicer and replace your existing "start gcode" with this.

```
; Preamble
M201 X500.00 Y500.00 Z100.00 E5000.00 ;Setup machine max acceleration
M203 X500.00 Y500.00 Z10.00 E50.00 ;Setup machine max feedrate
M204 P500.00 R1000.00 T500.00 ;Setup Print/Retract/Travel acceleration
M205 X8.00 Y8.00 Z0.40 E5.00 ;Setup Jerk
M220 S100 ;Reset Feedrate
M221 S100 ;Reset Flowrate

; - Home - this is used with the strain gauge as a zero position for the Z-offset
G28

; Remove the ";" before the next line if you want to level before each print (not recommended because it is not necessary)
;G29

; Now we know the positions we can move out of the way and happily droop at the side of the bed
M104 S[first_layer_temperature]
M140 S[first_layer_bed_temperature]

G0 Z25
G0 X0 Y0

; Now wait for the temperatures to reach
M190 R[first_layer_bed_temperature]
M109 S[first_layer_temperature]

; And we can now draw our purge line
G92 E0 ;Reset Extruder
G1 Z2.0 F3000 ;Move Z Axis up
G1 X0 Y20 Z0.28 F5000.0 ;Move to start position
G1 X0 Y200.0 Z0.28 F1500.0 E15 ;Draw the first line
G1 X0.3 Y200.0 Z0.28 F5000.0 ;Move to side a little
G1 X0.3 Y20 Z0.28 F1500.0 E30 ;Draw the second line
G92 E0 ;Reset Extruder
G1 Z2.0 F3000 ;Move Z Axis up
```

You can tweak this further if you wish - there are [additional placeholders for the start gcode available](http://projects.ttlexceeded.com/3dprinting_prusaslicer_gcode.html#configuration-placeholders)

## Simplify3D

Use the gcode below for Simplify3D and replace your existing "start gcode" with this.

```
; Preamble
M201 X500.00 Y500.00 Z100.00 E5000.00 ;Setup machine max acceleration
M203 X500.00 Y500.00 Z10.00 E50.00 ;Setup machine max feedrate
M204 P500.00 R1000.00 T500.00 ;Setup Print/Retract/Travel acceleration
M205 X8.00 Y8.00 Z0.40 E5.00 ;Setup Jerk
M220 S100 ;Reset Feedrate
M221 S100 ;Reset Flowrate

; - Home - this is used with the strain gauge as a zero position for the Z-offset
G28

; Remove the ";" before the next line if you want to level before each print (not recommended because it is not necessary)
;G29

; Now we know the positions we can move out of the way and happily droop at the side of the bed
M104 S[extruder0_temperature]
M140 S[bed0_temperature]

G0 Z25
G0 X0 Y0

; Now wait for the temperatures to reach
M190 R[bed0_temperature]
M109 S[extruder0_temperature]

; And we can now draw our purge line
G92 E0 ;Reset Extruder
G1 Z2.0 F3000 ;Move Z Axis up
G1 X0 Y20 Z0.28 F5000.0 ;Move to start position
G1 X0 Y200.0 Z0.28 F1500.0 E15 ;Draw the first line
G1 X0.3 Y200.0 Z0.28 F5000.0 ;Move to side a little
G1 X0.3 Y20 Z0.28 F1500.0 E30 ;Draw the second line
G92 E0 ;Reset Extruder
G1 Z2.0 F3000 ;Move Z Axis up
```

## Compatibility with CR-6 firmware

Note that the above gcode assumes the [CR-6 community firmware 5 beta or higher](https://github.com/CR6Community/) I'm developing is installed.

If you don't use the community firmware, then [refer to the start gcode I posted earlier](/blog/2020/10/25/creality-cr6-start-print-without-drooping).

