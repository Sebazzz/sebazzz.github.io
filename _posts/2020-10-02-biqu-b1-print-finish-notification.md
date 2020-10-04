---
layout: post
title:  "BIQU B1: Print finish notification"
date:   2020-10-02 20:31:00 +0200
categories: 3d-printing
---

A quick blog post because I wanted to have a audible notification when any prints on my BIQU B1 finished.

## Start/end gcode

In you slicer you can add start and end gcode.

To have a nice short series of beeps at the end of the print use this:

```
M300 S1600 P50
M300 S1800 P50
M300 S2000 P50
```

View the reference page for gcode [M300](https://marlinfw.org/docs/gcode/M300.html) to further tune this to your wishes.