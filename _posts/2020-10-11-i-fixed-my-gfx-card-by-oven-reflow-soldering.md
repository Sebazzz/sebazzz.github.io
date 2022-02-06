---
layout: post
title:  "I fixed my graphics card by using oven reflow soldering"
date:   2020-10-11 16:31:00 +0200
categories: gaming
image: /images/blog/2020-10-11-i-fixed-my-gfx-card-by-oven-reflow-soldering/4.jpg
---

On this Sunday I just want to share the story of my broken graphics card and how I fixed it for now (because you never know how long it will last). I already have a Nvidia GTX3080 on order so it just has to work long enough until I receive my order.

## No POST
This morning I had my computer on, looked up something on the internet and closed it. No problems or instability at all.

Two hours later I booted my system and my system would not boot. I didn't get a display. I recently got a new monitor (an ultrawide Samsung) so maybe it was there? It is also strange, after all I had worked with my system in the morning without any problems! The video card was now a few years old - but never had any problems with it.

Anyway - with no video cable in my system still wouldn't boot.

My system doesn't have a piezo speaker, so I transferred the piezo speaker from an old cabinet. Softly I heard four beeps after the initial "boot beep", one long and three short: Beeeeep, beep beep beep. The [ASUS buzzer reference](https://www.asus.com/support/faq/1029959/) indicates:

> **4. "One long and three short beeps" from speaker**
> 
> An anomaly is detected in the graphic card. If the graphic card needs an extra power supply, please ensure the power supply can provide enough wattage.

Then I tried:

1. Start the motherboard without a video card. Although I don't have an APU (Ryzen 7 3700X) I wanted to test what the behavior is without graphics card. That was different.

2. Using a different PCIe slot on my motherboard.
![Different PCIe slot on motherboard](/images/blog/2020-10-11-i-fixed-my-gfx-card-by-oven-reflow-soldering/1.jpg)
*This photo is from a quick try when I thought that another PCIe slot might be the solution. In this picture the cooler is already removed.*

3. Measure voltage on the power supply
![Measure the voltage](/images/blog/2020-10-11-i-fixed-my-gfx-card-by-oven-reflow-soldering/2.jpg)
*12.1V on the PCIe rails - although this card is powered from the motherboard (and therefore other rails) I wanted to rule out severe issues with my power supply.*

I once read about problems with the soldering on the Geforce 1080 cards and also some other Nvidia cards. That was then "solved" by briefly baking the card in the oven. In the context of *"It is already broken, I can't make it worse"* I decided to try a reflow as well.

What is funny is that you see a lot of different ways (GPU down, GPU up) and temperatures on the internet. In the end I did what "felt good".

I started with taking the cooler off the card. It is recommended to remove as many parts as possible from the card - especially if it is plastic.
![Not a lot of cooling paste!](/images/blog/2020-10-11-i-fixed-my-gfx-card-by-oven-reflow-soldering/3.jpg)
*What I noticed when I took the cooler off is that little thermal paste was used. Maybe this card has always run way too hot?*

I also removed the existing thermal paste with some kitchen paper. In the meantime, I preheated the oven to 190 degrees Celsius.

The microwave has a raised surface with a grid, so I used that to place the video card on it. I covered it with aluminum foil with the card on the shiny side. I put aluminum foil on it to protect the plastic parts of the DVI and HDMI port.

When the oven was hot, I confirmed the temperature with an IR thermometer (which you have as a cooking nerd of course) and put the card in the oven.

![Baking my graphics card](/images/blog/2020-10-11-i-fixed-my-gfx-card-by-oven-reflow-soldering/4.jpg)
*Yummy! I want another one just like that! 😋*

Then I set the oven to 200 degrees (no forced air) and checked every now and then what the heat is because consumer ovens are not known to be precise. My oven deviated 10 degrees, which was actually 210 degrees. I think I had the card in the oven for a maximum of five or six minutes.

Then I turned off the oven and let it cool down. When the card was about 60 degrees and I no longer burned my hands, I took the card out of the oven. Quickly tested without a cooler and that gave hope!

![Video card error in UEFI!](/images/blog/2020-10-11-i-fixed-my-gfx-card-by-oven-reflow-soldering/5.jpg)
*Motherboard is probably confused from many booting and trying.*

With these results in my pocket, I brushed the dust off my Artic Silver 5 thermal paste and applied it in the right amount after first cleaning both GPU and cooler with alcohol.

After re-inserting the card...

![Success - Windows boots again!](/images/blog/2020-10-11-i-fixed-my-gfx-card-by-oven-reflow-soldering/6.jpg)
*Success! 🎉 🤩*

Of course, this entire guide is to be taken as something that worked for *me* **once**. Don't do this on card where you have any hope of getting it repaired by the seller, and it is also entirely on your own risk!





