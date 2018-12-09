---
layout: post
title: "Prediction Models"
date: 2018-12-02 14:11:27 -0700
---
In this section, we aim to answer our remaining two questions:

1. Model Prediction: How well can we predict a player's finish placement? How well can we classify winners?
2. Feature Ranking: What player actions or statistics are most predictive of their finish placement?

To answer these questions, we will fit the following models, test our model on an independent set, and examine feature importance scores:

1. Linear regression
2. Elastic net regression
3. Random forest

Note: In training our models, unless stated otherwise, we will include all features except for the match ID and player ID, since neither feature is going to generalize for predicting new games, which is what we are interested in.

## Linear Regression

First, we fit a linear regression model using step-wise model selection using AIC with 5-fold cross-validation. Since the win place percentage is a value between 0 and 1, we apply a log transformation (adding 1 to ensure all values are defined), so that it better fulfills the assumption that $y$ is a continuous variable on the real line. However, this still doesn't guarantee that the predicted values will be between 0 and 1, so we constrain the predicted value to be 0 if it is negative and 1 if it is above 1.

A plot of the predicted versus actual final percentiles is shown below.

<img src="{{ site.baseurl }}/img/posts/lr_predvsactual.png" width="50%" align="middle"/>

## Elastic net regression

As we noted earlier in the data exploration, some of the features are highly correlated and/or seem to provide little signal (such as distance traveled). To solve these issues, we implement elastic net regression which uses a ridge-regression-like penalty to adjust for correlated features and lasso penalty to shrink non-informative features to zero. Using 5-fold cross-validation in the training set, we tune regularization hyper parameters.

A plot of the predicted versus actual final percentiles is shown below.

<img src="{{ site.baseurl }}/img/posts/lasso_predvsactual.png" width="50%" align="middle"/>

## Random Forest

To account for interactions between features, we can use a random forest model. Ensemble methods like random forest are known to generally perform better than regression models. Due to computational costs, however, we make the following choices:

1. Train the random forest model on 10,000 observations (as opposed to 60,000 observations).
2. Use 100 trees in the random forest.

Again with 5-fold cross-validation, we tune hyper parameters for random forest.

A plot of the predicted versus actual final percentiles is shown below.

<img src="{{ site.baseurl }}/img/posts/rf_predvsactual.png" width="50%" align="middle"/>

Note that the spread of points narrows for players that place lower (actual win place percentage approaches 0). This indicates that we are able to predict the finish percentile more accurately for players that place higher.


## Comparison of Models

We will compare our models with the following metrics on the validation set:

1. **Mean absolute error (MAE)**: Represents the average absolute deviation.

<img src="{{ site.baseurl }}/img/posts/MAE.png" width="50%" align="middle"/>

2. **Self-defined accuracy metric (SDAM(x))**: This metric is a function of a cutoff value $x$. If the predicted outcome is within $x\%$ of the actual win place percentage, we classify it as a "correct" prediction. Otherwise, it is an incorrect prediction.  

<img src="{{ site.baseurl }}/img/posts/SDAM.png" width="50%" align="middle"/>

3. **Classification of Winners**: We can compute the ROC curve by turning our predictions into a classification problem. Given a predicted win place percentage, we classify the player as a winner if its predicted value is less than a cutoff value $x\%$. For different cutoff values, we can then compute the sensitivity (true positive rate, or the proportion of actual winners we classify as such) and specificity (true negative rate, or the proportion of actual losers we classify as such).

<img src="{{ site.baseurl }}/img/posts/ROC.png" width="50%" align="middle"/>


From the above plots, we can see that random forest performs best on all three metrics. This is despite the restrictions we had to place in order to run the random forest model in a reasonable amount of time. Its MAE is 0.058, which means that on average, the predicted win place percentage is 0.058 off from the true finish percentile. Its SDAM is consistently higher than the SDAM for linear regression or elastic net regression. For example, its SDAM(5) is 0.586, which means that for 58.6% of observations in our validation set, the predicted value is within 5% of the true win place percentage. Lastly, the area under its ROC curve is the largest, which indicates that it performs best at classifying who the winners are (sensitivity = 0.96, specificity = 0.82).

These results have been validated on the test set -- validation agreed with our findings noted above. 

## Feature Ranking

We can look at the relative importance of features for each of the models.

<img src="{{ site.baseurl }}/img/posts/feature_ranking.png" width="50%" align="middle"/>

Unexpectedly, there is not much agreement in the features that each model regards to be important. One explanation for this is the presence of highly correlated features in our data; for example, if we look at the features `kill_place` and `kill_streaks`, the former is rated as highly important by the linear regression and random forest, while the latter is rated as highly important by elastic net regression. However, the two features are known to be highly correlated with each other. While random forest performs best in prediction, the caveat with its importance score metric is that if multiple features are all predictive of the outcome but are highly correlated with the outcome, the importance score of each feature is going to be suppressed.

Since elastic net regression accounts for correlation between features, we will primarily use its variable importance values to summarize our findings for ranking the importance of player characteristics and actions:

1. The most important predictor is the number of kills a player makes. Elastic net regression chooses `kill_streaks` as the most predictive among the different features related to kills. What this suggests is that while some players may succeed with less confrontational playing strategies, you need to kill other players or you will be eliminated.

2. Among items used, `weapons_acquired` and `boosts` are the strongest predictors of outcome. This is interesting because one would expect that among the features related to item acquisition and usage, weapons would be the dominant predictor. However, the acquisition of weapons may plateau over time once you have strong weapons. On the other hand, `boosts` enable increased health regeneration over time and have a small movement speed bonus when the amount of boosts consumed is beyond a particular threshold. Players tend to save boosts as an additional advantage in the later stages of the game when most players have powerful weapons. Consequently, the number of boosts consumed is also a strong indicator of a successful player.
