---
title: Kaggle competition rewards
subtitle: Do larger competition rewards increase participation?
layout: post
gradient: canvas
tags: [machine learning, Kaggle, data visualization, linear regression]
---

Kaggle is a popular online platform for data science competitions. Competition hosts can post their data online, and data scientist from around the world compete to build the best algorithm for the host's needs.

Competition hosts benefit when they receive a large volume of high-quality submissions and walk away from the competition with a world-class model. One way they can foster engagement is by setting a competition reward. Let's analyze the [Meta Kaggle data](https://www.kaggle.com/kaggle/meta-kaggle/data) in Python 3 to see how reward size impacts competition engagement, as proxied by submission volume.


## Analysis

First, some setup:

{% highlight python linenos %}
# imports
from os import path
import pandas as pd
import numpy as np
import sqlite3

# plotly
import plotly.offline as py
py.init_notebook_mode(connected=True)
import plotly.graph_objs as go

# config
path_data = 'data'  # make sure sqlite db is saved to the `data` directory first
con = sqlite3.connect(path.join(path_data, 'database.sqlite'))
{% endhighlight %}


Next let's query the relevant data from the sqlite database:

{% highlight python linenos %}
# read data from sqlite db
usd_competitions = pd.read_sql_query("""
select
    c.Id
    ,c.CompetitionName
    ,c.RewardQuantity
    ,c.DateEnabled
    ,c.Deadline
    ,c.MaxDailySubmissions
    ,count(s.id) as submission_count
from competitions c
inner join teams t
    on t.CompetitionId = c.Id
inner join submissions s
    on s.teamid = t.id
where 1=1
    and c.rewardtypeid in (select id from rewardtypes where name = 'USD')  -- filter for competitions with USD rewards
    and c.RewardQuantity > 1  -- filter for competitions with USD rewards > $1
group by
    c.Id
    ,c.CompetitionName
    ,c.RewardQuantity
    ,c.DateEnabled
    ,c.Deadline
    ,c.MaxDailySubmissions
order by submission_count desc
""", con)

print('Fetched {:,} records with {:,} columns.'.format(*usd_competitions.shape))
{% endhighlight %}

Then we'll create new features to help us analyze the data:

{% highlight python linenos %}
# create features and clean up data
usd_competitions['date_enabled'] = pd.to_datetime(usd_competitions.DateEnabled)
usd_competitions['deadline'] = pd.to_datetime(usd_competitions.Deadline)
usd_competitions['competition_year'] = usd_competitions.date_enabled.dt.year
usd_competitions['ln_submission_count'] = np.log(usd_competitions.submission_count.fillna(1))
usd_competitions['duration'] = (usd_competitions.deadline - usd_competitions.date_enabled).dt.days
usd_competitions = usd_competitions[usd_competitions.RewardQuantity > 1]
usd_competitions['ln_reward'] = np.log(usd_competitions.RewardQuantity)

# exclude competition `flight2-final` because it doesn't sound or look like a real competition
usd_competitions = usd_competitions[usd_competitions.CompetitionName != 'flight2-final']
print('Cleaned dataset has {:,} records with {:,} columns.'.format(*usd_competitions.shape))
{% endhighlight %}

Plotting competition submission count over reward value, we can see a positive relationship between submission count and reward value. This is a fairly intuitive relationship -- we'd expect larger rewards to draw in more competitors, with those competitors putting in more effort on average, thereby increasing competition submission volumes.

<iframe width="100%" height="600" frameborder="0" scrolling="no" src="//plot.ly/~ryantlee9/5.embed?autosize=true&link=false&modebar=false&logo=false"></iframe>

If we're not careful, though, we might mistakenly think reward has a much greater impact on submission volumes than is warranted. Let's investigate further by plotting submission volumes over time along with a few other factors.

<iframe width="100%" height="600" frameborder="0" scrolling="no" src="//plot.ly/~ryantlee9/3.embed?autosize=true&link=false&modebar=false&logo=false"></iframe>

We can see a strong positive relationship between submission count and competition deadline here: average submissions per competition has doubled every 1-2 years historically (remember our y-axis is on the log scale). Much of this growth is likely due to the growing popularity of Kaggle's platform amongst data scientists (i.e., as opposed to growth in submissions per user); word of mouth, UX enhancements from new features such as kernels, and other enhancements have undoubtedly contributed to this growth.

Looking at the color (competition duration) and size (reward) of the plotted bubbles, we can also see some positive relationship with submission count (and with time), though to a significantly smaller extent. Let's formalize these observations with a simple linear regression.

