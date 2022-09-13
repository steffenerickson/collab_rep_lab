*------------------------------------------------------------------------------*
* Randomization Walkthrough 
*------------------------------------------------------------------------------*
/*
global root_drive 
global programs
global results

cd ${root_drive}  
do ${programs}/randomize.do
do ${programs}/randomize_balance.do
*ssc install mahapick //uncomment if you need to download the package 
*/

*clear all 
use https://www.stata-press.com/data/r17/physed, clear
gen id = _n 

*------------------------------------------------------------------------------*
* Hierarchical Clustering to Create Blocks 
*------------------------------------------------------------------------------*

*--------------------*
*Diagnostic Plots 
*--------------------*
scatter flex strength //two dim
graph matrix flex speed strength // 3 dim 

*--------------------*
* Create Blocks 
*--------------------*
*Create mahalanobis distance dissimilarity matrix 
mahascores flex strength, genmat(distance) unsq compute_invcovarmat 

*Hierarchical clustering using distance matrix and wardslinkage as estimator 
clustermat wardslinkage  distance, add name(dist_mat) 

*Estimate the correct number of groups - looking for highest F value 
clustermat stop, variables(flex strength) rule(calinski) 

*Create grouping variable for the correct number of variables
cluster generate block = groups(4) 

*--------------------*
*Check Results 
*--------------------*
tabstat flex strength, by(block) stat(min mean max count)

graph twoway (scatter flex strength if block == 1, mcolor(red) mlabel(block)) ///
(scatter flex strength if block== 2, mcolor(blue) mlabel(block)) ///
(scatter flex strength if block == 3, mcolor(green) mlabel(block)) ///
(scatter flex strength if block == 4, mcolor(orange) mlabel(block)) ///
,legend(label( 1 "Block 1") label(2 "Block 2") label(3 "Block 3") label(4 "Block 4")) ///
title("Blocking on Two Baseline Covariates")

*------------------------------------------------------------------------------*
* Randomization
*------------------------------------------------------------------------------*

randomize coaching, by(block) arms(2) seed(3501) 

*------------------------------------------------------------------------------*
* Check Balance 
*------------------------------------------------------------------------------*

balance_check coaching  flex strength speed ///
, blocks(i.strata)  plot(".05 .10 .94 .98") export(practice_randomize)


