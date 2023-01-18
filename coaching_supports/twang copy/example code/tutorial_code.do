/*install ado files*/
adopath + "C:\Users\uname\adofile"

/*section 2.2-2.3 estimating propensity scores with ps and assessing balance using balance table*/

*read in lalonde
use "C:\Users\uname\twang\lalonde.dta", clear

*ps 
ps treat age educ black hispan married nodegree re74 re75, ///
   ntrees(5000) intdepth(2) shrinkage(0.01) ///
   permtestiters(0) stopmethod(es.mean ks.max) estimand(ATT) ///
   rcmd(C:\Program Files\R\R-3.0.3\bin\Rscript.exe) ///
   objpath(C:\Users\uname\twang\output) ///
   plotname(C:\Users\uname\twang\output\lalonde_twang.pdf)

balance, summary unweighted weighted  
cd "C:\Users\uname\twang\output" 
save lalonde_att_wgts, replace

*psplot (figure1)
psplot, ///
inputobj(C:\Users\uname\twang\output\ps.RData) ///
plotname(lalonde_opt.pdf) plotformat(pdf) ///
plots(1) ///
rcmd(C:\Program Files\R\R-3.0.3\bin\Rscript.exe) ///
objpath(C:\Users\uname\twang\output)

*psplot with subset (figure2)
psplot, ///
inputobj(C:\Users\uname\twang\output\ps.RData) ///
plotname(lalonde_opt_ks.pdf) plotformat(pdf) ///
plots(1) subset(2) ///
rcmd(C:\Program Files\R\R-3.0.3\bin\Rscript.exe) ///
objpath(C:\Users\uname\twang\output)


/*section 2.4 graphical assessments of balance*/
*psplot:boxplot (figure3)
psplot, ///
inputobj(C:\Users\uname\twang\output\ps.RData) ///
plotname(lalonde_box.pdf) plotformat(pdf) ///
plots(2) ///
rcmd(C:\Program Files\R\R-3.0.3\bin\Rscript.exe) ///
objpath(C:\Users\uname\twang\output)

*psplot:effect size (figure4)
psplot, ///
inputobj(C:\Users\uname\twang\output\ps.RData) ///
plotname(lalonde_es.pdf) plotformat(pdf) ///
plots(3) ///
rcmd(C:\Program Files\R\R-3.0.3\bin\Rscript.exe) ///
objpath(C:\Users\uname\twang\output)

*psplot:t-test p-value(figure5)
psplot, ///
inputobj(C:\Users\uname\twang\output\ps.RData) ///
plotname(lalonde_p.pdf) plotformat(pdf) ///
plots(4) ///
rcmd(C:\Program Files\R\R-3.0.3\bin\Rscript.exe) ///
objpath(C:\Users\uname\twang\output)

*psplot:ks test p-value(figure6)
psplot, ///
inputobj(C:\Users\uname\twang\output\ps.RData) ///
plotname(lalonde_ks.pdf) plotformat(pdf) ///
plots(5) ///
rcmd(C:\Program Files\R\R-3.0.3\bin\Rscript.exe) ///
objpath(C:\Users\uname\twang\output)

/*section 2.5 Anlysis of outcomes*/
use lalonde_att_wgts, clear
svyset [pweight=esmeanatt]
svy: regress re78 treat
svy: regress re78 treat nodegree 
svy: regress re78 treat age educ black hispan nodegree married re74 re75 

/*section 2.6 estimate program effect using linear regression*/
use "C:\Users\uname\twang\lalonde.dta", clear
regress re78 treat age educ black hispan nodegree married re74 re75 

/*section 2.7 propensity scores estimated from logistic regression*/
logit treat age educ black hispan nodegree married re74 re75 
predict phat
gen w_logit_att=treat+(1-treat)*phat/(1-phat)

dxwts treat age educ black hispan nodegree married re74 re75, ///
weightvars(w_logit_att) estimand(ATT) permtestiters(0) ///
rcmd(C:\Program Files\R\R-3.0.3\bin\Rscript.exe) ///
objpath(C:\Users\uname\twang\output)

balance, summary unweighted weighted 

svyset [pweight=w_logit_att]
svy: regress re78 treat

/*section 3 an ATE exapmle*/
use "C:\Users\uname\twang\lindner.dta", clear
tab sixmonthsurvive abcix,chi2 lrchi2 V cell row column

ps abcix stent height female diabetic acutemi ejecfrac ves1proc, ///
   stopmethod(es.mean ks.mean) estimand(ATE) ///
   rcmd(C:\Program Files\R\R-3.0.3\bin\Rscript.exe) ///
   objpath(C:\Users\uname\twang\output) ///
   plotname(C:\Users\uname\twang\output\abcix_twang.pdf)

balance, unweighted weighted
balance, summary

svyset [pweight=esmeanate]
svy: tab sixmonthsurvive abcix, obs count se
svy: tab sixmonthsurvive abcix, cell se
svy: tab sixmonthsurvive abcix, col se
gen sixmonthsurv = 0
replace sixmonthsurv = 1 if sixmonthsurvive=="TRUE"
svy: logistic sixmonthsurv abcix

/*section 4 Non-response weights*/
*generate nonresponse weights
use "C:\Users\uname\twang\egsingle.dta", clear

bysort childid: egen sum=sum(grade)
gen resp=1 if sum==10|sum==15
replace resp=0 if resp !=1

duplicates drop childid,force   
tab1 resp race  

ps resp i.race female size lowinc mobility, ///
   stopmethod(es.mean ks.max) estimand(ATE) ntrees(5000) ///
   rcmd(C:\Program Files\R\R-3.0.3\bin\Rscript.exe) ///
   objpath(C:\Users\uname\twang\output) ///
   plotname(C:\Users\uname\twang\output\egsingle_twang.pdf)

balance, unweighted weighted
cd "C:\Users\uname\twang\output"
save _inputds, replace

*compare the weighted respondents to the unweighted full sample
use _inputds, clear
keep childid ksmaxate resp
sort childid
save _inputds, replace

use "C:\Users\uname\twang\egsingle.dta", clear 
duplicates drop childid,force
sort childid
save egsingle, replace

merge childid using _inputds
rename ksmaxate wgt
keep if resp==1
save egsingle_nrespwt, replace

use egsingle_nrespwt, clear
append using egsingle, gen(nr2)
gen wgt2=1 if nr2==1
replace wgt2=wgt if nr2==0

dxwts nr2 i.race female size lowinc mobility, ///
weightvars(wgt2) estimand(ATT) permtestiters(0) ///
rcmd(C:\Program Files\R\R-3.0.3\bin\Rscript.exe) ///
objpath(C:\Users\uname\twang\output)

balance, weighted 

*create analysis file
use "C:\Users\uname\twang\egsingle.dta", clear 
sort childid
save egsingle, replace

use egsingle_nrespwt, clear
sort childid
keep childid wgt 
merge childid using egsingle
keep if _merge==3
sort childid grade
save egsingle_analysis, replace