First, we'll import the relevant methods from scikit learn and define a simple utility function to fit a model and report on the model score:

{% highlight python linenos %}
# import relevant methods from scikit learn
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression

# define simple utility function to fit a model `reg` and report on scoring
def fit_and_score(reg, X, y):
    """Fit a model and score on the validation data."""
    X_train, X_val, y_train, y_val = train_test_split(X, y, test_size=.25, random_state=0)
    print('Fitting model on training datset with {:,} records and {:,} features.'.format(*X.shape))
    reg.fit(X_train, y_train)
    print('Train / validation score: {:.3f} / {:.3f}'.format(reg.score(X_train, y_train), reg.score(X_val, y_val)))
    return reg
{% endhighlight %}

Now we'll fit a univariate linear regression of log submission count on log reward:

{% highlight python linenos %}
X = usd_competitions[['ln_reward']]
y = usd_competitions.ln_submission_count

reg_reward = LinearRegression()
reg_reward = fit_and_score(reg_reward, X, y)
print('Regression coefficient [reward]: {:.2f}'.format(reg_reward.coef_[0]))
{% endhighlight %}

<blockquote>
  Fitting model on training datset with 144 records and 1 features.<br>
  Train / validation score: 0.222 / 0.345<br>
  Regression coefficient [reward]: 0.39
</blockquote>

Looking at the R-squared (the default metric used in the [scikit learn linear regression](http://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LinearRegression.html) implementation), we find that we can explain about a quarter of the variation in submission volume through competition reward. Looking at the regression coefficient, we estimate that doubling the reward will increase expected submission volumes by roughly 39%.

However, we know that submission volume is also positively correlated with time. We can expand the regression feature-set to build a more accurate model and better understand the relationship between reward and submission volumes after accounting for other factors:

{% highlight python linenos %}
X = usd_competitions.copy()[['ln_reward', 'duration', 'MaxDailySubmissions']]
X['deadline'] = usd_competitions.deadline.dt.year + usd_competitions.deadline.dt.month / 12

reg_multifactor = LinearRegression()
reg_multifactor = fit_and_score(reg_multifactor, X, y)
print('\nRegression coefficients:')
for feature, coef in zip(X.columns, reg_multifactor.coef_):
    print('\t{:<20}: {:.2f}'.format(feature, coef))
{% endhighlight %}

<blockquote>
  Fitting model on training datset with 144 records and 4 features.<br>
  Train / validation score: 0.527 / 0.580<br>
  Regression coefficients:
  <ul>
    <li>ln_reward           : 0.17</li>
    <li>duration            : 0.00</li>
    <li>MaxDailySubmissions : -0.00</li>
    <li>deadline            : 0.54</li>
  </ul>
</blockquote>


Once we adjust for deadline, competition duration, and daily submission limits, we see that we can explain a much larger share of the variation in submission volume through our simple model (a little more than 50%). Furthermore, under this new model, we estimate that **doubling the reward will increase expected submission volumes by roughly 17%** -- smaller than before, but definitely not insubstantial. Similarly, we estimate that **delaying a proposed competition by a year will increase expected submission volumes by roughly 54%**. Other factors, such as competition duration and maximum daily submissions appear to play a negligible role after accounting for time and reward value.

## Lessons for hosts
So what's the lesson for potential competition hosts? Firstly, we found that increasing the competition prize will likely generate additional submissions (roughly 17% more submissions for a doubling of the reward), in turn increasing the likelihood of attaining a better model. We're tempted to feel sorry for those hosts who hosted a competition in Kaggle's early years; they did, after all, receive a fraction of the submission volume per dollar of prize money spent. At the same time, had they held off hoping for higher volumes as the platform increased in popularity, they would have foregone years of having a world-class model -- a high cost indeed!

## Next steps
This analysis constitutes a very simple look at the effect of competition reward on submission volume. There are likely other important factors which I didn't look at, including:

 * competition domain: computer vision, traditional ML, etc.
 * organization type: for-profit, public entity, non-profit
 * data structure and general ease-of-use (e.g., kernel-only)

Similarly, submission counts are only a proxy for what hosts actually care about, which is probably a combination of several things like final model quality, public awareness and perception, etc. Future work might investigate alternative metrics better reflecting these qualities.

Lastly, the model we used to quantify the effect of various factors on submission volumes could be further validated (e.g., verify OLS regression assumptions hold, k-fold cross performance validation).

