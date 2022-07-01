---
title: "Building a DIY water tank level sensor"
subtitle: "4-20mA sensor, ESP32 circuit, IOT streaming, and monitoring dashboard"
layout: post
bigimg: /img/water.jpg
overlay: 20,100,200,0.6
tags: [automation, arduino, cpp, well, water, aws]
---

I recently moved into a rural home running on well water. The well pumps groundwater into a storage tank, which holds about 5,000 gallons of water. However, due in large part to the historic drought in California our well runs dry sometimes and we get water delivered when our tank runs low. In order to know when to order our next truckload of water I build a water level monitor that estimates water level via a 4-20mA pressure sensor loop, processes the data on an Arduino board, and transmits the data to AWS via the MQTT messaging protocol.

Why make and not buy? To start with, there really seems to be only one mature [product](https://smartwateronline.com/products/starter-packs/desk-mount-starter-pack) out there and it costs $599 NZD and ships from New Zealand. Obvioulsy it would have saved me a lot of time to just buy this product but I wanted to save some money and learn a bunch of things while doing so.

## System design
I went through several iterations of this project due to faulty hardware as well as upstream software issues. I'll spare (most of) the details of the initial versions but suffice it to say there was a lot of trial and error and several hardware returns. The final product comprises several main physical components:
1. 4-20mA sensor converts presure to resistance, with 0 meters of water resulting in 4mA and and 5 meters resulting in 20mA (powered by an 12-32v DC power supply)
1. 180 Ohms resistor converts resistance to analog voltage, ranging from 0.72v (4mA * 180 ohms) to 3.6v (20mA * 180 ohms)
1. Arduino board reads analog voltage and calculates water level (powered by a 5v DC power supply)

![board close up](/img/water_sensor_board.jpeg)
*A close up of the arduino board mounted on a breadboard with resistor*

The board publishes the estimated water level over wifi using the MQTT messaging protocol to be stored and processed. I use [io.adafruit.com](https://io.adafruit.com) to subscribe to my MQTT topic and visualize the data, though I used the AWS IOT service in an earlier version[^1]. I was also able to easily set up email alerts on Adafruit to notify me when my water level drops below a certain point. The main drawback is that data retention on the free tier but I don't have a strong use case for extended data retention.

The installation was fairly straighforward due to three factors:
1. There happened to be a 120v power supply and physical enclosure near the water tank that had enough space for the board
1. My water tank already had a hole in the top left by the previous owner
1. There was good wifi coverage at this physical enclosure

![board enclosure](/img/water_sensor_final.jpeg)
*Board in its resting position in the physical enclosure*

## Final cost of materials
Not including previous versions, the cost of my setup was roughly $90 and this yielded some extra supplies (e.g., breadboards, jumper wires).

 Item | Cost at time of purchase | Link 
---|---|---
 Arduino Nano 33 IoT | $24.48 | [link](https://store-usa.arduino.cc/products/arduino-nano-33-iot-with-headers )
 4‑20mA Water Level Transducer | $48.14 | [link](https://www.amazon.com/gp/product/B09B387X8Y)
 Breadboard (6 pk) | $9.99 | [link](https://www.amazon.com/gp/product/B07LFD4LT6)
 Breadboard jumper wires (120 count) | $6.89 | [link](https://www.amazon.com/gp/product/B07GD2BWPY)
 *Total* | *$89.50* |

## Next steps
In the future I may subscribe to my MQTT topic on my server in order to permanently store the data. This would enable me to develop anomaly detection and forecasting but right now I feel the development and maintenance of this functionality would complicate my life more than improve it...
![Water monitor dashboard](/img/water_monitor_dash.png)
*Snapshot of the water monitor dashboard*

The Arduino code for this project is open source and can be found in [this](https://github.com/rtlee9/water_tank_sensor_code) repository.

[^1]: I had initially used the AWS MQTT service, along lambda and DynamoDB data to store the data; separately I wrote a flask [app](https://github.com/rtlee9/water_monitor) to display the data and notify me when the water was low. This worked fine on my initial setup but I eventually switched board architectures (from ESP32 to Arduino Nano 33), wifi libraries, and messaging libraries due to various reliability issues. At that point I was no longer able to authenticate on AWS with my new board, which used a self-signed SSL certificate and this didn't seem to be well-supported on the AWS IOT service.
