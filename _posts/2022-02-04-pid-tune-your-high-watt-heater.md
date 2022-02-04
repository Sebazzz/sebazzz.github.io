---
layout: post
title:  '"PID Autotune failed! Temperature too High!" How to PID tune a high watt heater'
date:   2022-02-04 21:00:00 +0100
categories: 3d-printing
image: /images/blog/2022-02-04-pid-tune-your-high-watt-heater/cover.png
---

I've been busy retrofitting a BIQU B1 printer with the new [BIQU H2 High Temperature extruder](/blog/2022/01/13/biqu-h2-high-temperature-first-look). However I ran into some trouble tuning in the 70 watt heater. Every time I attempted to PID auto tune it overshot way past the target temperature and the PID tuning process was aborted. So how to we fix this? Let's see!

<style scoped>
  img + p, img + em {
    clear: both;
    display: block;
  }
</style>

## The Situation

I have rewired my BIQU B1 to handle this high power heater, and allow the BIQU H2 to be fitted in a fixed way. For this I've removed the entire USB-C cable and breakout board and wired everything directly to the mainboard. 

![BIQU H2 mounted to the BIQU B1](/images/blog/2022-02-04-pid-tune-your-high-watt-heater/BIQU-h2-mounted.jpg)
*The BIQU H2 mounted to the BIQU B1 with a simple fixed mounting plate*

![BIQU B1 rewired](/images/blog/2022-02-04-pid-tune-your-high-watt-heater/mainboard-wiring.jpg)
*I've wired all wires directly to the mainboard, and used both heater MOSFETs in parallel to share the load (Marlin option `HEATERS_PARALLEL`)*

At the top right in the picture you find the MAX31865 on a stepstick board, which connects to the PT100 high temperature thermistor. 

## PID Autotune failed! Temperature too High!

When tuning in the temperature, I ran into the issue that I could never complete the PID cycle. 

![PID tuning a high temperature hot-end](/images/blog/2022-02-04-pid-tune-your-high-watt-heater/PID-1.png)
*You can start a PID tune with the command `M303 S235 U1 C8` where 235 is the target temperature and 8 the number of cycles. We also want to use the results, so we use "U1".*

Starting the PID tune was easy enough.

![PID tuning a high temperature hot-end](/images/blog/2022-02-04-pid-tune-your-high-watt-heater/PID-2.png)
*Marlin says: "PID Autotune failed! Temperature too High!" and aborts the auto-tune procedure*

But the PID tuning aborted after overshooting by more than 30 degrees Celcius. This is a safety measure, but why does this happen? For this we need to dive a little deeper in Marlin's heating process.

## How heating in Marlin works

A heater is controlled by one or more MOSFETs, which are little chips which turn the heater on or off. There is no in-between state: the heater is either on or off. 

![MOSFETs on a BTT SKR CR-6](/images/blog/2022-02-04-pid-tune-your-high-watt-heater/mosfets.jpg)
*MOSFETs for bed heating and hot-end heating on a [BTT SKR CR-6 board](https://damsteen.nl/blog/2020/11/25/how-to-btt-skr-cr6-installation)*

That poses a problem for accurate temperature control: How often do you enable power the heater, and for how longer? PID controlled heating solves this problem: The three values that define the PID configuration determine when and for how long to turn on the heater to reach or maintain a specific temperature. 

However, the PID is only valid and efficient for a certain temperature range: A PID tuned for a temperature of 300C will not necessarily be valid for a temperature of 50C. For this reason Marlin employs PID only within a certain _range_ of the target temperature: _the PID functional range_. For instance, with a `PID_FUNCTIONAL_RANGE` of 30 degrees, when you heat your hot-end to 230 degrees, PID will only be used when the hot-end temperature is in the range of 260-200C. (You might expect 215C-245C but that is not the case)

### Bang bang

So what is used _outside_ the PIDs functional range? That's what we call bang-bang heating. This is follows a very simple algorithm: turn the heater on and watch the temperature. When the temperature rises above a certain limit, turn the heater off and wait for temperature to drop under the limit, turn the heater back on.

The bang-bang value can be tuned however: you can tell with `BANG_MAX` that instead of turning the heater for 100% (255) on, it should turn the heater only 50% of the time on (128). And this is one part of the solution.

### Marlin PID parameters

There are several parameters in Marlins Configuration.h you can use:

```cplusplus
#define BANG_MAX 255
#define PID_MAX BANG_MAX
#define PID_FUNCTIONAL_RANGE 10
```

As configured above this means:

- `BANG_MAX`: Turn on the heater at a 100% duty cycle outside the PID's functional range. The value range is 0-255, so 255 is 100%.
- `PID_MAX`: When in the PID functional range, allow the hot-end be *at maximum* on at this duty cycle (range 0-255 means 0-100%). It is here set to the same value as BANG_MAX, so 100%.
- `PID_FUNCTIONAL_RANGE`: The temperature range in which PID control is used.

## The solution & explanation

When the heater is on, temperature does not immediately transfer. It takes a moment for the thermistor to get to the temperature as the heating occurs. We have the heater configured to run at 100% power - the full 70W. Yet, Marlin will only start using PID at 10C before the target temperature. That doesn't leave a lot of margin - however this is only part of the issue. When PID tuning, Marlin will first put 100% power on the heater (according to `PID_MAX`). 

There are two knobs we can turn: 

- `PID_MAX`: The amount of power we send to heater inside the PIDs functional range
- `PID_FUNCTIONAL_RANGE`: Increase the functional range of PID

![Marlin PID temperature graph with overshoot](/images/blog/2022-02-04-pid-tune-your-high-watt-heater/Graph.png)
*Trying to maintain temperature: (1) 40C overshoot attempting to heat to 100C, (2) failed PID tune for 235C, (3) I had increased the PID functional and the hot-end was already hot (within functional range), so second PID did go through*

My first attempt was increasing `PID_FUNCTIONAL_RANGE` from 10 to 60. It appeared it didn't work, but then it did, but it would never be stable when heating up the hot-end from a cold state.

So, I decreased `PID_MAX` from 255 to 100 - this did the trick. Getting *reaching* a temperature is way costs much more power than *maintaining* a temperature - so it is fine if we don't have the full 70W available. With this I was able to do the PID tune.

![PID tuning in progress](/images/blog/2022-02-04-pid-tune-your-high-watt-heater/pid-graph.gif)
*Don't worry - during PID tuning the graph will shoot around the target temperature while the firmware learns how to control the heater*

![PID tuning complete](/images/blog/2022-02-04-pid-tune-your-high-watt-heater/PID-Complete.png)
*If you've called M303 with the U1 gcode you can immediately save the new PID results with `M500`*

As you can see, after the PID tune I was able to maintain temperature perfectly.

![PID tuning complete](/images/blog/2022-02-04-pid-tune-your-high-watt-heater/PID-complete-graph.png)
*And an completely stable temperature after the PID tune!*

## Conclusion

PID auto-tuning high power heaters in Marlin requires tuning some parameters you might otherwise not touch. However, by tuning the `PID_MAX` and `PID_FUNCTIONAL_RANGE` you can get PID auto-tuning to work stable, and tune your hot-end so it maintains a stable temperature. It is just a matter of understanding the parameters you have available to you.

![PID tuning complete](/images/blog/2022-02-04-pid-tune-your-high-watt-heater/hot-hot-hot.png)
*Hot hot hot!*

Happy printing!