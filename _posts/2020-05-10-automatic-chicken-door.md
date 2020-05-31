---
title: "Building an automatic chicken coop door controller"
subtitle: "Automating chicken ownership"
layout: post
bigimg: /img/chickens.jpg
overlay: 220,150,130,0.8
tags: [automation, arduino, cpp, chickens]
---

My wife and I got three backyard chickens a few months ago. There was a lot of setup work initially, but we eventually settled into a routine which didn't require much work on a daily basis. One pain point was waking up early enough to let the chickens out of their coop at a time they felt was reasonable, i.e., sunrise.

This is the story of how I built an automtic chicken coop door opener that opens at sunrise and closes at sunset. This is the story of how I spent a lot of time automating this small part of chicken ownership. And then fixing, improving, and iterating on the door over and over again.

## Overview
1. [Order materials](#order)
1. [Solder board and button](#solder)
1. [Wire the circuits](#wire)
1. [Write the program](#program)
1. [Mount servo](#mount)

## Order materials {#order}
For this project I bought:
* 1 [Arduino Nano Every](https://amzn.to/2XC3mNq)
* 1 [solderless breadboard](https://amzn.to/2B5Eruc) with 400 pins
* 1 [DS3231 RTC](https://amzn.to/2B2VxJ3)(real time clock)
* 1 [CR2032 3 Volt Lithium Coin Cell Battery](https://amzn.to/3d7Gdcb)
* 1 [20KG digital servo](https://amzn.to/2yE2DTC) with metal gears and 270° rotation
* 1 [25T long servo horn](https://amzn.to/2THiB6R)
* 1 [momentary push button](https://amzn.to/2yzGW74)
* 1 [soldering kit](https://amzn.to/3gpRfLX)
* 1 [set of breadboard jumper wires](https://amzn.to/36wHV4B)
* 1 [19,200mAh rechargable battery pack](https://amzn.to/3dhIMIW) with no automatic low-voltage shutoff

Note that the quantities above are the quantities required for this project but it was obviously more economical to order some things in packs. The total cost for this project came to roughly ${TODO:total_cost}, though some of that is offset by the leftover quantities from the order above.

I had also previously purchased the [Arduino starter kit](https://amzn.to/3d98wau) to prototype the controller but this wasn't strictly necesesary. Lastly, I used a few tools I already owned, including a [SawStop contractor table saw](https://amzn.to/3d7cGQ7), [drill and impact driver](https://amzn.to/3el98da), wood star drive fasteners, a steel servo control rod, and some scrap wood.

## Solder board and button {#solder}
I got one of the smallest Arduino boards, the Arduino Nano Every, for this project because I didn't need much memory or CPU for this project. I got my first soldering kit and soldered:
1. the header pins to the Nano board
1. wires to the momentary push button

I ended up having to re-solder each one deep into the projecte for various reasons. The first time I soldered the Nano board, I made the mistake of not soldering the header pins at a 90° angle:
![Nano board bad headers](/img/nano_not_90.jpg)

I fixed this by applying horizontal pressure to each pin while re-heating with the soldering iron:
![Nano board good headers](/img/nano_flush.jpg)

The first time I soldered the mometary push button I did so with wires that came with the soldering kit but the individual strands didn't stick together making inserting into the breadboard extremely frustrating.
![Momentary push button before](/img/momentary_push_button_before.jpg)

I removed these wires and used breadboard jumper wires instead. Pro tip: use different colored wires, especially if you won't have line of site to trace your wires to their destinations...
![Momentary push button after](/img/momentary_push_button_after.jpg)

## Wire the circuits {#wire}
Wiring the circuits was the most straighforward part, though I certainly didn't get it right the first time. Or the second time or the third time. 
![Wired circuits](/img/circuits.jpg)

While I had wired my breadboard for the small servo that comes in the Arduino Uno starter kit, I later replaced this servo with a more powerful servo with metal gears. The power line in the new servo was in the place where the control line was in the old servo. While I switched the corresponding 5v and pulse wires coming from the board, I forgot to move the anode in my decoupling capacitor to the new power circuit. It took me quite a while to diagnose this issue since I couldn't rule out other issues like a bad servo.

## Write the program {#progream}
Writing the program was the simplest part of this project, in part because I have much more software development experience than mechanical and electrical engineering. The trickiest part for me was remembering to add semi-colons after each line... My source code for this project can be found in [this](https://github.com/rtlee9/auto_chicken_coop_door) repo.

One thing I learned is that debugging software is compounded when coupled with hardware. I spent quite a bit of time trying to figure out why my program would hang at the [line](https://github.com/rtlee9/auto_chicken_coop_door/blob/master/autoChickenCoop.ino#L66) where I read the current time upon initialization. I eventually figured out that adding a [delay](https://github.com/rtlee9/auto_chicken_coop_door/blob/master/autoChickenCoop.ino#L63) before this first RTC read solved this issue most of the time (but not all of the time). My current hypthesis is that the RTC boot time is quite variable and if the first read occurs before the RTC is ready then the program will hang.

## Mount servo and push button {#mount}
Another new challenge for me was figuring out how to mechanically move the door through servo rotational force. Initially, I set my 9g servo in a hard maple mounting block that I cut on my table saw and used a paper clip as a control rod.
![Small maple servo block](/img/small_servo_block.jpg)

Not surprisingly, there were numerous issues with this approach, though each issue was solved fairly easily:

| Issue | Solution |
|-|-|
| the plastic servo gears broke after I pulled the door open to forcefully | buy a larger servo (20g) with metal gears |
| the paper clip snapped at the point where I had attached it to the door | use a steel control rod made for being a control rod |
| I split the mounting block with my fasteners since the servo mounting holes were so close to the edge of the dado I cut for the wire outlet | use plywood since multiple plies will help prevent splitting; also pre-drill before fastening |

Milling the new servo mounting block on my table saw:
![Servo mounting block milling](/img/servo_mounting_block.gif)

The result came out like this:
![Large plywood servo block](/img/big_servo_block.jpg)

Finally, I connected the servo control arm to the servo horn and to the chicken wire on the coop door. Et Voilà:
![Demo open close door button](/img/coop_door_open_close_demp.gif)
