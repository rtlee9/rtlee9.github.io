---
title: CNC Flattening G-code generator
subtitle: Flattening wood slabs the easy way
layout: post
gradient: canvas
tags: [robotics, python, cnc]
---

As an avid woodworker, I flatten a lot of wood slabs on my CNC machine. Flattening a slab is a tedious, repetive task. You basically run a router (or CNC spindle) forwards, sideways, backwards, sideways, forwards, etc. on the same plane repeatedly. Then drop the bit lower (so as not to remove too much wood at once and over-power the router or spindle). I made a django web app to generate G-code for flattening slabs on my CNC more automatically. You can try it at [flattener.ryanlee.site](https://flattener.ryanlee.site). The code for this project is [open source](https://github.com/rtlee9/flattening).

![flattener UI](/img/flattener_screenshot.png)
