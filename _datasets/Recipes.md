---
title: Recipe box
subtitle: Structured recipes scraped from food websites
date: 2017-03-14
layout: page-wide
overlay: 200,100,130,0.7
bigimg: /img/food.jpg
tags: [food, recipes, ingredients, images, webscraping, python]
---

Online recipes typically consist of several components: a recipe title, a list of ingredients and measurements, instructions for preparation, and a picture of the resulting dish. I haven't been able to find any open datasets containing each of these elements, so I [scraped](https://github.com/rtlee9/recipe-box) ~125,000 recipes from various food websites[^1].

A typical recipe looks something like this:

* __Title:__ Guacamole
* __Ingredients:__
  * 3 Haas avocados, halved, seeded and peeled
  * 1 lime, juiced
  * 1/2 teaspoon kosher salt
  * 1/2 teaspoon ground cumin
  * 1/2 teaspoon cayenne
  * 1/2 medium onion, diced
  * 1/2 jalapeño pepper, seeded and minced
  * 2 Roma tomatoes, seeded and diced
  * 1 tablespoon chopped cilantro
  * 1 clove garlic, minced
* __Instructions:__ In a large bowl place the scooped avocado pulp and lime juice, toss to coat. Drain, and reserve the lime juice, after all of the avocados have been coated. Using a potato masher add the salt, cumin, and cayenne and mash. Then, fold in the onions, tomatoes, cilantro, and garlic. Add 1 tablespoon of the reserved lime juice. Let sit at room temperature for 1 hour and then serve.
* __Source:__ [http://www.foodnetwork.com/recipes/alton-brown/guacamole-recipe](http://www.foodnetwork.com/recipes/alton-brown/guacamole-recipe)
* __Picture:__

<img src="/img/guacamole.jpeg" style="width: 300px;"/>

This dataset is particularly interesting for machine learning because each recipe contains multiple elements, each of which provides additional information about the recipe. Current deep learning models excel at learning the relationship between one element and a single other element (e.g., image-to-text, text-to-image, text-to-summarized-text). I've used this dataset for two deep learning mini-projects so far:

* [Recipe summarization](https://github.com/rtlee9/recipe-summarization): generate a title for a recipe given the corresponding ingredients and instructions
* [Food GAN](https://github.com/rtlee9/food-GAN): generate novel food images using Generative Adversarial Networks

However, these models don't make full use of a recipe's entire information set and structure; I'm particularly interested in utilizing multiple recipe elements simultaneously to learn high dimensional representations of recipes for use in recipe summarization, interpolation, and generation. I'd love to hear from you if you've worked on a similar problem.


-----------------------------------------------------------------------------

### Learn more
<ul class="list-inline dataset" style="margin: 20px 0 40px 0;">
<li>
<a href="https://storage.googleapis.com/recipe-box/recipes_raw.zip" download>
  <button type="button" class="btn btn-primary btn-lg">
    <i class="fa fa-lg fa-download"></i>
      Download recipes
  </button>
</a>
</li>

<li>
<a href="https://storage.googleapis.com/recipe-box/imgs.zip" download>
  <button type="button" class="btn btn-primary btn-lg">
    <i class="fa fa-lg fa-download"></i>
      Download recipe images
  </button>
</a>
</li>

<li>
<a href="https://github.com/rtlee9/recipe-box">
  <button type="button" class="btn btn-primary btn-lg">
    <i class="fa fa-lg fa-github"></i>
      View project on GitHub
  </button>
</a>
</li>

<li>
<a href="/datasets">
  <button type="button" class="btn btn-primary btn-lg">
    <i class="fa fa-lg fa-database"></i>
      View other datasets
  </button>
</a>
</li>
</ul>

-----------------------------------------------------------------------------

### Footnotes
[^1]: Roughly 70,000 of these recipes have images associated with them. Comments and ratings data are not included.
