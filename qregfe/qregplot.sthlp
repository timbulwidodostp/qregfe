{smcl}
{* 24 Feb 2022}{...}
{cmd:help qregplot}{right: ({browse "https://doi.org/10.1177/1536867X261425793":SJ26-1: st0799})}
{hline}

{marker title}{...}
{title:Title}

{p2colset 5 17 19 2}{...}
{p2col :{cmd:qregplot} {hline 2}}Command for plotting coefficients of a
quantile regression{p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:qregplot}
[{it:varlist}]
[{cmd:,} {it:options}]

{phang}
{it:varlist} selects variables that will be plotted.  If none is provided, all
coefficients except the intercept will be plotted.  This accepts factor
notation.

{synoptset 30 tabbed}{...}
{marker options}{...}
{synopthdr :options}
{synoptline}
{synopt:{opt q:uantiles(numlist)}}specify the list of quantiles to be
plotted; the default is {cmd:quantiles(10(5)90)};
if the underlying model was fit using {cmd:sqreg}, this is superseded by the
quantiles used in the simultaneous quantile regression (QR) model{p_end}
{synopt:{cmd:cons}}request that the constant term be plotted{p_end}
{synopt:{cmd:ols}}request that the ordinary least-squares (OLS) coefficients
and the QR coefficients all be estimated and plotted; the default is not to
plot them; when requested, the OLS specification will follow the same
specification as the QR model but will not include the absorbed fixed effects
unless specified using {cmd:olsopt()}{p_end}
{synopt:{opt olsopt(regress_options)}}specify the options to be used for the
OLS estimation; all options available for {cmd:regress} can be specified here;
if one requests that fixed effects be absorbed, the command will use
{cmd:reghdfe} to fit the OLS model{p_end}
{synopt:{opt seed(#)}}specify the seed for the random-number generator so that
the same seed is used across quantiles{p_end}
{synopt:{cmd:label}}request that variable labels be used as titles for each
coefficient plot; the default is to use variable names{p_end}
{synopt:{cmd:labelopt(}{help qregplot##label_options:{it:label_options}}{cmd:)}}provide additional
information to handle "long" variable labels{p_end}
{synopt:{opt mtitle:s(titles)}}provide titles for each subgraph; if not enough
titles are provided, the command will use either the variable names or the
variable labels; they should be written within double quotes; for example,
{cmd:mtitles("first" "second")} will use {cmd:first} and {cmd:second} as title
graphs; see examples for details{p_end}
{synopt:{cmdab:ra:opt}{cmd:(}{it:rarea_options}{cmd:)}}provide options to be
used in the {helpb twoway rarea} part of the graph; this controls the aspects
of the confidence intervals; default is 
{cmd:raopt(pstyle(p1) fintensity(30) lwidth(none))}{p_end}
{synopt:{cmdab:ln:opt}{cmd:(}{it:line_options}{cmd:)}}provide options to be used
in the {helpb twoway line} part of the graph; this controls 
aspects of the point estimates;
the default is {cmd:lnopt(pstyle(p1) lwidth(0.3))}{p_end}
{synopt:{cmdab:two:pt}{cmd:(}{it:twoway_options}{cmd:)}}provide options to be
used for the two-way graph that combines the {cmd:rarea} and {cmd:line} plots;
the default option is to set the graph and plot region margins to
{cmd:vsmall}{p_end}
{synopt:{it:graph_combine_options}}used to combine multiple graphs; users can
include any {helpb graph combine} option directly in the command; this will be
added in the last step, which combines the graphs and will not affect the
individual plots; however, if only one coefficient is plotted, options that
are specified directly will affect the two-way plot{p_end}
{synopt:{cmd:estore}{cmd:(}{it:name}{cmd:)}}request that the results be
stored in memory; this is similar to {helpb estimates store}{p_end}
{synopt:{opt esave(filename)}}request that the results be saved as a
{cmd:.ster} file; this is similar to {helpb estimates save}{p_end}
{synopt:{cmd:from}{cmd:(}{it:name}{cmd:)}}request that stored results from
memory be used to plot the quantile coefficients; this is similar to 
{helpb estimates restore}; if results were saved to a file, one should first
use {helpb estimates use} {it:filename} to load the results into memory and
then store them into memory with a name{p_end}
{synoptline}

{synoptset 20}{...}
{marker label_options}{...}
{synopthdr :label_options}
{synoptline}
{synopt:{opt lines(#L)}}request to break a label into {it:#L} lines{p_end}
{synopt:{opt maxlength(#k)}}request to break a label into lines of
max length {it:#k}; this will be superseded by lines if {it:#k} is too small to
break a label into {it:#L} lines{p_end}
{synoptline}


{title:Description}

{pstd}
{cmd:qregplot} graphs the coefficients of a QR produced by various commands
that produce quantile coefficients, including {cmd:qreg}, {cmd:bsqreg},
{cmd:sqreg}, {cmd:mmqreg} (Rios-Avila 2020a), {cmd:smqreg}*, {cmd:sivqr}
(Kaplan and Sun 2017), and {cmd:rifhdreg} (Rios-Avila 2020b) (for
unconditional quantiles).{p_end}

{p 4 6 2}
* If you are interested or curious about {cmd:smqreg}, email me at
friosavi@levy.org.{p_end}

{pstd}
{cmd:qregplot} works similarly to {helpb grqreg} (Azevedo 2004) but provides
added options to give the user more control on the creation of the requested
figures, also allowing for the use of factor notation.{p_end}

{pstd}The command works as follows:{p_end}

{p 8 16 2}
Step 1. It gathers all the information of a previously fitted model (for
example, via {helpb qreg}).  This information is used as the template for the
estimation of QR models across the distribution.{p_end}

{p 8 16 2}
Step 2. Using the information from step 1, {cmd:qregplot} fits N QRs,
following the same specification as the original model.  One can select which
quantiles will be used for the estimation of these models.{p_end}

{p 8 16 2}
Step 3. Once all coefficients and confidence intervals are stored,
{cmd:qregplot} plots all requested coefficients using the {cmd:twoway rarea}
command for plotting confidence intervals combined with the {cmd:twoway line}
command for plotting the point estimates.  Each figure is stored temporarily
as a graph in memory.{p_end}

{p 8 17 2}
Step 3b. If requested, OLS coefficients and confidence interval are added to
each figure in step 3.{p_end}

{p 8 16 2}
Step 4. If more than one variable is requested for plotting, all plots from
step 3 are combined using {cmd:graph combine}.{p_end}

{pstd}
The only exception to this process is {helpb sqreg}.  When used after this
command, coefficients are collected from {cmd:sqreg} output rather than
reestimated.{p_end}

{pstd}
Standard errors are estimated based on the original command specifications.
For example, if {cmd:qreg} was first estimated using {cmd:vce(robust)},
{cmd:qregplot} will use the same type of standard errors for plotting.

{pstd}
Because the most time-consuming part of QRs is the estimation of the
regressions themselves, specially if using bootstrap standard errors, one can
use {cmd:qregplot} to store all coefficients and confidence intervals in
memory using the option {opt estore()}.  The advantage of doing this is that
plots can be created using the stored coefficients directly.

{pstd}
In all cases, confidence intervals are plotted automatically using the same
level of confidence as the original estimation specification (typically 95%).


{marker Examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}
{bf:. {stata webuse womenwk}}

{pstd}
Simple conditional QR using {helpb qreg}{p_end}
{phang2}
{bf:. {stata qreg wage age education i.married children i.county}}

{pstd}
Plotting all coefficients of interest for quantiles 5 through 95 in increments
of 2.5, storing coefficients in {cmd:qp}{p_end}
{phang2}
{bf:. {stata qregplot age education i.married children, quantiles(5(2.5)95) estore(qp)}}

{pstd}
Same as above but adding OLS coefficients and confidence interval{p_end}
{phang2}
{bf:. {stata qregplot age education i.married children, quantiles(5(2.5)95) ols }}

{pstd}
Changing the look for the confidence interval across quantiles{p_end}
{phang2}
{bf:. {stata qregplot age education i.married children, quantiles(5(2.5)95) ols raopt( color(black%5))}}

{pstd}
Same as above but plotting in only one column for the combined graph{p_end}
{phang2}
{bf:. {stata qregplot age education i.married children, quantiles(5(2.5)95) ols raopt( color(black%5)) col(1) }}

{pstd}
Same as above but changing the aspect of the graph for better readability{p_end}
{phang2}
{bf:. {stata qregplot age education i.married children, quantiles(5(2.5)95) ols  col(1) ysize(20) xsize(8) }}

{pstd}
Using only three variables and results from {cmd:qp} (see above){p_end}
{phang2}{bf:. {stata qregplot age education  children, from(qp) }}

{pstd}
Same as above but using labels as titles{p_end}
{phang2}{bf:. {stata qregplot age education  children, from(qp) label }}

{pstd}
Same as above but using own titles for figures 1 and 2{p_end}
{phang2}{bf:. {stata qregplot age education  children, from(qp) label mtitles("Age in years since 1980" "Years of education")}}

{pstd}
Same as above but using own titles for figures 1 and 2, written in two lines{p_end}
{phang2}{bf:. {stata qregplot age education  children, from(qp) label mtitles("Age in years since 1980 I want this to be long" "Years of education, including Highschool and college") labelopt(lines(2)) }}  

{pstd}
Using alternative estimator {cmd:bsqreg}{p_end}
{phang2}
{bf:. {stata bsqreg wage age education i.married children i.county}}{p_end}
{phang2}
{bf:. {stata qregplot age education i.married children, quantiles(5(5)95)  }}

{pstd}
Using alternative estimator {cmd:qrprocess} (Chernozhukov,
Fern{c a'}ndez-Val, and Melly 2022){p_end}
{phang2}
{bf:. {stata qrprocess wage age education i.married children i.county}}{p_end}
{phang2}
{bf:. {stata qregplot age education i.married children, quantiles(5(5)95)  }}

{pstd}
Using alternative estimator {cmd:qreg2} (Machado, Parente, and Santos Silva
2011){p_end}
{phang2}
{bf:. {stata qreg2 wage age education i.married children i.county}}{p_end}
{phang2}
{bf:. {stata qregplot age education i.married children, quantiles(5(5)95)  }}

{pstd}
Using alternative estimator {cmd:ivqreg2} (Machado and Santos Silva 2018){p_end}
{phang2}
{bf:. {stata ivqreg2 wage age education married, inst(age education married   children)}}{p_end}
{phang2}
{bf:. {stata qregplot age education married, quantiles(5(5)95)  }}

{pstd}
Using alternative estimator {cmd:xtqreg} (Machado and Santos Silva 2019){p_end}
{phang2}
{bf:. {stata xtqreg wage age education i.married children, i(county) }}{p_end}
{phang2}
{bf:. {stata qregplot age education i.married children, quantiles(5(5)95)  }}

{pstd}
Using alternative estimator {cmd:mmqreg}{p_end}
{phang2}
{bf:. {stata mmqreg wage age education i.married children }}{p_end}
{phang2}
{bf:. {stata qregplot age education i.married children, quantiles(5(5)95)  }}

{pstd}
Using alternative estimator {cmd:sqreg}{p_end}
{phang2}
{bf:. {stata sqreg wage age education i.married children i.county, quantiles(10 25 50 75 90)}}{p_end}
{phang2}
{bf:. {stata qregplot age education i.married children}}

{pstd}
Using alternative estimator {cmd:rifhdreg}{p_end}
{phang2}
{bf:. {stata rifhdreg wage age education i.married children i.county, rif(q(50)) }}{p_end}
{phang2}
{bf:. {stata qregplot age education i.married children, quantiles(5(5)95)  }}

{pstd}
Using alternative estimator {cmd:sivqr}{p_end}
{phang2}
{bf:. {stata sivqr wage age education married children, quantiles(50) }}{p_end}
{phang2}
{bf:. {stata qregplot age education married children, quantiles(5(5)95)  }}

{pstd}
Storing regressions information in memory{p_end}
{phang2}
{bf:. {stata qreg wage age education i.married children i.county, quantiles(50) }}{p_end}
{phang2}
{bf:. {stata qregplot age education i.married children, quantiles(5(5)95) estore(qreg_1) }}

{pstd}
Plotting coefficients from stored estimations{p_end}
{phang2}
{bf:. {stata qregplot age education i.married children, from(qreg_1) }}

{pstd}
Same as above but using labels for titles{p_end}
{phang2}
{bf:. {stata qregplot age education i.married children, from(qreg_1) label }}


{marker Acknowledgements}{...}
{title:Acknowledgements}

{pstd}
This command was created as a companion for {helpb rifhdreg} to make it
easier to plot coefficients across different quantiles but also as an answer
to a regular question regarding plotting dummies with {helpb grqreg} when
using factor notation.{p_end}

{pstd}
This commands requires {cmd:ftools} (Correia 2016) for expanding {it:varlist}s
with factor notation.{p_end}

{pstd}
The usual disclaimer applies.{p_end}


{marker references}{...}
{title:References}

{phang}
Azevedo, J. P. 2004. grqreg: Stata module to graph the coefficients of a
quantile regression. Statistical Software Components S437001, Department of Economics, Boston
College. {browse "https://ideas.repec.org/c/boc/bocode/s437001.html"}.

{phang}
Chernozhukov, V., I. Fern{c a'}ndez-Val, and B. Melly. 2022. Fast algorithms
for the quantile regression process. {it:Empirical Economics} 62: 7-33.
{browse "https://doi.org/10.1007/s00181-020-01898-0"}.

{phang}
Correia, S. 2016. ftools: Stata module to provide alternatives to common Stata
commands optimized for large datasets. Statistical Software Components
S458213, Department of Economics, Boston College.
{browse "https://ideas.repec.org/c/boc/bocode/s458213.html"}.

{phang}
Kaplan, D. M., and Y. Sun. 2017. Smoothed estimating equations for
instrumental variables quantile regression. {it:Econometric Theory} 
33: 105-157. {browse "https://doi.org/10.1017/S0266466615000407"}.

{phang}
Machado, J. A. F., P. M. D. C. Parente, and J. M. C. Santos Silva. 2011.
qreg2: Stata module to perform quantile regression with robust and clustered
standard errors.  Statistical Software Components S457369, Department of
Economics, Boston College.
{browse "https://ideas.repec.org/c/boc/bocode/s457369.html"}.

{phang}
Machado, J. A. F., and J. M. C. Santos Silva. 2018. ivqreg2: Stata module to
provide structural quantile function estimation. Statistical Software
Components S458571, Department of Economics, Boston College.
{browse "https://ideas.repec.org/c/boc/bocode/s458571.html"}.

{phang}
-----. 2019. Quantiles via moments.
{it:Journal of Econometrics} 213: 145-173. 
{browse "https://doi.org/10.1016/j.jeconom.2019.04.009"}.

{phang}
Rios-Avila, F. 2020a. mmqreg: Stata module to estimate quantile regressions
via method of moments. Statistical Software Components S458750, Department of
Economics, Boston College.
{browse "https://ideas.repec.org/c/boc/bocode/s458750.html"}.

{phang}
-----. 2020b. Recentered influence functions (RIFs) in Stata: RIF regression and
RIF decomposition. {it:Stata Journal} 20: 51-94.
{browse "https://doi.org/10.1177/1536867X20909690"}.


{marker Author}{...}
{title:Author}

{pstd}Fernando Rios-Avila{break}
Universidad Privada Boliviana, La Paz, Bolivia{break}
and{break}
London School of Economics and Political Science, London, UK{break}
friosa@upb.edu


{title:Also see}

{p 4 14 2}
Article:  {it:Stata Journal}, volume 26, number 1: {browse "https://doi.org/10.1177/1536867X261425793":st0799}{p_end}

{p 7 14 2}
Help:  {manhelp qreg R}, {helpb qreg2}, {helpb ivqreg2}, {helpb qrprocess}, 
{helpb bsqreg}, {helpb sqreg}, {helpb rifhdreg}, {helpb xtqreg}, {helpb mmqreg},
{helpb sivqr} (if installed){p_end}
