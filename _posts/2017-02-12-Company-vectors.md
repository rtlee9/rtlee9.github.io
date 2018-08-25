---
title: Company vectors
subtitle: Learning high dimensional company representations
layout: post
overlay: 50,110,170,0.7
bigimg: /img/sides-of-a-skyscraper.jpg
tags: [machine learning, deep learning, transfer learning, word vectors, paragraph vectors, representations, NLP, SIC]
---

In this post I introduce the _Company Vector_, a distributed representation of a company's core business activities. Company vectors are learned from business descriptions found in public SEC 10-K filings using an unsupervised learning algorithm called the _Paragraph Vector_. The learned vectors can be used to compare companies to each other and to support various machine learning tasks relating to company-centric analytics.

## Background
Deep learning has produced some amazing results over the last several years across a wide range of applications, including image recognition and natural language processing. One of the reasons deep learning is so powerful is because it is able to map inputs to outputs in nonlinear ways. In doing so, it can create useful representations of those inputs along the way.

One particularly interesting example of this is the _Word Vector_, which represents words as high dimensional vectors. These vectors are learned as the byproduct of a prediction task: to predict which words surround a given word in a sentence, or alternatively, to predict a word given its context. Faced with this task, the model learns to efficiently represent each word as a set of numbers, called a word vector. These vectors can be used to compare words to each other and to complete word analogies, amongst other tasks[^1].

