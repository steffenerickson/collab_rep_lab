options(warn=1)
msg <- file("/Users/steffenerickson/Desktop/repos/collab_rep_lab/06_replication_paper_updates/twang/output/ps.Rout", open="wt")
sink(msg, type="message")
.libPaths('/Users/steffenerickson/Library/TWANG')
if (!is.element("twang", installed.packages()[,1])) install.packages("twang", repos="http://cran.us.r-project.org")
update.packages(lib.loc="/Users/steffenerickson/Library/TWANG",
repos="http://cran.us.r-project.org",
instlib="/Users/steffenerickson/Library/TWANG",
ask=F,
oldPkgs="twang")
library(twang)
if(compareVersion(installed.packages()['twang','Version'],'1.4-0')== -1){stop('Your version of TWANG is out of date. \n It must version 1.4-0 or later.')}
set.seed(1)

inputds<-read.csv("/Users/steffenerickson/Desktop/repos/collab_rep_lab/06_replication_paper_updates/twang/output/datafile.csv")
ps1 <- ps(treat ~ female + race_wh + hsloc_3 + hsach_3 + hsses_2 + tses_total_c + tmas_total_c + crtse_total_c + tses_cm_c + ccs_gpa_c + score_dc_avg_bs_c + female_im + race_wh_im + hsloc_3_im + hsach_3_im + hsses_2_im + tses_total_im + tmas_total_im + crtse_total_im + tses_cm_im + ccs_gpa_im + score_dc_avg_bs_im,
data = inputds,
n.trees = 10000,
interaction.depth = 2,
shrinkage = .01,
perm.test.iters = 2,
stop.method = c('es.mean'),
estimand = "ATT",
sampw = NULL,
verbose = FALSE
)

baltab<-bal.table(ps1)

w<-as.data.frame(ps1$w)
w$tempID<-as.numeric(row.names(w))
write.table(w,file="/Users/steffenerickson/Desktop/repos/collab_rep_lab/06_replication_paper_updates/twang/output/wts.csv",row.names=FALSE,col.names=TRUE,sep=',')
baltab <- data.frame(do.call(rbind, baltab), table.name=rep(names(baltab), each=nrow(baltab[[1]])))
baltab <- data.frame(row_name=row.names(baltab), baltab)
baltab[baltab==Inf] <- NA
baltab[baltab==(-Inf)] <- NA
write.table(baltab,file="/Users/steffenerickson/Desktop/repos/collab_rep_lab/06_replication_paper_updates/twang/output/baltab.csv",row.names=FALSE,col.names=TRUE,sep=',',na='.')
summ<-as.data.frame(rbind(summary(ps1)))
summ <- data.frame(row_name=row.names(summ), summ)
write.table(summ,file="/Users/steffenerickson/Desktop/repos/collab_rep_lab/06_replication_paper_updates/twang/output/summary.csv",row.names=FALSE,col.names=TRUE,sep=',',na='.')
pdf('/Users/steffenerickson/Desktop/repos/collab_rep_lab/06_replication_paper_updates/twang/output/replication_twang.pdf')
plot(ps1,plots=1, main='Plot 1 (optimize): GBM Optimization')
plot(ps1,plots=2, main='Plot 2 (boxplot): Boxplot of Propensity Scores')
plot(ps1,plots=3, main='Plot 3 (es): Standardized Effect Sizes Pre/Post Weighting')
plot(ps1,plots=4, main='Plot 4 (t): T-test P-values of Group Means of Covariates')
plot(ps1,plots=5, main='Plot 5 (ks): K-S P-values of Group Distns of Covariates')
garbage <- dev.off()
save(ps1, file='/Users/steffenerickson/Desktop/repos/collab_rep_lab/06_replication_paper_updates/twang/output/ps.RData')
