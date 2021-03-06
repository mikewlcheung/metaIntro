# Examples of three-level meta-analysis
Mike Cheung  
`r format(Sys.time(), '%d %B, %Y')`  



# Introduction
* This file illustrates how to conduct three-level meta-analyses using the [metaSEM](http://courses.nus.edu.sg/course/psycwlm/internet/metaSEM) and [OpenMx](http://openmx.psyc.virginia.edu/) packages available in the [R](http://www.r-project.org/) environment. The `metaSEM` package was written to simplify the procedures to conduct meta-analysis. Most readers may only need to use the `metaSEM` package to conduct the analysis. The next section shows how to conduct two- and three-level meta-analyses with the `meta()` and `meta3()` functions. The third section demonstrates more complicated three-level meta-analyses using a dataset with more predictors. The final section shows how to implement three-level meta-analyses as structural equation models using the `OpenMx` package. It provides detailed steps on how three-level meta-analyses can be formulated as structural equation models.

* This file also demonstrates the advantages of using the SEM approach to conduct three-level meta-analyses. These include flexibility on imposing constraints for model comparisons and construction of likelihood-based confidence interval (LBCI). I also demonstrate how to conduct three-level meta-analysis with restricted (or residual) maximum likelihood (REML) using the `reml3()` function and handling missing covariates with full information maximum likelihood (FIML) using the `meta3X()` function. Readers may refer to Cheung (2015) for the design and implementation of the `metaSEM` package and Cheung (2014) for the theory and issues on how to formulate three-level meta-analyses as structural equation models. 

* Two datasets from published meta-analyses were used in the illustrations. The first dataset was based on Cooper et al. (2003) and Konstantopoulos (2011). Konstantopoulos (2011) selected part of the dataset to illustrate how to conduct three-level meta-analysis. The second dataset was reported by Bornmann et al. (2007) and Marsh et al. (2009). They conducted a three-level meta-analysis on gender effects in peer reviews of grant proposals. 

## Comparisons between two- and three-level models with Cooper et al.'s (2003) dataset
As an illustration, I first conduct the tradition (two-level) meta-analysis using the `meta()` function. Then I conduct a three-level meta-analysis using the `meta3()` function. We may compare the similarities and differences between these two sets of results. 

### Inspecting the data
Before running the analyses, we need to load the `metaSEM` library. The datasets are stored in the library. It is always a good idea to inspect the data before the analyses. We may display the first few cases of the dataset by using the `head()` command. 

```r
#### Cooper et al. (2003)
library("metaSEM")

head(Cooper03)
```

```
  District Study     y     v Year
1       11     1 -0.18 0.118 1976
2       11     2 -0.22 0.118 1976
3       11     3  0.23 0.144 1976
4       11     4 -0.30 0.144 1976
5       12     5  0.13 0.014 1989
6       12     6 -0.26 0.014 1989
```

### Two-level meta-analysis
Similar to other `R` packages, we may use `summary()` to extract the results after running the analyses. I first conduct a random-effects meta-analysis and then a fixed- and mixed-effects meta-analyses.

* Random-effects model
The _Q_ statistic on testing the homogeneity of effect sizes was $578.86, df = 55, p < .001$. The estimated heterogeneity $\tau^2$ (labeled `Tau2_1_1` in the output) and $I^2$ were 0.0866 and 0.9459, respectively. This indicates that the between-study effect explains about 95% of the total variation. The average population effect (labeled `Intercept1` in the output; and its 95% Wald CI) was 0.1280 (0.0428, 0.2132).

```r
#### Two-level meta-analysis

## Random-effects model  
summary( meta(y=y, v=v, data=Cooper03) )
```

```

Call:
meta(y = y, v = v, data = Cooper03)

95% confidence intervals: z statistic approximation
Coefficients:
           Estimate Std.Error   lbound   ubound z value  Pr(>|z|)    
Intercept1 0.128003  0.043472 0.042799 0.213207  2.9445  0.003235 ** 
Tau2_1_1   0.086537  0.019485 0.048346 0.124728  4.4411 8.949e-06 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Q statistic on the homogeneity of effect sizes: 578.864
Degrees of freedom of the Q statistic: 55
P value of the Q statistic: 0

Heterogeneity indices (based on the estimated Tau2):
                             Estimate
Intercept1: I2 (Q statistic)   0.9459

Number of studies (or clusters): 56
Number of observed statistics: 56
Number of estimated parameters: 2
Degrees of freedom: 54
-2 log likelihood: 33.2919 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```

* Fixed-effects model
A fixed-effects meta-analysis can be conducted by fixing the heterogeneity of the random effects at 0 with the `RE.constraints` argument (random-effects constraints). The estimated common effect (and its 95% Wald CI) was 0.0464 (0.0284, 0.0644).

```r
## Fixed-effects model
summary( meta(y=y, v=v, data=Cooper03, RE.constraints=0) )
```

```

Call:
meta(y = y, v = v, data = Cooper03, RE.constraints = 0)

95% confidence intervals: z statistic approximation
Coefficients:
            Estimate Std.Error    lbound    ubound z value Pr(>|z|)    
Intercept1 0.0464072 0.0091897 0.0283957 0.0644186  5.0499 4.42e-07 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Q statistic on the homogeneity of effect sizes: 578.864
Degrees of freedom of the Q statistic: 55
P value of the Q statistic: 0

Heterogeneity indices (based on the estimated Tau2):
                             Estimate
Intercept1: I2 (Q statistic)        0

Number of studies (or clusters): 56
Number of observed statistics: 56
Number of estimated parameters: 1
Degrees of freedom: 55
-2 log likelihood: 434.2075 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```

* Mixed-effects model
`Year` was used as a covariate. It is easier to interpret the intercept by centering the `Year` with `scale(Year, scale=FALSE)`. The `scale=FALSE` argument means that it is centered, but not standardized. The estimated regression coefficient (labeled `Slope1_1` in the output; and its 95% Wald CI) was 0.0051 (-0.0033, 0.0136) which is not significant at $\alpha=.05$. The $R^2$ is 0.0164. 

```r
## Mixed-effects model
summary( meta(y=y, v=v, x=scale(Year, scale=FALSE), data=Cooper03) )
```

```

Call:
meta(y = y, v = v, x = scale(Year, scale = FALSE), data = Cooper03)

95% confidence intervals: z statistic approximation
Coefficients:
             Estimate  Std.Error     lbound     ubound z value  Pr(>|z|)
Intercept1  0.1259126  0.0432028  0.0412367  0.2105884  2.9145  0.003563
Slope1_1    0.0051307  0.0043248 -0.0033457  0.0136071  1.1864  0.235483
Tau2_1_1    0.0851153  0.0190462  0.0477856  0.1224451  4.4689 7.862e-06
              
Intercept1 ** 
Slope1_1      
Tau2_1_1   ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Q statistic on the homogeneity of effect sizes: 578.864
Degrees of freedom of the Q statistic: 55
P value of the Q statistic: 0

Explained variances (R2):
                           y1
Tau2 (no predictor)    0.0865
Tau2 (with predictors) 0.0851
R2                     0.0164

Number of studies (or clusters): 56
Number of observed statistics: 56
Number of estimated parameters: 3
Degrees of freedom: 53
-2 log likelihood: 31.88635 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```

### Three-level meta-analysis
* Random-effects model
The _Q_ statistic on testing the homogeneity of effect sizes was the same as that under the two-level meta-analysis. The estimated heterogeneity at level 2 $\tau^2_{(2)}$ (labeled `Tau2_2` in the output) and at level 3 $\tau^2_{(3)}$ (labeled `Tau2_3` in the output) were 0.0329 and 0.0577, respectively. The level 2 $I^2_{(2)}$ (labeled `I2_2` in the output) and the level 3 $I^2_{(3)}$ (labeled `I2_3` in the output) were 0.3440 and 0.6043, respectively. Schools (level 2) and districts (level 3) explain about 34% and 60% of the total variation, respectively. The average population effect (and its 95% Wald CI) was 0.1845 (0.0266, 0.3423).

```r
#### Three-level meta-analysis
## Random-effects model
summary( meta3(y=y, v=v, cluster=District, data=Cooper03) )
```

```

Call:
meta3(y = y, v = v, cluster = District, data = Cooper03)

95% confidence intervals: z statistic approximation
Coefficients:
            Estimate  Std.Error     lbound     ubound z value Pr(>|z|)   
Intercept  0.1844554  0.0805411  0.0265977  0.3423130  2.2902 0.022010 * 
Tau2_2     0.0328648  0.0111397  0.0110314  0.0546982  2.9502 0.003175 **
Tau2_3     0.0577384  0.0307423 -0.0025154  0.1179921  1.8781 0.060362 . 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Q statistic on the homogeneity of effect sizes: 578.864
Degrees of freedom of the Q statistic: 55
P value of the Q statistic: 0

Heterogeneity indices (based on the estimated Tau2):
                              Estimate
I2_2 (Typical v: Q statistic)   0.3440
I2_3 (Typical v: Q statistic)   0.6043

Number of studies (or clusters): 11
Number of observed statistics: 56
Number of estimated parameters: 3
Degrees of freedom: 53
-2 log likelihood: 16.78987 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```

* Mixed-effects model
`Year` was used as a covariate. The estimated regression coefficient (labeled `Slope_1` in the output; and its 95% Wald CI) was 0.0051 (-0.0116, 0.0218) which is not significant at $\alpha=.05$. The estimated level 2 $R^2_{(2)}$ and level 3 $R^2_{(3)}$ were 0.0000 and 0.0221, respectively.

```r
## Mixed-effects model
summary( meta3(y=y, v=v, cluster=District, x=scale(Year, scale=FALSE), 
               data=Cooper03) )
```

```

Call:
meta3(y = y, v = v, cluster = District, x = scale(Year, scale = FALSE), 
    data = Cooper03)

95% confidence intervals: z statistic approximation
Coefficients:
            Estimate  Std.Error     lbound     ubound z value Pr(>|z|)   
Intercept  0.1780268  0.0805219  0.0202067  0.3358469  2.2109 0.027042 * 
Slope_1    0.0050737  0.0085266 -0.0116382  0.0217856  0.5950 0.551814   
Tau2_2     0.0329390  0.0111620  0.0110618  0.0548162  2.9510 0.003168 **
Tau2_3     0.0564628  0.0300330 -0.0024007  0.1153264  1.8800 0.060104 . 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Q statistic on the homogeneity of effect sizes: 578.864
Degrees of freedom of the Q statistic: 55
P value of the Q statistic: 0

Explained variances (R2):
                        Level 2 Level 3
Tau2 (no predictor)    0.032865  0.0577
Tau2 (with predictors) 0.032939  0.0565
R2                     0.000000  0.0221

Number of studies (or clusters): 11
Number of observed statistics: 56
Number of estimated parameters: 4
Degrees of freedom: 52
-2 log likelihood: 16.43629 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```

* Model comparisons
Many research hypotheses involve model comparisons among nested models. `anova()`, a generic function to comparing nested models, may be used to conduct a likelihood ratio test which is also known as a chi-square difference test.

* Testing $H_0: \tau^2_{(3)} = 0$
    + Based on the data structure, it is clear that a 3-level meta-analysis is preferred to a traditional 2-level meta-analysis. It is still of interest to test whether the 3-level model is statistically better than the 2-level model by testing $H_0: \tau^2_{(3)}=0$. Since the models with $\tau^2_{(3)}$ being freely estimated and with $\tau^2_{(3)}=0$ are nested, we may compare them by the use of a likelihood ratio test. 
    + It should be noted, however, that $H_0: \tau^2_{(3)}=0$ is tested on the boundary. The likelihood ratio test is not distributed as a chi-square variate with 1 _df_. A simple strategy to correct this bias is to reject the null hypothesis when the observed _p_ value is larger than .10 for $\alpha=.05$.
    + The likelihood-ratio test was 16.5020 (_df_ =1), _p_ < .001. This clearly demonstrates that the three-level model is statistically better than the two-level model.

```r
## Model comparisons
  
model2 <- meta(y=y, v=v, data=Cooper03, model.name="2 level model", silent=TRUE) 
#### An equivalent model by fixing tau2 at level 3=0 in meta3()
## model2 <- meta3(y=y, v=v, cluster=District, data=Cooper03, 
##                 model.name="2 level model", RE3.constraints=0) 
model3 <- meta3(y=y, v=v, cluster=District, data=Cooper03, 
                model.name="3 level model", silent=TRUE) 
anova(model3, model2)
```

```
           base    comparison ep minus2LL df       AIC   diffLL diffdf
1 3 level model          <NA>  3 16.78987 53 -89.21013       NA     NA
2 3 level model 2 level model  2 33.29190 54 -74.70810 16.50203      1
             p
1           NA
2 4.859793e-05
```

* Testing $H_0: \tau^2_{(2)} = \tau^2_{(3)}$
    + From the results of the 3-level random-effects meta-analysis, it appears the level 3 heterogeneity is much larger than that at level 2. 
    + We may test the null hypothesis $H_0: \tau^2_{(2)} = \tau^2_{(3)}$ by the use of a likelihood-ratio test.
    + We may impose an equality constraint on $\tau^2_{(2)} = \tau^2_{(3)}$ by using the same label in `meta3()`. For example, `Eq_tau2` is used as the label in `RE2.constraints` and `RE3.constraints` meaning that both the level 2 and level 3 random effects heterogeneity variances are constrained equally. The value of `0.1` was used as the starting value in the constraints. 
    + The likelihood-ratio test was 0.6871 (_df_ = 1), _p_ = 0.4072. This indicates that there is not enough evidence to reject $H_0: \tau^2_2=\tau^2_3$.

```r
## Testing \tau^2_2 = \tau^2_3
modelEqTau2 <- meta3(y=y, v=v, cluster=District, data=Cooper03, 
                     model.name="Equal tau2 at both levels",
                     RE2.constraints="0.1*Eq_tau2", RE3.constraints="0.1*Eq_tau2") 
anova(model3, modelEqTau2)
```

```
           base                comparison ep minus2LL df       AIC
1 3 level model                      <NA>  3 16.78987 53 -89.21013
2 3 level model Equal tau2 at both levels  2 17.47697 54 -90.52303
     diffLL diffdf         p
1        NA     NA        NA
2 0.6870959      1 0.4071539
```

* Likelihood-based confidence interval
    + A Wald CI is constructed by $\hat{\theta} \pm 1.96 SE$ where $\hat{\theta}$ and $SE$ are the parameter estimate and its estimated standard error. 
    + A LBCI can be constructed by the use of the likelihood ratio statistic (e.g., Cheung, 2009; Neal & Miller, 1997).  
    + It is well known that the performance of Wald CI on variance components is very poor. For example, the 95% Wald CI on $\hat{\tau}^2_{(3)}$ in the three-level random-effects meta-analysis was (-0.0025, 0.1180). The lower bound falls outside 0. 
    + A LBCI on the heterogeneity variance is preferred. Since $I^2_{(2)}$ and $I^2_{(3)}$ are functions of $\tau^2_{(2)}$ and $\tau^2_{(3)}$, LBCI on these indices may also be requested and used to indicate the precision of these indices. 
    + LBCI may be requested by specifying `LB` in the `intervals.type` argument. 
    + The 95% LBCI on $\hat{\tau}^2_{(3)}$ is (0.0198, 0.1763) that stay inside the meaningful boundaries. Regarding the $I^2$, the 95% LBCIs on $I^2_{(2)}$ and $I^2_{(3)}$ were (0.1274, 0.6573) and (0.2794, 0.8454), respectively.

```r
## LBCI for random-effects model
summary( meta3(y=y, v=v, cluster=District, data=Cooper03, 
               I2=c("I2q", "ICC"), intervals.type="LB") ) 
```

```

Call:
meta3(y = y, v = v, cluster = District, data = Cooper03, intervals.type = "LB", 
    I2 = c("I2q", "ICC"))

95% confidence intervals: Likelihood-based statistic
Coefficients:
          Estimate Std.Error   lbound   ubound z value Pr(>|z|)
Intercept 0.184455        NA 0.012023 0.358179      NA       NA
Tau2_2    0.032865        NA 0.016331 0.060489      NA       NA
Tau2_3    0.057738        NA 0.019809 0.118621      NA       NA

Q statistic on the homogeneity of effect sizes: 578.864
Degrees of freedom of the Q statistic: 55
P value of the Q statistic: 0

Heterogeneity indices (I2) and their 95% likelihood-based CIs:
                               lbound Estimate ubound
I2_2 (Typical v: Q statistic) 0.12755  0.34396 0.6565
ICC_2 (tau^2/(tau^2+tau^3))   0.13123  0.36273 0.7005
I2_3 (Typical v: Q statistic) 0.34963  0.60429 0.8451
ICC_3 (tau^3/(tau^2+tau^3))   0.29948  0.63727 0.8688

Number of studies (or clusters): 11
Number of observed statistics: 56
Number of estimated parameters: 3
Degrees of freedom: 53
-2 log likelihood: 16.78987 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```

```r
## LBCI for mixed-effects model
summary( meta3(y=y, v=v, cluster=District, x=scale(Year, scale=FALSE), 
               data=Cooper03, intervals.type="LB") ) 
```

```

Call:
meta3(y = y, v = v, cluster = District, x = scale(Year, scale = FALSE), 
    data = Cooper03, intervals.type = "LB")

95% confidence intervals: Likelihood-based statistic
Coefficients:
            Estimate Std.Error     lbound     ubound z value Pr(>|z|)
Intercept  0.1780268        NA  0.0056465  0.3512068      NA       NA
Slope_1    0.0050737        NA -0.0128322  0.0237972      NA       NA
Tau2_2     0.0329390        NA  0.0163748  0.0592996      NA       NA
Tau2_3     0.0564628        NA  0.0192352  0.0999774      NA       NA

Q statistic on the homogeneity of effect sizes: 578.864
Degrees of freedom of the Q statistic: 55
P value of the Q statistic: 0

Explained variances (R2):
                        Level 2 Level 3
Tau2 (no predictor)    0.032865  0.0577
Tau2 (with predictors) 0.032939  0.0565
R2                     0.000000  0.0221

Number of studies (or clusters): 11
Number of observed statistics: 56
Number of estimated parameters: 4
Degrees of freedom: 52
-2 log likelihood: 16.43629 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```

* Restricted maximum likelihood estimation
    + REML may also be used in three-level meta-analysis. The parameter estimates for $\tau^2_{(2)}$ and $\tau^2_{(3)}$ were 0.0327 and 0.0651, respectively.

```r
## REML
summary( reml1 <- reml3(y=y, v=v, cluster=District, data=Cooper03) )
```

```

Call:
reml3(y = y, v = v, cluster = District, data = Cooper03)

95% confidence intervals: z statistic approximation
Coefficients:
         Estimate  Std.Error     lbound     ubound z value Pr(>|z|)   
Tau2_2  0.0327365  0.0110922  0.0109963  0.0544768  2.9513 0.003164 **
Tau2_3  0.0650619  0.0355102 -0.0045368  0.1346607  1.8322 0.066921 . 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Number of studies (or clusters): 56
Number of observed statistics: 55
Number of estimated parameters: 2
Degrees of freedom: 53
-2 log likelihood: -81.14044 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```
* We may impose an equality constraint on $\tau^2_{(2)}$ and $\tau^2_{(3)}$ and test whether this constraint is statistically significant. The estimated value for $\tau^2_{(2)}=\tau^2_{(3)}$ was 0.0404. When this model is compared against the unconstrained model, the test statistic was 1.0033 (_df_ = 1), _p_ = .3165, which is not significant.  

```r
summary( reml0 <- reml3(y=y, v=v, cluster=District, data=Cooper03,
                        RE.equal=TRUE, model.name="Equal Tau2") )
```

```

Call:
reml3(y = y, v = v, cluster = District, data = Cooper03, RE.equal = TRUE, 
    model.name = "Equal Tau2")

95% confidence intervals: z statistic approximation
Coefficients:
     Estimate Std.Error   lbound   ubound z value  Pr(>|z|)    
Tau2 0.040418  0.010290 0.020249 0.060587  3.9277 8.576e-05 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Number of studies (or clusters): 56
Number of observed statistics: 55
Number of estimated parameters: 1
Degrees of freedom: 54
-2 log likelihood: -80.1371 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```

```r
anova(reml1, reml0)
```

```
                          base comparison ep  minus2LL df AIC   diffLL
1 Variance component with REML       <NA>  2 -81.14044 -2  NA       NA
2 Variance component with REML Equal Tau2  1 -80.13710 -1  NA 1.003336
  diffdf         p
1     NA        NA
2      1 0.3165046
```
* We may also estimate the residual heterogeneity after controlling for the covariate. The estimated residual heterogeneity for $\tau^2_{(2)}$ and $\tau^2_{(3)}$ were 0.0327 and 0.0723, respectively.

```r
summary( reml3(y=y, v=v, cluster=District, x=scale(Year, scale=FALSE),
               data=Cooper03) )
```

```

Call:
reml3(y = y, v = v, cluster = District, x = scale(Year, scale = FALSE), 
    data = Cooper03)

95% confidence intervals: z statistic approximation
Coefficients:
         Estimate  Std.Error     lbound     ubound z value Pr(>|z|)   
Tau2_2  0.0326502  0.0110529  0.0109870  0.0543134  2.9540 0.003137 **
Tau2_3  0.0722656  0.0405349 -0.0071813  0.1517125  1.7828 0.074619 . 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Number of studies (or clusters): 56
Number of observed statistics: 54
Number of estimated parameters: 2
Degrees of freedom: 52
-2 log likelihood: -72.09405 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```

# More complex 3-level meta-analyses with Bornmann et al.'s (2007) dataset
This section replicates the findings in Table 3 of Marsh et al. (2009). Several additional analyses on model comparisons were conducted. Missing data were artificially introduced to illustrate how missing data might be handled with FIML.

## Inspecting the data
The effect size and its sampling variance are `logOR` (log of the odds ratio) and `v`, respectively. `Cluster` is the variable representing the cluster effect, whereas the potential covariates are `Year` (year of publication), `Type` (`Grants` vs. `Fellowship`), `Discipline` (`Physical sciences`, `Life sciences/biology`, `Social sciences/humanities` and `Multidisciplinary`) and `Country` (`United States`, `Canada`, `Australia`, `United Kingdom` and `Europe`).


```r
#### Bornmann et al. (2007)
head(Bornmann07)
```

```
  Id                       Study Cluster    logOR          v Year
1  1 Ackers (2000a; Marie Curie)       1 -0.40108 0.01391692 1996
2  2 Ackers (2000b; Marie Curie)       1 -0.05727 0.03428793 1996
3  3 Ackers (2000c; Marie Curie)       1 -0.29852 0.03391122 1996
4  4 Ackers (2000d; Marie Curie)       1  0.36094 0.03404025 1996
5  5 Ackers (2000e; Marie Curie)       1 -0.33336 0.01282103 1996
6  6 Ackers (2000f; Marie Curie)       1 -0.07173 0.01361189 1996
        Type                 Discipline Country
1 Fellowship          Physical sciences  Europe
2 Fellowship          Physical sciences  Europe
3 Fellowship          Physical sciences  Europe
4 Fellowship          Physical sciences  Europe
5 Fellowship Social sciences/humanities  Europe
6 Fellowship          Physical sciences  Europe
```

## Model 0: Intercept
The _Q_ statistic was 221.2809 (_df_ = 65), _p_ < .001. The estimated average effect (and its 95% Wald CI) was -0.1008 (-0.1794, -0.0221). The $\hat{\tau}^2_{(2)}$ and $\hat{\tau}^3_{(3)}$ were 0.0038 and 0.0141, respectively. The $I^2_{(2)}$ and $I^2_{(3)}$ were 0.1568 and 0.5839, respectively. 


```r
## Model 0: Intercept  
summary( Model0 <- meta3(y=logOR, v=v, cluster=Cluster, data=Bornmann07, 
                         model.name="3 level model") )
```

```

Call:
meta3(y = logOR, v = v, cluster = Cluster, data = Bornmann07, 
    model.name = "3 level model")

95% confidence intervals: z statistic approximation
Coefficients:
            Estimate  Std.Error     lbound     ubound z value Pr(>|z|)  
Intercept -0.1007784  0.0401327 -0.1794371 -0.0221198 -2.5111  0.01203 *
Tau2_2     0.0037965  0.0027210 -0.0015367  0.0091297  1.3952  0.16295  
Tau2_3     0.0141352  0.0091445 -0.0037877  0.0320580  1.5458  0.12216  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Q statistic on the homogeneity of effect sizes: 221.2809
Degrees of freedom of the Q statistic: 65
P value of the Q statistic: 0

Heterogeneity indices (based on the estimated Tau2):
                              Estimate
I2_2 (Typical v: Q statistic)   0.1568
I2_3 (Typical v: Q statistic)   0.5839

Number of studies (or clusters): 21
Number of observed statistics: 66
Number of estimated parameters: 3
Degrees of freedom: 63
-2 log likelihood: 25.80256 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```

* Testing $H_0: \tau^2_3 = 0$
We may test whether the three-level model is necessary by testing $H_0: \tau^2_{(3)} = 0$. The likelihood ratio statistic was 10.2202 (_df_ = 1), _p_ < .01. Thus, the three-level model is statistically better than the two-level model.

```r
## Testing tau^2_3 = 0
Model0a <- meta3(logOR, v, cluster=Cluster, data=Bornmann07, 
                 RE3.constraints=0, model.name="2 level model")
anova(Model0, Model0a)
```

```
           base    comparison ep minus2LL df        AIC   diffLL diffdf
1 3 level model          <NA>  3 25.80256 63 -100.19744       NA     NA
2 3 level model 2 level model  2 36.02279 64  -91.97721 10.22024      1
            p
1          NA
2 0.001389081
```

* Testing $H_0: \tau^2_2 = \tau^2_3$
The likelihood-ratio statistic in testing $H_0: \tau^2_{(2)} = \tau^2_{(3)}$ was 1.3591 (_df_ = 1), _p_ = 0.2437. Thus, there is no evidence to reject the null hypothesis.

```r
## Testing tau^2_2 = tau^2_3
Model0b <- meta3(logOR, v, cluster=Cluster, data=Bornmann07, 
                 RE2.constraints="0.1*Eq_tau2", RE3.constraints="0.1*Eq_tau2", 
                 model.name="tau2_2 equals tau2_3")
anova(Model0, Model0b)
```

```
           base           comparison ep minus2LL df       AIC   diffLL
1 3 level model                 <NA>  3 25.80256 63 -100.1974       NA
2 3 level model tau2_2 equals tau2_3  2 27.16166 64 -100.8383 1.359103
  diffdf        p
1     NA       NA
2      1 0.243693
```

## Model 1: `Type` as a covariate
* Conventionally, one level (e.g., `Grants`) is used as the reference group. The estimated intercept (labeled `Intercept` in the output) represents the estimated effect size for `Grants` and the regression coefficient (labeled `Slope_1` in the output) is the difference between `Fellowship` and `Grants`. 
    + The estimated slope on `Type` (and its 95% Wald CI) was -0.1956 (-0.3018, -0.0894) which is statistically significant at $\alpha=.05$. This is the difference between `Fellowship` and `Grants`. The $R^2_{(2)}$ and $R^2_{(3)}$ were 0.0693 and 0.7943, respectively.

```r
## Model 1: Type as a covariate  
## Convert characters into a dummy variable
## Type2=0 (Grants); Type2=1 (Fellowship)    
Type2 <- ifelse(Bornmann07$Type=="Fellowship", yes=1, no=0)
summary( Model1 <- meta3(logOR, v, x=Type2, cluster=Cluster, data=Bornmann07)) 
```

```

Call:
meta3(y = logOR, v = v, cluster = Cluster, x = Type2, data = Bornmann07)

95% confidence intervals: z statistic approximation
Coefficients:
            Estimate  Std.Error     lbound     ubound z value  Pr(>|z|)
Intercept -0.0066071  0.0371125 -0.0793462  0.0661320 -0.1780 0.8587001
Slope_1   -0.1955869  0.0541649 -0.3017483 -0.0894256 -3.6110 0.0003051
Tau2_2     0.0035335  0.0024306 -0.0012303  0.0082974  1.4538 0.1460058
Tau2_3     0.0029079  0.0031183 -0.0032039  0.0090197  0.9325 0.3510704
             
Intercept    
Slope_1   ***
Tau2_2       
Tau2_3       
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Q statistic on the homogeneity of effect sizes: 221.2809
Degrees of freedom of the Q statistic: 65
P value of the Q statistic: 0

Explained variances (R2):
                         Level 2 Level 3
Tau2 (no predictor)    0.0037965  0.0141
Tau2 (with predictors) 0.0035335  0.0029
R2                     0.0692595  0.7943

Number of studies (or clusters): 21
Number of observed statistics: 66
Number of estimated parameters: 4
Degrees of freedom: 62
-2 log likelihood: 17.62569 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```

## Model 2: `Year` and `Year^2` as covariates
* When there are several covariates, we may combine them with the `cbind()` command. For example, `cbind(Year, Year^2)` includes both `Year` and its squared as covariates. In the output, `Slope_1` and `Slope_2` refer to the regression coefficients for `Year` and `Year^2`, respectively. To increase the numerical stability, the covariates are usually centered before creating the quadratic terms. Since Marsh et al. (2009) standardized `Year` in their analysis, I follow this practice here.
- The estimated regression coefficients (and their 95% CIs) for =Year= and =Year^2= were -0.0010 (-0.0473, 0.0454) and -0.0118 (-0.0247, 0.0012), respectively. The $R^2_{(2)}$ and $R^2_{(3)}$ were 0.2430 and 0.0000, respectively.

```r
## Model 2: Year and Year^2 as covariates
summary( Model2 <- meta3(logOR, v, x=cbind(scale(Year), scale(Year)^2), 
                         cluster=Cluster, data=Bornmann07,
                         model.name="Model 2") ) 
```

```

Call:
meta3(y = logOR, v = v, cluster = Cluster, x = cbind(scale(Year), 
    scale(Year)^2), data = Bornmann07, model.name = "Model 2")

95% confidence intervals: z statistic approximation
Coefficients:
             Estimate   Std.Error      lbound      ubound z value Pr(>|z|)
Intercept -0.08627312  0.04125581 -0.16713302 -0.00541321 -2.0912  0.03651
Slope_1   -0.00095287  0.02365224 -0.04731040  0.04540467 -0.0403  0.96786
Slope_2   -0.01176840  0.00659995 -0.02470407  0.00116727 -1.7831  0.07457
Tau2_2     0.00287389  0.00206817 -0.00117965  0.00692744  1.3896  0.16466
Tau2_3     0.01479446  0.00926095 -0.00335666  0.03294558  1.5975  0.11015
           
Intercept *
Slope_1    
Slope_2   .
Tau2_2     
Tau2_3     
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Q statistic on the homogeneity of effect sizes: 221.2809
Degrees of freedom of the Q statistic: 65
P value of the Q statistic: 0

Explained variances (R2):
                         Level 2 Level 3
Tau2 (no predictor)    0.0037965  0.0141
Tau2 (with predictors) 0.0028739  0.0148
R2                     0.2430134  0.0000

Number of studies (or clusters): 21
Number of observed statistics: 66
Number of estimated parameters: 5
Degrees of freedom: 61
-2 log likelihood: 22.3836 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```

* Testing $H_0: \beta_{Year} = \beta_{Year^2}=0$
The test statistic was 3.4190 (_df_ = 2), _p_ = 0.1810. Thus, there is no evidence supporting that =Year= has a quadratic effect on the effect size.

```r
## Testing beta_{Year} = beta_{Year^2}=0
anova(Model2, Model0)
```

```
     base    comparison ep minus2LL df       AIC   diffLL diffdf         p
1 Model 2          <NA>  5 22.38360 61  -99.6164       NA     NA        NA
2 Model 2 3 level model  3 25.80256 63 -100.1974 3.418955      2 0.1809603
```

## Model 3: `Discipline` as a covariate
* There are four categories in `Discipline`. `multidisciplinary` is used as the reference group in the analysis.
* The estimated regression coefficients (and their 95% Wald CIs) for `DisciplinePhy`, `DisciplineLife` and `DisciplineSoc` were -0.0091 (-0.2041, 0.1859), -0.1262 (-0.2804, 0.0280) and -0.2370 (-0.4746, 0.0007), respectively. The $R^2_2$ and $R^2_3$ were 0.0000 and 0.4975, respectively.

```r
## Model 3: Discipline as a covariate
## Create dummy variables using multidisciplinary as the reference group
DisciplinePhy <- ifelse(Bornmann07$Discipline=="Physical sciences", yes=1, no=0)
DisciplineLife <- ifelse(Bornmann07$Discipline=="Life sciences/biology", yes=1, no=0)
DisciplineSoc <- ifelse(Bornmann07$Discipline=="Social sciences/humanities", yes=1, no=0)
summary( Model3 <- meta3(logOR, v, x=cbind(DisciplinePhy, DisciplineLife, DisciplineSoc), 
                         cluster=Cluster, data=Bornmann07,
                         model.name="Model 3") )
```

```

Call:
meta3(y = logOR, v = v, cluster = Cluster, x = cbind(DisciplinePhy, 
    DisciplineLife, DisciplineSoc), data = Bornmann07, model.name = "Model 3")

95% confidence intervals: z statistic approximation
Coefficients:
            Estimate  Std.Error     lbound     ubound z value Pr(>|z|)  
Intercept -0.0147478  0.0638995 -0.1399885  0.1104928 -0.2308  0.81747  
Slope_1   -0.0091306  0.0994920 -0.2041314  0.1858701 -0.0918  0.92688  
Slope_2   -0.1261796  0.0786628 -0.2803557  0.0279966 -1.6041  0.10870  
Slope_3   -0.2369570  0.1212309 -0.4745652  0.0006513 -1.9546  0.05063 .
Tau2_2     0.0039094  0.0028395 -0.0016559  0.0094747  1.3768  0.16857  
Tau2_3     0.0071034  0.0064321 -0.0055033  0.0197101  1.1044  0.26944  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Q statistic on the homogeneity of effect sizes: 221.2809
Degrees of freedom of the Q statistic: 65
P value of the Q statistic: 0

Explained variances (R2):
                         Level 2 Level 3
Tau2 (no predictor)    0.0037965  0.0141
Tau2 (with predictors) 0.0039094  0.0071
R2                     0.0000000  0.4975

Number of studies (or clusters): 21
Number of observed statistics: 66
Number of estimated parameters: 6
Degrees of freedom: 60
-2 log likelihood: 20.07571 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```

* Testing whether `Discipline` is significant
    + The test statistic was 5.7268 (_df_ = 3), _p_ = 0.1257 which is not significant. Therefore, there is no evidence supporting that =Discipline= explains the variation of the effect sizes.

```r
## Testing whether Discipline is significant
anova(Model3, Model0)
```

```
     base    comparison ep minus2LL df        AIC   diffLL diffdf
1 Model 3          <NA>  6 20.07571 60  -99.92429       NA     NA
2 Model 3 3 level model  3 25.80256 63 -100.19744 5.726842      3
          p
1        NA
2 0.1256832
```

## Model 4: `Country` as a covariate
* There are five categories in `Country`. `United States` is used as the reference group in the analysis.
* The estimated regression coefficients (and their 95% Wald CIs) for `CountryAus`, `CountryCan`, `CountryEur`, and `CountryUK` are -0.0240 (-0.2405, 0.1924), -0.1341 (-0.3674, 0.0993), -0.2211 (-0.3660, -0.0762) and 0.0537 (-0.1413, 0.2487), respectively. The $R^2_2$ and $R^2_3$ were 0.1209 and 0.6606, respectively.

```r
## Model 4: Country as a covariate
## Create dummy variables using the United States as the reference group
CountryAus <- ifelse(Bornmann07$Country=="Australia", yes=1, no=0)
CountryCan <- ifelse(Bornmann07$Country=="Canada", yes=1, no=0)
CountryEur <- ifelse(Bornmann07$Country=="Europe", yes=1, no=0)
CountryUK <- ifelse(Bornmann07$Country=="United Kingdom", yes=1, no=0)
  
summary( Model4 <- meta3(logOR, v, x=cbind(CountryAus, CountryCan, CountryEur, 
                         CountryUK), cluster=Cluster, data=Bornmann07,
                         model.name="Model 4") )  
```

```

Call:
meta3(y = logOR, v = v, cluster = Cluster, x = cbind(CountryAus, 
    CountryCan, CountryEur, CountryUK), data = Bornmann07, model.name = "Model 4")

95% confidence intervals: z statistic approximation
Coefficients:
            Estimate  Std.Error     lbound     ubound z value Pr(>|z|)   
Intercept  0.0025681  0.0597768 -0.1145923  0.1197285  0.0430 0.965732   
Slope_1   -0.0240109  0.1104328 -0.2404552  0.1924333 -0.2174 0.827876   
Slope_2   -0.1340800  0.1190667 -0.3674465  0.0992866 -1.1261 0.260127   
Slope_3   -0.2210801  0.0739174 -0.3659556 -0.0762046 -2.9909 0.002782 **
Slope_4    0.0537251  0.0994803 -0.1412527  0.2487030  0.5401 0.589157   
Tau2_2     0.0033376  0.0023492 -0.0012667  0.0079420  1.4208 0.155383   
Tau2_3     0.0047979  0.0044818 -0.0039862  0.0135820  1.0705 0.284379   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Q statistic on the homogeneity of effect sizes: 221.2809
Degrees of freedom of the Q statistic: 65
P value of the Q statistic: 0

Explained variances (R2):
                         Level 2 Level 3
Tau2 (no predictor)    0.0037965  0.0141
Tau2 (with predictors) 0.0033376  0.0048
R2                     0.1208598  0.6606

Number of studies (or clusters): 21
Number of observed statistics: 66
Number of estimated parameters: 7
Degrees of freedom: 59
-2 log likelihood: 14.18259 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```

* Testing whether `Discipline` is significant
    + The test statistic was 11.6200 (_df_ = 4), _p_ = 0.0204 which is statistically significant.

```r
  ## Testing whether Discipline is significant
  anova(Model4, Model0)
```

```
     base    comparison ep minus2LL df       AIC   diffLL diffdf
1 Model 4          <NA>  7 14.18259 59 -103.8174       NA     NA
2 Model 4 3 level model  3 25.80256 63 -100.1974 11.61996      4
           p
1         NA
2 0.02041284
```

## Model 5: `Type` and `Discipline` as covariates
* The $R^2_{(2)}$ and $R^2_{(3)}$ were 0.3925 and 1.0000, respectively. The $\hat{\tau}^2_{(3)}$ was near 0 after controlling for the covariates.

```r
## Model 5: Type and Discipline as covariates
Model5 <- meta3(logOR, v, x=cbind(Type2, DisciplinePhy, DisciplineLife, 
                DisciplineSoc), cluster=Cluster, data=Bornmann07,
                model.name="Model 5")

## Rerun it to remove the error code
Model5 <- rerun(Model5)
summary(Model5)
```

```

Call:
meta3(y = logOR, v = v, cluster = Cluster, x = cbind(Type2, DisciplinePhy, 
    DisciplineLife, DisciplineSoc), data = Bornmann07, model.name = "Model 5")

95% confidence intervals: z statistic approximation
Coefficients:
             Estimate   Std.Error      lbound      ubound z value
Intercept  6.7036e-02  1.8553e-02  3.0672e-02  1.0340e-01  3.6132
Slope_1   -1.9004e-01  4.0234e-02 -2.6890e-01 -1.1118e-01 -4.7233
Slope_2    1.9511e-02  6.5942e-02 -1.0973e-01  1.4875e-01  0.2959
Slope_3   -1.2779e-01  3.5914e-02 -1.9818e-01 -5.7400e-02 -3.5582
Slope_4   -2.3950e-01  9.4054e-02 -4.2384e-01 -5.5154e-02 -2.5464
Tau2_2     2.3062e-03  1.4270e-03 -4.9059e-04  5.1030e-03  1.6162
Tau2_3     1.0000e-10          NA          NA          NA      NA
           Pr(>|z|)    
Intercept 0.0003025 ***
Slope_1    2.32e-06 ***
Slope_2   0.7673209    
Slope_3   0.0003734 ***
Slope_4   0.0108849 *  
Tau2_2    0.1060586    
Tau2_3           NA    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Q statistic on the homogeneity of effect sizes: 221.2809
Degrees of freedom of the Q statistic: 65
P value of the Q statistic: 0

Explained variances (R2):
                         Level 2 Level 3
Tau2 (no predictor)    0.0037965  0.0141
Tau2 (with predictors) 0.0023062  0.0000
R2                     0.3925434  1.0000

Number of studies (or clusters): 21
Number of observed statistics: 66
Number of estimated parameters: 7
Degrees of freedom: 59
-2 log likelihood: 4.66727 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```

* Testing whether `Discipline` is significant after controlling for `Type`
    + The test statistic was 12.9584 (_df_ = 3), _p_ = 0.0047 which is significant. Therefore, `Discipline` is still significant after controlling for `Type`.

```r
## Testing whether Discipline is significant after controlling for Type
anova(Model5, Model1)
```

```
     base            comparison ep minus2LL df       AIC   diffLL diffdf
1 Model 5                  <NA>  7  4.66727 59 -113.3327       NA     NA
2 Model 5 Meta analysis with ML  4 17.62569 62 -106.3743 12.95842      3
            p
1          NA
2 0.004727388
```

## Model 6: `Type` and `Country` as covariates  
* The $R^2_{(2)}$ and $R^2_{(3)}$ were 0.3948 and 1.0000, respectively. The $\hat{\tau}^2_{(3)}$ was near 0 after controlling for the covariates.

```r
## Model 6: Type and Country as covariates
Model6 <- meta3(logOR, v, x=cbind(Type2, CountryAus, CountryCan, 
                CountryEur, CountryUK), cluster=Cluster, data=Bornmann07,
                model.name="Model 6") 

## Rerun it to remove the error code
Model6 <- rerun(Model6)
summary(Model5)
```

```

Call:
meta3(y = logOR, v = v, cluster = Cluster, x = cbind(Type2, DisciplinePhy, 
    DisciplineLife, DisciplineSoc), data = Bornmann07, model.name = "Model 5")

95% confidence intervals: z statistic approximation
Coefficients:
             Estimate   Std.Error      lbound      ubound z value
Intercept  6.7036e-02  1.8553e-02  3.0672e-02  1.0340e-01  3.6132
Slope_1   -1.9004e-01  4.0234e-02 -2.6890e-01 -1.1118e-01 -4.7233
Slope_2    1.9511e-02  6.5942e-02 -1.0973e-01  1.4875e-01  0.2959
Slope_3   -1.2779e-01  3.5914e-02 -1.9818e-01 -5.7400e-02 -3.5582
Slope_4   -2.3950e-01  9.4054e-02 -4.2384e-01 -5.5154e-02 -2.5464
Tau2_2     2.3062e-03  1.4270e-03 -4.9059e-04  5.1030e-03  1.6162
Tau2_3     1.0000e-10          NA          NA          NA      NA
           Pr(>|z|)    
Intercept 0.0003025 ***
Slope_1    2.32e-06 ***
Slope_2   0.7673209    
Slope_3   0.0003734 ***
Slope_4   0.0108849 *  
Tau2_2    0.1060586    
Tau2_3           NA    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Q statistic on the homogeneity of effect sizes: 221.2809
Degrees of freedom of the Q statistic: 65
P value of the Q statistic: 0

Explained variances (R2):
                         Level 2 Level 3
Tau2 (no predictor)    0.0037965  0.0141
Tau2 (with predictors) 0.0023062  0.0000
R2                     0.3925434  1.0000

Number of studies (or clusters): 21
Number of observed statistics: 66
Number of estimated parameters: 7
Degrees of freedom: 59
-2 log likelihood: 4.66727 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```

* Testing whether `Country` is significant after controlling for `Type`
    + The test statistic was 12.5491 (_df_ = 4), _p_ = 0.0137. Thus, `Country` is significant after controlling for `Type`.

```r
## Testing whether Country is significant after controlling for Type
anova(Model6, Model1)
```

```
     base            comparison ep  minus2LL df       AIC  diffLL diffdf
1 Model 6                  <NA>  8  5.076592 58 -110.9234      NA     NA
2 Model 6 Meta analysis with ML  4 17.625692 62 -106.3743 12.5491      4
           p
1         NA
2 0.01370262
```

## Model 7: `Discipline` and `Country` as covariates
* The $R^2_{(2)}$ and $R^2_{(3)}$ were 0.1397 and 0.7126, respectively.  

```r
## Model 7: Discipline and Country as covariates
summary( meta3(logOR, v, x=cbind(DisciplinePhy, DisciplineLife, DisciplineSoc,
                         CountryAus, CountryCan, CountryEur, CountryUK), 
                         cluster=Cluster, data=Bornmann07,
                         model.name="Model 7") )
```

```

Call:
meta3(y = logOR, v = v, cluster = Cluster, x = cbind(DisciplinePhy, 
    DisciplineLife, DisciplineSoc, CountryAus, CountryCan, CountryEur, 
    CountryUK), data = Bornmann07, model.name = "Model 7")

95% confidence intervals: z statistic approximation
Coefficients:
            Estimate  Std.Error     lbound     ubound z value Pr(>|z|)  
Intercept  0.0029305  0.0576743 -0.1101091  0.1159700  0.0508  0.95948  
Slope_1    0.1742169  0.1702561 -0.1594788  0.5079127  1.0233  0.30618  
Slope_2    0.0826806  0.1599809 -0.2308762  0.3962373  0.5168  0.60529  
Slope_3   -0.0462265  0.1715779 -0.3825130  0.2900601 -0.2694  0.78761  
Slope_4   -0.0486321  0.1306921 -0.3047839  0.2075196 -0.3721  0.70981  
Slope_5   -0.2169132  0.1915709 -0.5923854  0.1585589 -1.1323  0.25751  
Slope_6   -0.3036578  0.1670728 -0.6311144  0.0237989 -1.8175  0.06914 .
Slope_7   -0.0605272  0.1809426 -0.4151681  0.2941137 -0.3345  0.73799  
Tau2_2     0.0032661  0.0022784 -0.0011994  0.0077317  1.4335  0.15171  
Tau2_3     0.0040618  0.0038459 -0.0034759  0.0115996  1.0562  0.29090  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Q statistic on the homogeneity of effect sizes: 221.2809
Degrees of freedom of the Q statistic: 65
P value of the Q statistic: 0

Explained variances (R2):
                         Level 2 Level 3
Tau2 (no predictor)    0.0037965  0.0141
Tau2 (with predictors) 0.0032661  0.0041
R2                     0.1396974  0.7126

Number of studies (or clusters): 21
Number of observed statistics: 66
Number of estimated parameters: 10
Degrees of freedom: 56
-2 log likelihood: 10.31105 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```

## Model 8: `Type`, `Discipline` and `Country` as covariates
* The $R^2_{(2)}$ and $R^2_{(3)}$ were 0.4466 and 1.0000, respectively. The $\hat{\tau}^2_{(3)}$ was near 0 after controlling for the covariates. 

```r
## Model 8: Type, Discipline and Country as covariates
Model8 <- meta3(logOR, v, x=cbind(Type2, DisciplinePhy, DisciplineLife, DisciplineSoc,
                           CountryAus, CountryCan, CountryEur, CountryUK), 
                           cluster=Cluster, data=Bornmann07,
                           model.name="Model 8") 
## There was an estimation error. The model was rerun again.
summary(rerun(Model8))
```

```

Call:
meta3(y = logOR, v = v, cluster = Cluster, x = cbind(Type2, DisciplinePhy, 
    DisciplineLife, DisciplineSoc, CountryAus, CountryCan, CountryEur, 
    CountryUK), data = Bornmann07, model.name = "Model 8")

95% confidence intervals: z statistic approximation
Coefficients:
             Estimate   Std.Error      lbound      ubound z value
Intercept  6.8563e-02  1.8630e-02  3.2049e-02  1.0508e-01  3.6802
Slope_1   -1.6885e-01  4.1545e-02 -2.5028e-01 -8.7425e-02 -4.0643
Slope_2    2.5329e-01  1.5814e-01 -5.6670e-02  5.6325e-01  1.6016
Slope_3    1.2689e-01  1.4774e-01 -1.6268e-01  4.1646e-01  0.8589
Slope_4   -8.3549e-03  1.5796e-01 -3.1795e-01  3.0124e-01 -0.0529
Slope_5   -1.1530e-01  1.1147e-01 -3.3377e-01  1.0317e-01 -1.0344
Slope_6   -2.6412e-01  1.6402e-01 -5.8559e-01  5.7344e-02 -1.6103
Slope_7   -2.9029e-01  1.4859e-01 -5.8152e-01  9.5232e-04 -1.9536
Slope_8   -1.5975e-01  1.6285e-01 -4.7893e-01  1.5943e-01 -0.9810
Tau2_2     2.1010e-03  1.2925e-03 -4.3226e-04  4.6342e-03  1.6255
Tau2_3     1.0000e-10          NA          NA          NA      NA
           Pr(>|z|)    
Intercept  0.000233 ***
Slope_1   4.818e-05 ***
Slope_2    0.109240    
Slope_3    0.390411    
Slope_4    0.957818    
Slope_5    0.300949    
Slope_6    0.107324    
Slope_7    0.050754 .  
Slope_8    0.326610    
Tau2_2     0.104051    
Tau2_3           NA    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Q statistic on the homogeneity of effect sizes: 221.2809
Degrees of freedom of the Q statistic: 65
P value of the Q statistic: 0

Explained variances (R2):
                         Level 2 Level 3
Tau2 (no predictor)    0.0037965  0.0141
Tau2 (with predictors) 0.0021010  0.0000
R2                     0.4466073  1.0000

Number of studies (or clusters): 21
Number of observed statistics: 66
Number of estimated parameters: 11
Degrees of freedom: 55
-2 log likelihood: -1.645211 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```

# Handling missing covariates with FIML
When there are missing data in the covariates, data with missing values are excluded before the analysis in `meta3()`. The missing covariates can be handled by the use of FIML in `meta3X()`. We illustrate two examples on how to analyze data with missing covariates with missing completely at random (MCAR) and missing at random (MAR) data.
 
## MCAR
* About 25% of the level-2 covariate `Type` was introduced by the MCAR mechanism. 

```r
#### Handling missing covariates with FIML
  
## MCAR
## Set seed for replication
set.seed(1000000)
  
## Copy Bornmann07 to my.df
my.df <- Bornmann07
## "Fellowship": 1; "Grant": 0
my.df$Type_MCAR <- ifelse(Bornmann07$Type=="Fellowship", yes=1, no=0)

## Create 17 out of 66 missingness with MCAR
my.df$Type_MCAR[sample(1:66, 17)] <- NA
  
summary(meta3(y=logOR, v=v, cluster=Cluster, x=Type_MCAR, data=my.df))
```

```

Call:
meta3(y = logOR, v = v, cluster = Cluster, x = Type_MCAR, data = my.df)

95% confidence intervals: z statistic approximation
Coefficients:
             Estimate   Std.Error      lbound      ubound z value
Intercept -0.00484542  0.03934429 -0.08195880  0.07226797 -0.1232
Slope_1   -0.21090081  0.05346221 -0.31568482 -0.10611680 -3.9449
Tau2_2     0.00446788  0.00549282 -0.00629784  0.01523361  0.8134
Tau2_3     0.00092884  0.00336491 -0.00566625  0.00752394  0.2760
           Pr(>|z|)    
Intercept    0.9020    
Slope_1   7.985e-05 ***
Tau2_2       0.4160    
Tau2_3       0.7825    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Q statistic on the homogeneity of effect sizes: 151.643
Degrees of freedom of the Q statistic: 48
P value of the Q statistic: 1.115552e-12

Explained variances (R2):
                         Level 2 Level 3
Tau2 (no predictor)    0.0042664  0.0145
Tau2 (with predictors) 0.0044679  0.0009
R2                     0.0000000  0.9361

Number of studies (or clusters): 20
Number of observed statistics: 49
Number of estimated parameters: 4
Degrees of freedom: 45
-2 log likelihood: 13.13954 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```
* There is no need to specify whether the covariates are level 2 or level 3 in `meta3()` because the covariates are treated as a design matrix. When `meta3X()` is used, users need to specify whether the covariates are at level 2 (`x2`) or level 3 (`x3`).

```r
summary(meta3X(y=logOR, v=v, cluster=Cluster, x2=Type_MCAR, data=my.df))
```

```

Call:
meta3X(y = logOR, v = v, cluster = Cluster, x2 = Type_MCAR, data = my.df)

95% confidence intervals: z statistic approximation
Coefficients:
            Estimate  Std.Error     lbound     ubound z value Pr(>|z|)   
Intercept -0.0106318  0.0397685 -0.0885766  0.0673131 -0.2673 0.789207   
SlopeX2_1 -0.1753249  0.0582619 -0.2895162 -0.0611336 -3.0093 0.002619 **
Tau2_2     0.0030338  0.0026839 -0.0022266  0.0082941  1.1304 0.258324   
Tau2_3     0.0036839  0.0042817 -0.0047082  0.0120759  0.8604 0.389586   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Explained variances (R2):
                         Level 2 Level 3
Tau2 (no predictor)    0.0037965  0.0141
Tau2 (with predictors) 0.0030338  0.0037
R2                     0.2009069  0.7394

Number of studies (or clusters): 21
Number of observed statistics: 115
Number of estimated parameters: 7
Degrees of freedom: 108
-2 log likelihood: 49.76372 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```

## MAR
* For the case for missing covariates with MAR, the missingness in `Type` depends on the values of `Year`. `Type` is missing when `Year` is smaller than 1996. 

```r
## MAR
Type_MAR <- ifelse(Bornmann07$Type=="Fellowship", yes=1, no=0)
  
## Create 27 out of 66 missingness with MAR for cases Year<1996
index_MAR <- ifelse(Bornmann07$Year<1996, yes=TRUE, no=FALSE)
Type_MAR[index_MAR] <- NA
  
summary(meta3(logOR, v, x=Type_MAR, cluster=Cluster, data=Bornmann07)) 
```

```

Call:
meta3(y = logOR, v = v, cluster = Cluster, x = Type_MAR, data = Bornmann07)

95% confidence intervals: z statistic approximation
Coefficients:
             Estimate   Std.Error      lbound      ubound z value Pr(>|z|)
Intercept -0.01587052  0.03952547 -0.09333902  0.06159797 -0.4015 0.688032
Slope_1   -0.17573648  0.06328327 -0.29976941 -0.05170354 -2.7770 0.005487
Tau2_2     0.00259266  0.00171596 -0.00077056  0.00595588  1.5109 0.130811
Tau2_3     0.00278384  0.00267150 -0.00245221  0.00801989  1.0421 0.297388
            
Intercept   
Slope_1   **
Tau2_2      
Tau2_3      
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Q statistic on the homogeneity of effect sizes: 151.11
Degrees of freedom of the Q statistic: 38
P value of the Q statistic: 1.998401e-15

Explained variances (R2):
                         Level 2 Level 3
Tau2 (no predictor)    0.0029593  0.0097
Tau2 (with predictors) 0.0025927  0.0028
R2                     0.1238926  0.7121

Number of studies (or clusters): 12
Number of observed statistics: 39
Number of estimated parameters: 4
Degrees of freedom: 35
-2 log likelihood: -24.19956 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```
* It is possible to include level 2 (`av2`) and level 3 (`av3`) auxiliary variables. Auxiliary variables are those that predict the missing values or are correlated with the variables that contain missing values. The inclusion of auxiliary variables can improve the efficiency of the estimation and the parameter estimates. 

```r
## Include auxiliary variable
summary(meta3X(y=logOR, v=v, cluster=Cluster, x2=Type_MAR, av2=Year, data=my.df))
```

```

Call:
meta3X(y = logOR, v = v, cluster = Cluster, x2 = Type_MAR, av2 = Year, 
    data = my.df)

95% confidence intervals: z statistic approximation
Coefficients:
            Estimate  Std.Error     lbound     ubound z value Pr(>|z|)   
Intercept -0.0264058  0.0572080 -0.1385314  0.0857198 -0.4616 0.644386   
SlopeX2_1 -0.2003999  0.0691114 -0.3358557 -0.0649440 -2.8997 0.003736 **
Tau2_2     0.0029970  0.0022371 -0.0013877  0.0073817  1.3396 0.180360   
Tau2_3     0.0030212  0.0032464 -0.0033416  0.0093840  0.9306 0.352041   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Explained variances (R2):
                         Level 2 Level 3
Tau2 (no predictor)    0.0049237  0.0088
Tau2 (with predictors) 0.0029970  0.0030
R2                     0.3913243  0.6571

Number of studies (or clusters): 21
Number of observed statistics: 171
Number of estimated parameters: 14
Degrees of freedom: 157
-2 log likelihood: 377.3479 
OpenMx status1: 0 ("0" or "1": The optimization is considered fine.
Other values may indicate problems.)
```

# Implementing three-level meta-analyses as structural equation models in `OpenMx`
This section illustrates how to formulate three-level meta-analyses as structural equation models using the `OpenMx` package. The steps outline how to create the model-implied mean vector and the model-implied covariance matrix to fit the three-level meta-analyses. `y` is the effect size (standardized mean difference on the modified school calendars) and `v` is its sampling variance. =District= is the variable for the cluster effect, whereas `Year` is the year of publication. 

## Preparing data
* Data in a three-level meta-analysis are usually stored in the [long format](http://wiki.stdout.org/rcookbook/Manipulating%20data/Converting%20data%20between%20wide%20and%20long%20format/), e.g., `Cooper03` in this example, whereas the SEM approach uses the wide format. 
* Suppose the maximum number of effect sizes in the level-2 unit is $k$ ($k=11$ in this example). Each cluster is represented by one row with $k=11$ variables representing the outcome effect size, say `y_1` to `y_11` in this example. The incomplete data are represented by `NA` (missing value). 
* Similarly, $k=11$ variables are required to represent the known sampling variances, say `v_1` to `v_11` in this example.
* If the covariates are at level 2, $k=11$ variables are also required to represent each of them. For example, `Year` is a level-2 covariate, `Year_1` to `Year_11` are required to represent it.
* Several extra steps are required to handle missing values. Missing values (represented by `NA` in `R`) are not allowed in `v_1` to `v_11` as they are definition variables. The missing data are converted into some arbitrary values, say `1e10` in this example. The actual value does not matter because the missing values will be removed before the analysis. It is because missing values in `y_1` to `y_11` (and `v_1` to `v_11`) will be filtered out automatically by the use of FIML. 

```r
#### Steps in Analyzing Three-level Meta-analysis in OpenMx

#### Preparing data
## Load the library
library("OpenMx")
  
## Get the dataset from the metaSEM library
data(Cooper03, package="metaSEM")
  
## Make a copy of the original data
my.long <- Cooper03

## Show the first few cases in my.long
head(my.long)
```

```
  District Study     y     v Year
1       11     1 -0.18 0.118 1976
2       11     2 -0.22 0.118 1976
3       11     3  0.23 0.144 1976
4       11     4 -0.30 0.144 1976
5       12     5  0.13 0.014 1989
6       12     6 -0.26 0.014 1989
```

```r
## Center the Year to increase numerical stability
my.long$Year <- scale(my.long$Year, scale=FALSE)
  
## maximum no. of effect sizes in level-2
k <- 11
  
## Create a variable called "time" to store: 1, 2, 3, ... k
my.long$time <- c(unlist(sapply(split(my.long$y, my.long$District), 
                                function(x) 1:length(x))))

## Convert long format to wide format by "District"
my.wide <- reshape(my.long, timevar="time", idvar=c("District"), 
                   sep="_", direction="wide")

## NA in v is due to NA in y in wide format
## Replace NA with 1e10 in "v"
temp <- my.wide[, paste("v_", 1:k, sep="")]
temp[is.na(temp)] <- 1e10
my.wide[, paste("v_", 1:k, sep="")] <- temp
  
## Replace NA with 0 in "Year"
temp <- my.wide[, paste("Year_", 1:k, sep="")]
temp[is.na(temp)] <- 0
my.wide[, paste("Year_", 1:k, sep="")] <- temp

## Show the first few cases in my.wide
head(my.wide)
```

```
   District Study_1   y_1   v_1      Year_1 Study_2   y_2   v_2
1        11       1 -0.18 0.118 -13.5535714       2 -0.22 0.118
5        12       5  0.13 0.014  -0.5535714       6 -0.26 0.014
9        18       9  0.45 0.023   4.4464286      10  0.38 0.043
12       27      12  0.16 0.020 -13.5535714      13  0.65 0.004
16       56      16  0.08 0.019   7.4464286      17  0.04 0.007
20       58      20 -0.18 0.020 -13.5535714      21  0.00 0.018
        Year_2 Study_3  y_3   v_3      Year_3 Study_4   y_4      v_4
1  -13.5535714       3 0.23 0.144 -13.5535714       4 -0.30 1.44e-01
5   -0.5535714       7 0.19 0.015  -0.5535714       8  0.32 2.40e-02
9    4.4464286      11 0.29 0.012   4.4464286      NA    NA 1.00e+10
12 -13.5535714      14 0.36 0.004 -13.5535714      15  0.60 7.00e-03
16   7.4464286      18 0.19 0.005   7.4464286      19 -0.06 4.00e-03
20 -13.5535714      22 0.00 0.019 -13.5535714      23 -0.28 2.20e-02
        Year_4 Study_5   y_5   v_5    Year_5 Study_6  y_6     v_6
1  -13.5535714      NA    NA 1e+10   0.00000      NA   NA 1.0e+10
5   -0.5535714      NA    NA 1e+10   0.00000      NA   NA 1.0e+10
9    0.0000000      NA    NA 1e+10   0.00000      NA   NA 1.0e+10
12 -13.5535714      NA    NA 1e+10   0.00000      NA   NA 1.0e+10
16   7.4464286      NA    NA 1e+10   0.00000      NA   NA 1.0e+10
20 -13.5535714      24 -0.04 2e-02 -13.55357      25 -0.3 2.1e-02
      Year_6 Study_7  y_7   v_7    Year_7 Study_8 y_8   v_8    Year_8
1    0.00000      NA   NA 1e+10   0.00000      NA  NA 1e+10   0.00000
5    0.00000      NA   NA 1e+10   0.00000      NA  NA 1e+10   0.00000
9    0.00000      NA   NA 1e+10   0.00000      NA  NA 1e+10   0.00000
12   0.00000      NA   NA 1e+10   0.00000      NA  NA 1e+10   0.00000
16   0.00000      NA   NA 1e+10   0.00000      NA  NA 1e+10   0.00000
20 -13.55357      26 0.07 6e-03 -13.55357      27   0 7e-03 -13.55357
   Study_9  y_9   v_9    Year_9 Study_10  y_10  v_10   Year_10 Study_11
1       NA   NA 1e+10   0.00000       NA    NA 1e+10   0.00000       NA
5       NA   NA 1e+10   0.00000       NA    NA 1e+10   0.00000       NA
9       NA   NA 1e+10   0.00000       NA    NA 1e+10   0.00000       NA
12      NA   NA 1e+10   0.00000       NA    NA 1e+10   0.00000       NA
16      NA   NA 1e+10   0.00000       NA    NA 1e+10   0.00000       NA
20      28 0.05 7e-03 -13.55357       29 -0.08 7e-03 -13.55357       30
    y_11  v_11   Year_11
1     NA 1e+10   0.00000
5     NA 1e+10   0.00000
9     NA 1e+10   0.00000
12    NA 1e+10   0.00000
16    NA 1e+10   0.00000
20 -0.09 7e-03 -13.55357
```

## Random-effects model
* To implement a three-level meta-analysis as a structural equation model, we need to specify both the model-implied mean vector $\mu(\theta)$, say =expMean=, and the model-implied covariance matrix $\Sigma(\theta)$, say `expCov`. 
* When there is no covariate, the expected mean is a $k \times 1$ vector with all elements of =beta0= (the intercept), i.e., $\mu(\theta) = \left[ \begin{array}{c} 1 \\ \vdots \\ 1 \end{array} \right]\beta_0$. Since `OpenMx` expects a row vector rather than a column vector in the model-implied means, we need to transpose the `expMean` in the analysis.
* `Tau2` ($T^2_{(2)}$) and =Tau3= ($T^2_{(3)}$) are the level 2 and level 3 matrices of heterogeneity, respectively. =Tau2= is a diagonal matrix with elements of $\tau^2_{(2)}$, whereas =Tau3= is a full matrix with elements of $\tau^2_{(3)}$. =V= is a diagonal matrix of the known sampling variances $v_{ij}$.
* The model-implied covariance matrix is $\Sigma(\theta) = T^2_{(3)} + T^2_{(2)} + V$.
* All of these matrices are stored into a model called `random.model`.

```r
#### Random-effects model  
## Intercept
Beta0 <- mxMatrix("Full", ncol=1, nrow=1, free=TRUE, labels="beta0", 
                  name="Beta0")
## 1 by k row vector of ones
Ones <- mxMatrix("Unit", nrow=k, ncol=1, name="Ones")
  
## Model implied mean vector 
## OpenMx expects a row vector rather than a column vector.
expMean <- mxAlgebra( t(Ones %*% Beta0), name="expMean")
  
## Tau2_2
Tau2 <- mxMatrix("Symm", ncol=1, nrow=1, values=0.01, free=TRUE, labels="tau2_2", 
                 name="Tau2")
Tau3 <- mxMatrix("Symm", ncol=1, nrow=1, values=0.01, free=TRUE, labels="tau2_3", 
                 name="Tau3")
  
## k by k identity matrix
Iden <- mxMatrix("Iden", nrow=k, ncol=k, name="Iden")
  
## Conditional sampling variances
## data.v_1, data.v_2, ... data.v_k represent values for definition variables
V <- mxMatrix("Diag", nrow=k, ncol=k, free=FALSE, 
              labels=paste("data.v", 1:k, sep="_"), name="V")
  
## Model implied covariance matrix
expCov <- mxAlgebra( Ones%*% Tau3 %*% t(Ones) + Iden %x% Tau2 + V, name="expCov")
  
## Model stores everthing together
random.model <- mxModel(model="Random effects model", 
                        mxData(observed=my.wide, type="raw"), 
                        Iden, Ones, Beta0, Tau2, Tau3, V, expMean, expCov,
                        mxExpectationNormal("expCov","expMean", 
                        dimnames=paste("y", 1:k, sep="_")),
                        mxFitFunctionML() )
```
* We perform a random-effects three-level meta-analysis by running the model with the `mxRun()` command. The parameter estimates (and their _SE_s) for $\beta_0$, $\tau^2_{(2)}$ and $\tau^2_{(3)}$ were 0.1845 (0.0805), 0.0329 (0.0111) and 0.0577 (0.0307), respectively.

```r
summary( mxRun(random.model) )
```

```
Summary of Random effects model 
 
free parameters:
    name matrix row col   Estimate  Std.Error A
1  beta0  Beta0   1   1 0.18445538 0.08054110  
2 tau2_2   Tau2   1   1 0.03286479 0.01113968  
3 tau2_3   Tau3   1   1 0.05773836 0.03074229  

observed statistics:  56 
estimated parameters:  3 
degrees of freedom:  53 
fit value ( -2lnL units ):  16.78987 
number of observations:  11 
Information Criteria: 
      |  df Penalty  |  Parameters Penalty  |  Sample-Size Adjusted
AIC:      -89.21013               22.78987                       NA
BIC:     -110.29858               23.98356                 14.95056
To get additional fit indices, see help(mxRefModels)
timestamp: 2016-04-23 23:30:43 
Wall clock time (HH:MM:SS.hh): 00:00:00.06 
optimizer:  SLSQP 
OpenMx version number: 2.5.2 
Need help?  See help(mxSummary) 
```

## Mixed-effects model
* We may extend a random-effects model to a mixed-effects model by including a covariate (`Year` in this example).
* `beta1` is the regression coefficient, whereas `X` stores the value of `Year` via definition variables.
* The conditional model-implied mean vector is $\mu(\theta|Year_{ij}) = \left[ \begin{array}{c} 1 \\ \vdots \\ 1 \end{array} \right]\beta_0 + \left[ \begin{array}{c} Year_{1j} \\ \vdots \\ Year_{kj} \end{array} \right]\beta_1$.
* The conditional model-implied covariance matrix is the same as that in the random-effects model, i.e., $\Sigma(\theta|Year_{ij}) = T^2_{(3)} + T^2_{(2)} + V$. 

```r
#### Mixed-effects model
  
## Design matrix via definition variable
X <- mxMatrix("Full", nrow=k, ncol=1, free=FALSE, 
              labels=paste("data.Year_", 1:k, sep=""), name="X")
  
## Regression coefficient
Beta1 <- mxMatrix("Full", nrow=1, ncol=1, free=TRUE, values=0,
                  labels="beta1", name="Beta1")
  
## Model implied mean vector
expMean <- mxAlgebra( t(Ones%*%Beta0 + X%*%Beta1), name="expMean")
  
mixed.model <- mxModel(model="Mixed effects model", 
                       mxData(observed=my.wide, type="raw"), 
                       Iden, Ones, Beta0, Beta1, Tau2, Tau3, V, expMean, expCov, 
                       X, mxExpectationNormal("expCov","expMean", 
                       dimnames=paste("y", 1:k, sep="_")),
                       mxFitFunctionML() )
```

* The parameter estimates (and their _SE_s) for $\beta_0$, $\beta_1$, $\tau^2_2$ and $\tau^2_3$ were 0.1780 (0.0805), 0.0051 (0.0085), 0.0329 (0.0112) and 0.0565 (0.0300), respectively. 

```r
summary ( mxRun(mixed.model) )
```

```
Summary of Mixed effects model 
 
free parameters:
    name matrix row col   Estimate   Std.Error A
1  beta0  Beta0   1   1 0.17802679 0.080521925  
2  beta1  Beta1   1   1 0.00507372 0.008526627  
3 tau2_2   Tau2   1   1 0.03293902 0.011162044  
4 tau2_3   Tau3   1   1 0.05646285 0.030032971  

observed statistics:  56 
estimated parameters:  4 
degrees of freedom:  52 
fit value ( -2lnL units ):  16.43629 
number of observations:  11 
Information Criteria: 
      |  df Penalty  |  Parameters Penalty  |  Sample-Size Adjusted
AIC:      -87.56371               24.43629                       NA
BIC:     -108.25427               26.02787                 13.98387
To get additional fit indices, see help(mxRefModels)
timestamp: 2016-04-23 23:30:43 
Wall clock time (HH:MM:SS.hh): 00:00:00.11 
optimizer:  SLSQP 
OpenMx version number: 2.5.2 
Need help?  See help(mxSummary) 
```


References

Bornmann, L., Mutz, R., & Daniel, H.-D. (2007). Gender differences in grant peer review: A meta-analysis. _Journal of Informetrics_, _1(3)_, 226–238. 

Cheung, M.W.-L. (2009). Constructing approximate confidence intervals for parameters with structural equation models. _Structural Equation Modeling_, _16(2)_, 267-294. 

Cheung, M.W.-L. (2014). Modeling dependent effect sizes with three-level meta-analyses: A structural equation modeling approach. _Psychological Methods_, _19_, 211-229.

Cheung, M.W.-L. (2015). metaSEM: an R package for meta-analysis using structural equation modeling. _Frontiers in Psychology_, 5(1521). http://doi.org/10.3389/fpsyg.2014.01521

Cooper, H., Valentine, J.C., Charlton, K., & Melson, A. (2003). The effects of modified school calendars on student achievement and on school and community attitudes. _Review of Educational Research_, _73(1)_, 1 –52. 

Konstantopoulos, S. (2011). Fixed effects and variance components estimation in three-level meta-analysis. _Research Synthesis Methods_, _2(1)_, 61–76. 

Marsh, H.W., Bornmann, L., Mutz, R., Daniel, H.-D., & O’Mara, A. (2009). Gender effects in the peer reviews of grant proposals: A comprehensive meta-analysis comparing traditional and multilevel approaches. _Review of Educational Research_, _79(3)_, 1290–1326. 

Neale, M.C., & Miller, M.B. (1997). The use of likelihood-based confidence intervals in genetic models. _Behavior Genetics_, _27(2)_, 113–120. 