The _Paragraph Vector_, recently introduced by Google ([Le; Mikolov, 2014](https://arxiv.org/pdf/1405.4053.pdf)), represents a sequence of multiple words as a high dimensional vector. It extends the word vector methodology by forcing the model to keep track of an additional _paragraph token_ during training. This token is not associated with any particular word but is present for each training observation drawn from that paragraph, allowing the model to capture the topic of the paragraph.

## Learned company representations
I used the Gensim implementation of paragraph vectors, called [doc2vec](https://radimrehurek.com/gensim/models/doc2vec.html), to learn a 100 dimensional vector representation of each company's business activities. The model was trained on a corpus of business descriptions scraped from annual 10-K filings. Specifically, the corpus was populated with text from _Item 1_ of each company's 10-K; the SEC [describes](https://www.sec.gov/answers/reada10k.htm) _Item 1_ as follows:

> __Item 1 - “Business”__ requires a description of the company’s business, including its main products and services, what subsidiaries it owns, and what markets it operates in. This section may also include information about recent events, competition the company faces, regulations that apply to it, labor issues, special operating costs, or seasonal factors. This is a good place to start to understand how the company operates.

A simplified version of the learned company vectors can be plotted using dimensionality reduction. [Figure 1](#fig1) below depicts the 100 dimensional vectors reduced to two dimensions with [t-SNE](https://lvdmaaten.github.io/tsne/). Each point in the plot represents one company, and the color of the point represents that company's SIC code, a four-digit code intended to classify a company's primary business activities. A clear pattern emerges, where companies of similar SIC codes tend to appear in close proximity to each other, even though the model never saw the SIC codes. These clusters of similarly coded companies indicate the model is doing a good job of learning what a company does for a living.

### Figure 1: t-SNE company vector reduction {#fig1}
![Company vector reduction](/img/company-vectors-t-sne.png)

Company vectors can also be used to compare companies to each other by comparing the distance between the vectors of those companies (e.g., Euclidean distance, cosine similarity). [Table 1](#table1) below shows the companies corresponding to the five nearest company vectors for a few examples[^2].

### Table 1: Sample of nearest company vectors {#table1}
<h4>(SIC codes in [brackets])</h4>
<div class="table-responsive">
<table>
  <thead>
    <tr>
      <th style="text-align: left">Company</th>
      <th style="text-align: left">Similar companies</th>
      <th style="text-align: right">Cosine similarity</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align: left" rowspan="5">PepsiCo Inc [2080]</td>
      <td style="text-align: left">Cott Corp [2086]</td>
      <td style="text-align: right">81%</td>
    </tr>
    <tr>
      <td style="text-align: left">General Mills Inc [2040]</td>
      <td style="text-align: right">81%</td>
    </tr>
    <tr>
      <td style="text-align: left">Treehouse Foods Inc [2030]</td>
      <td style="text-align: right">79%</td>
    </tr>
    <tr>
      <td style="text-align: left">Kraft Foods Group Inc [2000]</td>
      <td style="text-align: right">78%</td>
    </tr>
    <tr>
      <td style="text-align: left">Lancaster Colony Corp [2030]</td>
      <td style="text-align: right">78%</td>
    </tr>
    <tr>
      <td style="text-align: left" rowspan="5">Gogo Inc [4899]</td>
      <td style="text-align: left">Global Eagle Entertainment Inc [4899]</td>
      <td style="text-align: right">81%</td>
    </tr>
    <tr>
      <td style="text-align: left">Spirit Airlines Inc [4512]</td>
      <td style="text-align: right">77%</td>
    </tr>
    <tr>
      <td style="text-align: left">Virgin America Inc [4512]</td>
      <td style="text-align: right">75%</td>
    </tr>
    <tr>
      <td style="text-align: left">Hawaiian Holdings Inc [4512]</td>
      <td style="text-align: right">75%</td>
    </tr>
    <tr>
      <td style="text-align: left">American Airlines Inc [4512]</td>
      <td style="text-align: right">75%</td>
    </tr>
    <tr>
      <td style="text-align: left" rowspan="5">KeyCorp [6021]</td>
      <td style="text-align: left">Huntington Bancshares Inc [6021]</td>
      <td style="text-align: right">85%</td>
    </tr>
    <tr>
      <td style="text-align: left">MUFG Americas Holdings Corp [6021]</td>
      <td style="text-align: right">84%</td>
    </tr>
    <tr>
      <td style="text-align: left">Regions Financial Corp [6021]</td>
      <td style="text-align: right">84%</td>
    </tr>
    <tr>
      <td style="text-align: left">PNC Financial Services Group Inc [6021]</td>
      <td style="text-align: right">84%</td>
    </tr>
    <tr>
      <td style="text-align: left">M&T Bank Corp [6022]</td>
      <td style="text-align: right">82%</td>
    </tr>
  </tbody>
</table>
</div>

These examples illustrate that the model appears to be able to learn a lot about a company's operations, including the type of products and services the company sells, the company's primary region of operation, and the type of clients the company serves.

1. __Pepsi__ is a diversified food and beverage company, which makes classifying it in a single SIC code difficult. Company vectors do a good job of identifying broadly similar companies, even though they are classified under different SIC codes.
1. __Gogo__ provides connectivity solutions (e.g., in-flight WiFi) to airlines. The nearest company vector is that of Global Eagle Entertainment, another connectivity solutions provider. Several of their clients follow in the similarity list, though with noticeably lower similarity scores.
1. __KeyCorp__ is a large regional bank that conducts a lot of its business in the Midwest. The top five nearest company vectors represent companies that are generally similar in size and geography.

Company vectors can also be used to support various machine learning tasks relating to company-centric analytics by serving as features for other models. They may be useful, for example, in predicting financial performance in combination with other features.

## Comparatory
In order to more easily explore the learned company representations, I built [comparatory.co](https://www.comparatory.co/), a small Python Flask app. It currently provides two functions:

1. __Search:__ enter a company name and it will identify the five most similar companies based on company vector distance
1. __Explore:__ identify clusters of similar companies with an interactive low dimensional plot of reduced company vectors

Feel free to give it a try!

-----------------------------------------------------------------------------

### Footnotes
[^1]: Christopher Olah provides a great overview of deep learning, NLP, and representations [here](http://colah.github.io/posts/2014-07-NLP-RNNs-Representations/).
[^2]: These similarity scores were calculated based on the original high dimensional company vectors, as opposed to the reduced vectors, in order to preserve pertinent information.
