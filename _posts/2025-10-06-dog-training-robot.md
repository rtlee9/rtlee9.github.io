---
title: Raspberry Pi dog deterrent robot
subtitle: Training my dog to stay out of the kitchen food with a raspberry pi and a flyswatter
layout: post
gradient: canvas
tags: [robotics, raspberry pi, python]
---

My dog, Honey, has a long history of stealing food from our kitchen when we aren't looking. She is particularly drawn to our skillet, often taking it upon herself to liberate the skillet of any meats and/or grease it may contain. This is both annoying and also a safety concern if the skillet was hot.

We needed to deter her from entering the kitchen, and we needed to do so consistently so that she could learn to avoid the kitchen. This deterent would need to do two things:
1. figure out if Honey is in the kitchen with high recall[^1]
1. once detected, actuate something Honey doesn't want to be around

My solution comprises a Raspberry Pi, a Raspberry Pi AI Camera, a servo, and a fly swatter. The Pi runs a python [script](https://github.com/rtlee9/dog_trainer/blob/master/dog_detector.py) that regularly checks whether the array of objects detected from the camera contains a dog. If a dog is identified, then it saves the image and rotates the servo, which is connected to a fly swatter, 180 degrees. Honey doesn't ike fly swatters (since we swing them fast and they make loud sounds) so this actuation sends Honey skulking out of the kitchen.

This system has been remarkably effective. When we first deployed it last year, Honey triggered it several times in the first week and quickly learned to avoid the kitchen. Our kitchen is now safe from Honey, and Honey is now safe from our skillet.

![pi dog trainer](/img/honey_trainer.jpg )
---

[^1]: Consistency is key for canine learning. Precision is less important to us. We are ok if there are some false positives, though too many might get annoying.