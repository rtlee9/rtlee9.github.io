---
title: Serving an image classifier via API in 16 lines of code
subtitle: Simple API serving for a pre-trained Keras DenseNet model with ServeIt
layout: post
gradient: canvas
tags: [machine learning, computer vision, convolutional neural network, API, inference, serving, python, keras]
---

[ServeIt](https://github.com/rtlee9/serveit) is an open source library that lets you easily serve model predictions and supplementary information from a RESTful API on any domain using your favorite Python ML library. This post illustrates the process of deploying a pre-trained ImageNet classifier with ServeIt to a new API. The classifier accepts an image URL as a parameter in a POST request and responds with the top predicted classes for that image.

You can interact with a live DenseNet121 demo server at `https://imagenet-keras.ryanlee.io/predictions` (source code and request examples can be found [here](https://github.com/rtlee9/serveit-demo-imagenet-keras/)) or follow along below to start serving your own classifier.

## Pre-trained DenseNet121 serving using ServeIt

Let's start by installing the dependencies listed [here](https://github.com/rtlee9/serveit-demo-imagenet-keras/blob/master/requirements.txt) (`pip install -r requirements.txt`, in a virtual environment). After our dependencies are installed, we'll load a DenseNet121 model that has been pre-trained for us on the ImageNet dataset:

{% highlight python linenos %}
from keras.applications import densenet

# load DenseNet121 model pre-trained on ImageNet
model = densenet.DenseNet121(weights='imagenet')
{% endhighlight %}

Next we define methods for loading and preprocessing an image from a URL...
{% highlight python linenos %}
from keras.preprocessing import image
from flask import request
import requests
from serveit.utils import make_serializable, get_bytes_to_image_callback

# define a loader callback for the API to fetch the relevant data and
# preprocessor callbacks to map to a format expected by the model
def loader():
    """Load image from URL, and preprocess for DenseNet."""
    url = request.args.get('url')  # read image URL as a request URL param
    return requests.get(url).content  # return image as bytes

# get a bytes-to-image callback to resize image to 224x224
bytes_to_image = get_bytes_to_image_callback(image_dims=(224, 224))

# create a list of different preprocessors to chain multiple steps
preprocessor = [bytes_to_image, densenet.preprocess_input]
{% endhighlight %}

...and now we're ready to start serving our image classifier:
{% highlight python linenos %}
from serveit.server import ModelServer

# initialize a ModelServer
server = ModelServer(
    model=model, predict=model.predict, data_loader=loader,
    preprocessor=preprocessor, postprocessor=densenet.decode_predictions)

# start serving
server.serve()
{% endhighlight %}

Behold:
![cat picture](/img/cat.jpg)
{% highlight bash linenos %}
curl -XPOST 'localhost:5000/predictions?url=https://images.pexels.com/photos/96938/pexels-photo-96938.jpeg'
# [[["n02123045", "tabby", 0.69397], ["n02123159", "tiger_cat", 0.14688], ["n02124075", "Egyptian_cat", 0.05430], ...]]
{% endhighlight %}

![plane picture](/img/airplane.jpg)
{% highlight bash linenos %}
curl -XPOST 'localhost:5000/predictions?url=https://images.pexels.com/photos/67807/plane-aircraft-take-off-sky-67807.jpeg'
# [[["n02690373", "airliner", 0.60765], ["n04592741", "wing", 0.22114], ["n04552348", "warplane", 0.14071], ...]]
{% endhighlight %}


Additional examples can be found [here](https://github.com/rtlee9/serveit/tree/master/examples). Happy serving!
