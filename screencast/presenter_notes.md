Presenter notes

* PUBG is a battle royale game where players are dropped onto a map and must stay within a shrinking safe zone as they fight until only one player is left standing.
* Over the course of the game, players can ride vehicles and use a variety of weapons to take down their enemies.
* Question 1: How well can we determine who is going to win from a group of players?
* Question 2: What player actions best predicts the finish placement?
* These are the results from our prediction model. On the x-axis is the actual finish percentile and on the y-axis is the predicted finish percentile. If our predictions were perfectly accurate, all the points should lie on this yellow line. The median absolute error of our predictions is 0.03, which means that on average, our predictions deviate from the true actual finish placement by 3% and 50% of points lie within this highlighted region.
* From this plot, how can we predict the winners, which are the points in this green circle? One way is to call everyone a winner if their predicted finish percentile is above the red line and a loser if they are below the line. We can adjust the cut-off to be lower to correctly classify more winners, but we will also misclassify more losers as winners.
* This trade-off is illustrated by an ROC curve. Each point corresponds to a different cut-off. For example, this cutoff gives us 95% sensitivity and 92% specificity, which means that we classify 95% of actual winners correctly, but also misclassify 18% of losers as winners.
* To answer our second question, which features were most predictive, we ranked the features in the plot above. Let’s take a look at the top features.
* The top features fall into two categories: in blue are features related to items, such as weapons acquired or boosts, which give players additional health and speed. In red are features related to kills, which we found to be the most predictive of winners. 
* In fact, among the winners, we see that they eliminated about 6% of all players in the game. In comparison, everyone else kills about 1%, which makes winners 6 times more murderous than everyone else.
* Those were just some of the highlights of our analysis. To take a look at other cool plots and analysis we did, visit our webpage at the following link.