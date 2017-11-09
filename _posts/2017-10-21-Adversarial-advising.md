---
title: Adversarial advising
subtitle: Reverse engineering machine learning models for advice
layout: post
gradient: canvas
tags: [machine learning, gradients, adversarial, neural network]
---

Machine learning models are frequently used to make predictions about a target variable, such as the sales price of a home. However, we can use a fitted model to do much more than to predict -- by carefully inspecting a model we can glean useful insights that can be used to advise individuals and provide them with a series of actionable steps to improve their standing in a particular domain. In this post, we'll develop a simple model to predict the value of a home, and we'll use that model to advise an illustrative home buyer on how he or she might find a better deal.

<head>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/nvd3/1.7.0/nv.d3.min.css" rel="stylesheet" />
  <script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.5/d3.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/nvd3/1.7.0/nv.d3.min.js"></script>
  <style>
    #fig1, #fig2 {
      margin-top: 30px;
    }
  </style>
</head>

## Background

Machine learning models estimate the value of an unknown target variable by learning a mapping from a series of features (i.e., independent variables) to the target variable (i.e., the dependent variable). Each mapping comprises a series of instructions that can be used to estimate the value of the target variable that corresponds to the set of features we're able to see.

By inspecting these mappings we can learn a lot about the relationship between individual features and the target variable. We can learn, for example, how certain factors such as the square footage of a home relate to house prices (we would expect there to be a strong, positive relationship). We can also use these mappings to attack a model by selectively nudging input values in direction that will most likely give us the prediction we want, and subsequently feeding the model with those modified values[^1].

These mappings can also be used for more benign purposes: if we fit a model to estimate something we care about, we can "attack" our own model to identify actionable steps we can take to maximize that something. I'll call this concept _adversarial advising_ for the remainder of this post. Let's take a look at how this might work in practice by fitting a machine learning model and attacking it to advise potential home buyers on how to find better deals on homes.

## Setup: data and utilities {#setup}

