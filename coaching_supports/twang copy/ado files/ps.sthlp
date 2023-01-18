{smcl}
{* *! version 1.1.1  06apr2015}{...}
{vieweralsosee "balance" "help ps postestimation"}{...}
{vieweralsosee "dxwts" "help dxwts"}{...}
{vieweralsosee "psplot" "help psplot"}{...}
{viewerjumpto "Syntax" "ps##syntax"}{...}
{viewerjumpto "Description" "ps##description"}{...}
{viewerjumpto "Options" "ps##options"}{...}
{viewerjumpto "Examples" "ps##examples"}{...}
{viewerjumpto "Online tutorial" "ps##tutorial"}{...}
{viewerjumpto "Stored results" "ps##results"}{...}
{viewerjumpto "References" "ps##references"}{...}
{title:Title}


{p2colset 5 20 22 2}{...}
{p2col :{browse "http://www.rand.org/statistics/twang/tutorials.html":ps} {hline 2}}Estimate propensity scores and associated weights using a Generalized Boosted Model{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt ps} {it:{help varname:treatvar}} {indepvars} [{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt sampw}}{varname} for optional sampling weights {p_end}

{syntab:Estimation}
{synopt :{opt ntrees}}number of GBM iterations; default is {cmd:10000} {p_end}
{synopt :{opt intdepth}}maximum depth of variable interactions; default is {cmd:3} {p_end}
{synopt :{opt shrinkage}}shrinkage parameter applied to each tree in the expansion; default is {cmd:0.01} {p_end}
{synopt :{opt permtestiters}}non-negative integer giving the number of iterations of the permutation test for the KS statistic; default is {cmd:0} {p_end}
{synopt :{opt rcmd}}file name for the Rscript executable {p_end}
{synopt :{opt stopmethod}}method or set of methods for measuring and
          summarizing balance across covariates {p_end}
{synopt :{opt estimand}}causal effect of interest ({cmd:ATE} or {cmd:ATE}); default is {cmd:ATE} {p_end}

{syntab:Reporting}
{synopt :{opt objpath}}folder name for a permanent file of the
          R object with the resulting GBM model fit, a log of
          the R session, and files created by the macro to run
          the estimation{p_end}
{synopt :{opt plotname}}file name for an optional output file of the default
          diagnostic plots {p_end}
{synoptline}
INCLUDE help fvvarlist

{marker description}{...}
{title:Description}

{phang}
{cmd:ps} estimates propensity scores using a Generalized Boosted
     Model and evaluates their quality using covariate balance.
     It implements the ps function in the TWANG package of R.
	 Categorical variables among the {indepvars} need to be
     specified as in factor variables; see {help fvvarlist}. 
	 R, and in particular, the TWANG package in R, can be
     slow and require large amounts of memory to process large datasets.
	 Unless the users has added R to the path environmental variable,
     the full path must be specified in Rcmd. For example for the
     default setup of R Version 3.0.1 on Windows 7, the specification
     is {cmd:rcmd(C:/Program Files/R/R-3.0.1/bin/x64/Rscript.exe)}. The value 3.0.1 in the example would be replaced by the current
     version number at the time R was installed. For Mac and Unix users, {cmd:rmcd} is optional.

{phang} User must place all package files in a location that will be recognized by Stata. This can be acheived
by placing the files in the PERSONAL ado-path directory, which can be identified using {help adopath}. Alternately, the user
can place the files in any directory, and add the directory to ado-path using the command {help adopath} {cmd:+} {it:path_or_directory}.
	 
{phang} TWANG is a package of functions in the R Environment for
Statistical Computing and Graphics. The package contains functions
for estimating propensity scores and associated weights using
Generalized Boosting Model and functions for assessing the
covariate balance provided by the resulting weights. {cmd:ps} implements the functions in the R
package by creating an R script file and running it in R batch mode
and then porting the results back to Stata. To use {cmd:ps} a user must have R installed on his or her computer. 

