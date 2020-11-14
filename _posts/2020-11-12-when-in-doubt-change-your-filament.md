---
layout: post
title:  "Stringing, blobs and underextrusion: When in doubt, change your filament"
date:   2020-11-12 20:00:00 +0100
categories: 3d-printing
---

After my [work on the Creality CR-6 community firmware](https://github.com/CR6Community) and [BIQU B1 review](/blog/2020/10/18/biqu-b1-review) I got contacted by the 3D printer manufacturer [Anet 3D](https://www.anet3d.com/) to test and review their [Anet ET4 Pro 3D printer](https://shop.anet3d.com/products/et4-pro). I received the printer and two rolls of PLA filament. I had quite some trouble getting good prints, and it turns out it was all due to the filament! Read on!

## From okay to nay

I'd like to immediately dive deep with whatever filament and printer I have. No temperature towers, no retraction tests, just a simple calibration cube to test to show any  problems, and go ahead.

At first printing went "okay". I printed the Cute Octopus shown below. 

![Octopus printed with bad filament](/images/blog/2020-11-12-when-in-doubt-change-your-filament-octo.jpg)

There are some blobs, and some slight stringing. But, given that I did not know this printer, and I assumed that the filament that came with it is of good quality, I writed it off as a printer issue.

![Train](/images/blog/2020-11-12-when-in-doubt-change-your-filament-train.jpg)

Next, I printed a base for a train turntable for my daughter. This also shows a lot of blobbing. 

## Doubting the printer

Attempting to fix the issue, I cleaned out the hot-end multiple times, I did a hot-end fix by lining the hot-end with a separate Capricorn PTFE tube. Nothing helped, in fact, using Capricorn made it even worse. 

With more test prints going wrong, I did a retraction test. 

![Retraction test](/images/blog/2020-11-12-when-in-doubt-change-your-filament-retraction.jpg)
*Retraction test ranging from 2mm to 8.5mm with speeds of 25mm/s to 40mm/s*

The results were to say the least... disappointing. A lot of stringing, regardless of settings, unavoidable stringing. Also a lot of underextrusion, which caused the pillars of the retraction tests to be very weak.

To be sure moisture was not the issue, I dryed the filament in my SUNLU Filadryer for over 24 hours. I made some additional prints, but still no luck.

![Collage](/images/blog/2020-11-12-when-in-doubt-change-your-filament-collage.jpg)
*The prints show underextrusion, overextrusion, blobbing, rough surface and stringing.*

## A change of filament

Because I did so many attempts to fix the issue, I thought this was purely down to the printer. I didn't want to "waste" any of my good filament on the printer. Because of this, I never thought the filament could be the issue.

Based on a suggestion a friend did to me, I finally decided to change the filament to the Creality filament I know prints well. The calibration cube gave hope.

![Calibration Cube comparison of bad vs good filament](/images/blog/2020-11-12-when-in-doubt-change-your-filament-cube-comparison.jpg)
*The Creality filament cube is on the right side in this picture*

Looks a lot better, so I printed a benchy. I did not do any retraction or other filament tuning.

![Calibration Cube comparison of bad vs good filament](/images/blog/2020-11-12-when-in-doubt-change-your-filament-benchy-compare.jpg)

That difference is like night and day! The benchy came out pretty much perfect. All the lines are very smooth.

## The cause

What exactly the cause of these issues are clear to me:

- The Creality filament has a width of 0.73-0.75
- The Anet filament has a width of 0.79-0.83 - so this might have caused jams
- I think that the Anet filament might have been stored above the glass transition temperature, which made it very brittle

I hate to waste filament, so I'm still researching whether this roll of filament is salvagable. Perhaps I will use it for very simple functional parts, or as a roll to waste for prototyping my designs.

## Conclusion

Printer issues? First check the filament, try two or three types of filament. 