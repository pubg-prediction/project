---
layout: post
title: Dimension Reduction and Clustering
date: 2018-12-02 14:11:27 -0700
---

Another way we could investigate feature ranking is if we hypothesize that features that exhibit the most variability also best explain our outcome variable. Principal components analysis (PCA) is a popular dimension reduction method that accomplishes this task. Rather than describing the data using the features given in the data set, PCA transforms the features to get orthogonal vectors that explain the variability within the dataset in descending order. 

## Principal Components Analysis
After applying PCA, we can look at the variance and cumulative variance explained by the each principal components as shown below.

<img src="{{ site.baseurl }}/img/posts/pc_varplot.png" width="50%" align="middle"/>

<img src="{{ site.baseurl }}/img/posts/pc_cumvar.png" width="50%" align="middle"/>

The first principal component explains about a third of the variability we see in our features (33.6%), while the second to sixth principal component all explain between 5 to 10%. The first three components cover over 50% of the variation we see in our data.

We also visualize each feature's contribution to the first two principal components and their correlations.

<img src="{{ site.baseurl }}/img/posts/pc_variables.png" width="50%" align="middle"/>

1. **PC 1**: The first principal component comprises of features related to player's damage and kills, primarily the features `kills`, `kill_place`, and `damage_dealt`. To a lesser extent, features like `kill_steaks`, `longest_kill`, `headshot_kills`, `boosts`, and `heals` also exhibit contribution primarily to the first principal component.

2. **PC 2**: The second principal component is characterized by details related to the match setting, i.e. `max_place` and `n_groups`.

3. **PC 3**: We can examine the table of contributions to each principal component to deduce which features contribute the most to the third principal component. The third principal component explains variation in features not well-represented in the first two components, such as `match_duration` and `ride_distance`.

From PCA, we can conclude that there are two primary dimensions along which our observations vary in terms of their features. The first dimension relates to player actions, specifically how much damage you dealt to other players. The second dimension relates to match characteristics representing the total number of players. From a player perspective, we are much more interested in the first principal component, since how you play is something within your control, while the number of opponents you are facing is not.


## Clustering of Winners

Another natural question we chose to explore with this dataset is to see whether we could identify which playing styles are most successful. Since the probability of winning increases as the number of players decrease, it is to the players' advantage to eliminate players. Thus, we can hypothesize that successful players may take two approaches to the game:

1. **Aggressive Strategy**: Players drop in a populated location and attempt to take control of the location. This is a high-risk and high-reward strategy as players are more likely to die early in the game due to an increased number of encounters but are rewarded with superior weapons and boosts.

2. **Passive Strategy**: Rather than eliminating other players yourself, the passive strategy relies on surviving until other players have been eliminated. This typically involves hiding to minimize encounters until only a few players remain, then selectively taking fights until the player is the only one remaining.

First, we attempted to identify these strategies in our data by looking at the distribution of the percentage of total players killed by winners.

<img src="{{ site.baseurl }}/img/posts/prop_players_killed.png" width="50%" align="middle"/>

Most winners kill a substantial proportion of their opponents -- on average, they eliminate 6% of players in the match. However, if there was a clear distinction between the two strategies in terms of proportion of players killed, we would expect to see a multi-modal distribution in the proportion of players killed for match winners. It is worth noting that there is a slight bump for winners with 0 to 0.1 proportion of players killed (where the winner may have only eliminated the second place player). However, it is not a sufficiently high bump to characterize the distribution as bimodal.

We also use PCA on the winners to see if there are clear clusters. In fact, we do see two clear clusters. However, we can see that the smaller cluster consists of winners of matches with very few players and those winners did not commit any kills, which means that all the other players were eliminated by some other factor (whether by forfeiting, not staying with the safe zone, or being killed by other players). Therefore, these clusters are not reflective of the different playing styles we hypothesized about. Upon further consideration, even if the playing styles we described accurately reflect reality, we may not have the necessary data that would've helped us cluster them. Some examples include:

1. Drop location: An important indicator of aggressiveness, as described earlier, is where a player chooses to drop on the map. We did not have this data and are therefore missing an important signal for playing style.

2. Time of kill: Aggressive players would likely be killing throughout the whole game while passive players would have most of their kills concentrated in the end. Or there may be a hybrid strategy where players are aggressive in the beginning to loot more items, then keep a low profile until the very end. Thus, longitudinal data for when a player killed other players would have helped separate different strategies.

Since we only have data on the total number of kills (relative and absolute), that may not be a sufficient signal to separate playing strategies. On the other hand, it may also be possible that clusters for playing strategies don't exist at all. Perhaps all winners pursue what we would consider an aggressive stratey, in which case we would not see separate clusters either.

## Summary
In conclusion, PCA revealed that orthogonal features that describe our player data can be broadly categorized as `kills, damage, and items`, `match setting`, and `rare features` (like swimming distance). Though we attempted to identify potential winning strategies, we realized that the provided data may not have a strong enough signal for strategy identification.