First, let's load our dataset using scikit-learn's `datasets` module and declare a quick utility function to help us interpret our results. The house-level dataset, sourced from [CMU](http://lib.stat.cmu.edu/datasets/), contains house price values and data on several relevant factors, including square footage, location, and number of rooms.

{% highlight python linenos %}
from sklearn.datasets import california_housing
dataset = california_housing.fetch_california_housing()

def print_coefficients(feature_names, coefficients):
    """Utility function to zip and print coefficients with the name of their feature"""
    for feature, coef in zip(feature_names, coefficients):
        print(feature, coef)
{% endhighlight %}


## Linear regression
Linear regressions are easy to interpret, and as a result it's particularly easy to use them for adversarial advising. Linear regressions map features to a target variable by multiplying each feature's value by a learned coefficient and summing the resulting products. Each coefficient is the partial derivative of the predicted target variable with respect to a single feature -- it tells us how much a one-unit change in the feature will impact the prediction.

Using scikit-learn's `LinearRegression` class, we can easily fit a linear regression model and find the coefficients of the fitted model.

{% highlight python linenos %}
from sklearn.linear_model import LinearRegression
linreg0 = LinearRegression().fit(dataset.data, dataset.target)
print_coefficients(dataset.feature_names, linreg0.coef_)
{% endhighlight %}


The coefficient of the fourth feature (plotted in [Figure 1](#fig1)) tells us that adding an extra bedroom is associated with a higher home price by roughly $65,000. This coefficient happens to be the largest, but that doesn't necessarily mean it's the easiest to change (e.g., if the feature is measured in small units). In order to determine our best chance for finding a cheaper home with minimal impact to the feature space, we need to normalize our features by scaling by the inverse of the variance (called "removing the variance"). We'll do so with scikit-learn's `StandardScalar` class:

{% highlight python linenos %}
from sklearn.preprocessing import StandardScaler
scaler = StandardScaler()
scaler.fit(dataset.data)
X_scaled = scaler.transform(dataset.data)

linreg1 = LinearRegression().fit(X_scaled, dataset.target)
print_coefficients(dataset.feature_names, linreg1.coef_)
{% endhighlight %}


#### Figure 1: Coefficients {#fig1}
{% include regression_coeffs.html %}

The scaled features are now on a level playing field -- each feature-unit now represents one standard deviation across the observations in our training set. This gives us an intuitive, standardized way of comparing coefficients across features measured in different magnitudes[^2].

The coefficients from this model (partial derivatives, per above) are collectively the feature gradient; the gradient indicates the shortest path in the feature space we can take to maximize or minimize the prediction under certain assumptions[^3]. We can look at the calculated gradient to figure out which features can be manipulated to give us the biggest bang for our buck. The scaled gradient advises us, amongst other things, that:

* increasing `MedInc` by one standard deviation will significantly increase the predicted house price
* increasing `AveBedrms` by one standard deviation will increase the predicted house price to a lesser extent
* increasing `AveOccup` by one standard deviation will slightly decrease the predicted house price

If we trust our model's ability to make accurate predictions, we can act on these insights to find a better bargain on the housing market. For example, I should probably consider looking for houses in neighborhoods with slightly lower average incomes, as our model advises us this will likely yield significantly more affordable homes for relatively small changes in average income (more so than for other features).

## Neural net

While calculating the gradient is trivial for linear regressions, it can be more complicated for other models. Let's get a little bit more precise in our advice by fitting a neural net for adversarial advising. Unlike with linear regressions, the feature gradient will change across the feature space for neural nets (i.e., the gradient for one house will look different from the gradient for another house). This is fairly intuitive -- we might expect the price of a house to vary with square footage to a larger extent in some neighborhoods than in others -- and often yields better predictive accuracy. As a result, adversarial advise from a neural net is tailored to each reference data point (to each house in our example), and should generally be more accurate.

{% highlight python linenos %}
from sklearn.neural_network import MLPRegressor
import numpy as np

# Fit a network with one hidden layer of 200 nodes
# with a sigmoid activation function
nn = MLPRegressor(activation='logistic', hidden_layer_sizes=(200,), random_state=0)
nn.fit(X_scaled, dataset.target)
{% endhighlight %}

Now let's calculate the gradient for the neural net using the average home sale as the reference point. The following derivations assume a basic understanding of neural net mechanics, including backpropagation -- I'd suggest reading [this](http://neuralnetworksanddeeplearning.com/chap2.html) blog post if you find yourself in need of review.

We can calculate the input gradient using the backpropagation algorithm, except we're going to be propagating the model estimate itself rather than the error. First, let $$C_0$$ denote the weight matrix that transforms the input vector $$x$$ to the hidden layer and $$C_1$$ denote the weight matrix that transforms the hidden layer to the output vector $$y$$[^4]. Using backpropagation, we can calculate the input gradient $$\frac{\partial{y}}{\partial{x}}$$ as follows:

1. Calculate the partial derivative of the output vector $$y$$ with respect to the hidden layer activation vector $$a$$ as $$  \frac{\partial{y}}{\partial{a}} = C_1$$
1. Calculate the partial derivative of the hidden layer activation vector $$a$$ with respect to the input vector $$x$$ as $$ \frac{\partial{a}}{\partial{x}} = C_0 \cdot \sigma'(x \cdot C_0) $$ by the chain rule
1. Calculate the partial derivative of the output $$y$$ with respect to the input vector $$x$$ as $$ \frac{\partial{y}}{\partial{x}} = \frac{\partial{y}}{\partial{a}} \frac{\partial{a}}{\partial{x}}$$ by the chain rule

where $$\sigma(z) = \frac{1}{1 + {e}^{-z}}$$ and $$\sigma' = \sigma(z) (1 - \sigma(z))$$ are the sigmoid and sigmoid derivative functions, respectively.

{% highlight python linenos %}
# Utility functions for calculating the gradient
def sigmoid(z):
    """The sigmoid function."""
    return 1.0/(1.0+np.exp(-z))

def sigmoid_prime(z):
    """Derivative of the sigmoid function."""
    return sigmoid(z)*(1-sigmoid(z))

def calculate_nn_gradients(nn, sample):
    """Calculate feature gradients for a nerual net with one hidden layer.
    This function can be easily abstracted upon for neural nets with multiple hidden layers.
    """
    x = np.append(sample, 1)  # add a one to the input vector for the intercept
    C0 = np.vstack([  # concatenate the vector of intercepts on to the coefficents matrix
	nn.coefs_[0],
	nn.intercepts_[0].reshape(1, -1)
    ])
    C1 = nn.coefs_[1].squeeze()
    return C0.dot(sigmoid_prime(x.dot(C0)) * C1)

# evaluate the gradient for the mean home sale
sample_avg = np.zeros(X_scaled.shape[1])
gradients_avg = calculate_nn_gradients(nn, sample_avg)
print_coefficients(dataset.feature_names, gradients_avg)
{% endhighlight %}

Now let's recalculate the gradient using a randomly selected home sale:
 
{% highlight python linenos %}
# evaluate the gradient at a randomly selected home sale
np.random.seed(2)
sample_rand = X_scaled[np.random.randint(0, X_scaled.shape[0]), :]
gradients_rand = calculate_nn_gradients(nn, sample_rand)
print_coefficients(dataset.feature_names, gradients_rand)
{% endhighlight %}

[Figure 2](#fig2) shows that the neural net gradients are directionally similar to that of the linear regression. As before, we see that:

* increasing `MedInc` by one standard deviation will significantly increase the predicted house price
* increasing `AveBedrms` by one standard deviation will increase the predicted house price to a lesser extent
* increasing `AveOccup` by one standard deviation will decrease the predicted house price[^5]

#### Figure 2: Sample neural net gradients {#fig2}
{% include nn_gradients.html %}

Additionally, we now find advice tailored to the particulars of the individual; for example, we can get custom advice on _where_ to look for a house, given the specific type of house we're interested in, by looking at the latitude and longitude derivatives.

While much could be done to improve the models themselves (e.g., feature generation, cross validation and iterative refinement), we've learned how to use machine learning models to generate tailored advice for real world problems using adversarial advising.

-----

## Footnotes

[^1]: OpenAI recently published a great [blog post](https://blog.openai.com/adversarial-example-research/) on how these attacks can be done on computer vision models.
[^2]: Scaling can also help model optimization convergence under certain algorithms such as stochastic gradient descent (SGD).
[^3]: These assumptions are often violated in practice, but nevertheless gradients are still frequently useful for optimizing parameters; gradients are the basis of many oft-used optimization algorithms, such as SGD.
[^4]: The following calculations assume the weight matrices contain the intercepts.
[^5]: This relationship is substantially more negative under the neural net than under the linear regression, but varies widely over the feature space.