{phang} R is standalone freeware that users can download and install from
The Comprehensive R Archive Network (http://cran.us.r-project.org/).
The software can be installed by clicking on the link for the users
computer platform (e.g., Windows users would click on "Download R
for Windows" and then click on the "base" link to download the
standard R software). Windows users will need to note the directory where the R software is
installed and the name of the executable file. For Windows users
the directory information for the standard installment is "C:\Program Files\R\R-3.0.2\bin\x64"
where 3.0.2 is replaced by the current version of R at the time of
installation. The executable is Rscript.exe for batch implementation.

{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opth sampw(varname)} specifies the optional sampling weights.

{dlgtab:Estimation}

{phang}
{opt ntrees(#)} specifies the number of gbm iterations passed on to 'gbm' in R; a positive integer. Default is {cmd:10000}.

{phang}		  
{opt intdepth(#)} specifies the maximum depth of variable interactions; a positive integer. {cmd:1} implies an additive model, {cmd:2} implies a model with up to 2-way interactions, etc. The default is {cmd:3}.

{phang}
{opt shrinkage(#)} specifies a shrinkage parameter applied to each tree in the gbm expansion. Also known as the learning rate or step-size reduction. The default is {cmd:0.01}.

{phang}
{opt permtestiters(#)} specifies the number of
          iterations of the permutation test for the KS statistic; a non-negative integer.
          {cmd:permtestiters(0)} specifies that {cmd:ps} returns an
          analytic approximation to the p-value. 
          {cmd:permtestiters(200)} yields precision to within {cmd:3%} if
          the true p-value is {cmd:0.05}. Use {cmd:permtestiters(500)} to be
          within {cmd:2%}. The default is {cmd:0}.

{phang}
{opth rcmd(filename)} specifies the file name for the R executable. Defaults to {cmd:Rscript} in Mac OSX and UNIX.

{phang}
{opth stopmethod(strings)} specifies a method or set of methods for measuring and
          summarizing balance across covariates. Current options are
          {cmd:ks.mean}, {cmd:ks.max}, {cmd:es.mean}, and {cmd:es.max}. {cmd:ks} refers
          to the Kolmogorov-Smirnov statistic and {cmd:es} refers to
          standardized effect size (also called standardized bias or
          standardized differences). These are summarized across
          covariates by either the maximum ({cmd:.max}) or the mean
          ({cmd:.mean}). Multiple stopping rules can be requested. List
          the option name for all methods of interest separated by a space.

{phang}
{opth estimand(strings)} specifies the causal effect of interest. Options are {cmd:ATE} (average
          treatment effect), which attempts to estimate the change in
          the outcome if the treatment were applied to the entire
          population versus if the control were applied to the entire
          population, or {cmd:ATT} (average treatment effect on the
          treated), which attempts to estimate the analogous effect,
          averaging only over the treated population. The default
          is {cmd:ATE}.


{dlgtab:Reporting}

{phang}
{opth objpath(strings)} specifies the folder name for a file of the
          R object with the resulting GBM model fit, a log of
          the R session, and files created by {cmd:ps} to run
          the estimation. {cmd:ps} also writes an R script file "ps.r" to
     the folder specified by {cmd:objpath}. It then runs the R script which produces temporary
     files: wgt.csv, baltab.csv, and summary.csv in the {cmd:objpath} folder.
     These are read into Stata and used to produce the final output. The
     macro also creates a temporary file ps.Rout which is log of the R
     run.

{phang}
{opth plotname(filename)} specifies the file name for an optional output file of the default
          diagnostic plots. The full path can be given. If not, the plot file is placed in the folder specified by {cmd:objpath}.

{marker examples}{...}
{title:Examples:  estimating propensity scores using GBM}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}

{pstd}Fit a GBM model for the propensity of being foreign on a Mac running OS-X{p_end}
{phang2}{cmd:. ps foreign weight mpg i.rep78, stopmethod(es.mean ks.max) objpath(~/Documents/temp)}{p_end}

{pstd}Fit a GBM model for the propensity of being foreign in Windows {p_end}
{phang2}{cmd:. ps foreign weight mpg i.rep78, stopmethod(es.mean ks.max) rcmd("C:/Program Files/R/R-3.0.1/bin/x64/Rscript.exe") objpath(C:/temp)}{p_end}

{pstd}Summarize weights and balance{p_end}
{phang2}{cmd:. balance, summary}{p_end}

{pstd}Summarize balance of covariates before weighting{p_end}
{phang2}{cmd:. balance, unweighted}{p_end}

{pstd}Summarize balance of covariates after weighting{p_end}
{phang2}{cmd:. balance, weighted}{p_end}

{pstd}Generate a plot of the balance criteria as a function of the GBM iteration{p_end}
{phang2}{cmd:. psplot, plotname(balance_vs_gbm.pdf) plots(1)}{p_end}

{pstd}Generate boxplots of the propensity scores by treatment group{p_end}
{phang2}{cmd:. psplot, plotname(PSboxplots.pdf) plots(boxplot)}{p_end}

{pstd}Perform a weighted outcome regression using es.mean weights {p_end}
{phang2}{cmd:. svyset [pw=esmeanate]}{p_end}
{phang2}{cmd:. svy: regress price foreign weight mpg i.rep78}{p_end}

{marker tutorial}{...}
{title:Online tutorial}

{phang}
{browse "http://www.rand.org/statistics/twang/tutorials.html":Toolkit for Weighting and Analysis of Nonequivalent Groups}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ps} generates a new variable containing the weights corresponding to each stopping rule specified by the user. The {help varname} of these variables is determined by 
appending the {cmd: estimand} to the end of each {cmd: stopmethod}. For example, specifying {cmd:estimand(ATE)} and {cmd:stopmethod(es.mean es.max)}
will create the weight variables named {cmd:esmeanate} and {cmd:esmaxate}. These can then be used to perform a weighted analysis.

{pstd}
{cmd:ps} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:ps}{p_end}


{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(es.max)}}contains the data on the balance of the covariates
                after weighting for weights generated by {cmd:es.max} stopping rule {p_end}
{synopt:{cmd:e(es.mean)}}contains the data on the balance of the covariates
                after weighting for weights generated by {cmd:es.mean} stopping rule{p_end}
{synopt:{cmd:e(ks.max)}}contains the data on the balance of the covariates
                after weighting for weights generated by {cmd:ks.max} stopping rule{p_end}
{synopt:{cmd:e(ks.mean)}}contains the data on the balance of the covariates
                after weighting for weights generated by {cmd:ks.mean} stopping rule{p_end}
{synopt:{cmd:e(unw)}}contains the data on the balance of the covariates
               before weighting. probably need to add another section describing this matrix {p_end}
{synopt:{cmd:e(summary)}}contains the data summarizing the weights and
               the covariate balance.  The matrix contains
               one row for unweighted data and a row for
               the weights corresponding to each of the
               stopping rules the user specified. {p_end}

{p2colreset}{...}


{marker references}{...}
{title:References}

{phang}
McCaffrey, D., G. Ridgeway, and A. Morral. 2004. Propensity score estimation with boosted regression for evaluating causal effects in
observational studies. {it:Psychological Methods} 9(4):403�425.
{p_end}

{phang} 
Ridgeway, G., D. McCaffrey, A. Morral, L. Burgette, B. A. Griffin. 2013. Toolkit for Weighting and Analysis of Nonequivalent Groups: A Tutorial for the Twang Package. R package.
{p_end}


