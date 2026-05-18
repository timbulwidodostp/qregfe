{smcl}
{* *! version 1.0.0  2024-03-02}{...}
{vieweralsosee "[R] qreg" "help qreg"}{...}
{vieweralsosee "reghdfe" "help reghdfe"}{...}
{vieweralsosee "" "--"}{...}
{viewerjumpto "Title" "qregfe##title"}{...}
{viewerjumpto "Syntax" "qregfe##syntax"}{...}
{viewerjumpto "Description" "qregfe##description"}{...}
{viewerjumpto "Examples" "qregfe##examples"}{...}
{viewerjumpto "References" "qregfe##references"}{...}
{viewerjumpto "Authors" "qregfe##authors"}{...}
{viewerjumpto "Also see" "qregfe##alsosee"}{...}
{cmd:help qregfe}{right: ({browse "https://doi.org/10.1177/1536867X261425793":SJ26-1: st0799})}
{hline}

{marker title}{...}
{title:Title}

{p2colset 5 15 17 2}{...}
{p2col :{cmd:qregfe} {hline 2}}Quantile regression with multiple fixed effects{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:qregfe}
{depvar} [{indepvars}] {ifin} {weight}{cmd:,}
{{cmd:cre}|{cmd:canay}|{cmd:canay(modified)}|{cmd:mmqreg}} 
[{it:options}]

{synoptset 28 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Quantile regression fixed-effects methods}
{p2coldent:* {opt cre}}use correlated random-effects (CRE) estimator{p_end}
{p2coldent:* {opt canay}}use Canay (2011) estimator{p_end}
{p2coldent:* {cmd:canay(modified)}}use modified Canay estimator{p_end}
{p2coldent:* {opt mmqreg}}use method of moments quantile regression estimator{p_end}

{syntab:Quantile regression specification}
{synopt :{opt q:uantile(#)}}specify the quantile for which
coefficients will be obtained; default is the median {cmd:quantile(50)}; the
values this could take depend on the {cmd:qmethod()} used; for example, if
{cmd:qmethod(sqreg)} is used, one could specify {cmd:quantile(10 25 90)} to
obtain the 10th, 25th, and 90th quantiles; however, if
{cmd:qmethod(qrprocess)} is used, one could specify 
{cmd:quantile(0.1 0.25 0.9)} to obtain the same quantiles; if using 
{cmd:mmqreg}, multiple quantiles
are always allowed{p_end}
{synopt :{opt abs:orb(varname)}}specify the variable that represents the
fixed effects to be absorbed; this is necessary for correlated random-effects
mean and Canay (2011) estimators; it is not necessary for the {cmd:mmqreg} 
estimator,  because the estimator still works for the case of no fixed effects
{p_end}

{syntab:Other}
{synopt :{opt qmethod(qmethod[, options])}}specify the
method to be used to estimate the quantile regression component; default is
{cmd:qmethod(qreg)}, but any other quantile regression command can be
used, though this will affect how {opt quantile()} is
specified; if necessary, one can also request {it:options}
that are specific to the quantile regression command used{p_end}
{synopt :{opt seed(#)}}specify the seed for the random-number generator{p_end}

{syntab:SE/Robust}
{synopt :{cmd:boot}[{cmd:(}{it:bootstrap_options}{cmd:)}]}request that bootstrap standard
errors be computed; by
default, standard errors correspond to the default from {cmd:qmethod()}, except for
{cmd:mmqreg},
which uses the generalized least-squares standard errors; {it:bootstrap_options} corresponds to the standard options for the
{cmd:bootstrap} in Stata, using the same results{p_end}
{synopt :{opt parallel}}request the estimation of bootstrap standard errors
to be
performed using
{cmd:parallel} (Vega Yon and Quistorff 2019), based on the
specifications given in {it:bootstrap_options}{p_end}
{synopt :{opt parallel_cluster(#)}}specify the number of parallel clusters to be
used for
the parallelization;
default is {cmd:parallel_cluster(2)}{p_end}

{syntab:{cmd:mmqreg} specific options}
{synopt :{opt robust}}robust standard errors for {cmd:mmqreg}{p_end}
{synopt :{opt cluster(varname)}}clustered standard errors for {cmd:mmqreg}{p_end}
{synopt :{opt dfadj}}adjust the degrees of freedom for the standard errors{p_end}
{synopt :{opt denopt(denmethod)}}request alternative options for the
estimator of the point density for the residual quantile; see 
{helpb qreg}, specifically the standard errors {it:vceopts}
section{p_end}
{synopt :{opt ls}}request that the location and scale coefficients be
displayed{p_end}
{synoptline}
{p 4 6 2}
One of {cmd:cre}, {cmd:canay}, {cmd:canay(modified)}, or {cmd:mmqreg} is
required.{p_end}
{p 4 6 2}
{opt pweight}s are allowed only when using the {cmd:mmqreg} method; see {help weight}.{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:qregfe} fits quantile regression models with multiple fixed effects.  It
implements several estimators: CRE, Canay (2011), a modified version of
Canay's estimator, and method of moments quantile regression.  The command
allows for absorbing multiple fixed effects and provides options for
bootstraping standard errors.

{pstd}
An earlier version of {cmd:mmqreg} is also available as an independent
command.  See {helpb mmqreg} for details (Rios-Avila 2020).

{pstd}
{cmd:qregfe} requires that {cmd:reghdfe} (Correia 2014), {cmd:hdfe} (Correia
2015), and {cmd:ftools} (Correia 2016) be installed.  This command has been
tested using Stata 15 or higher; it may work with earlier versions.


{marker examples}{...}
{title:Examples}

{pstd}
Estimate median regression with individual fixed effects using
CRE{p_end}
{phang2}{cmd:. qregfe wage educ exper, quantile(50) absorb(id) cre}

{pstd}
Estimate 75th quantile regression with individual and time fixed effects using Canay estimator{p_end}
{phang2}{cmd:. qregfe wage educ exper, quantile(75) absorb(id year) canay}

{pstd}
Estimate 25th quantile regression using method of moments quantile
regression with bootstrap standard errors{p_end}
{phang2}{cmd:. qregfe wage educ exper, quantile(25) absorb(id) mmqreg boot}
 

{marker references}{...}
{title:References}

{phang}
Canay, I. A. 2011. A simple approach to quantile regression for panel data.
{it:Econometrics Journal} 14: 368-386. 
{browse "https://doi.org/10.1111/j.1368-423X.2011.00349.x"}.

{phang}
Correia, S. 2014. reghdfe: Stata module to perform linear or
instrumental-variable regression absorbing any number of high-dimensional
fixed effects. Statistical Software Components S457874, Department of
Economics, Boston College.
{browse "https://ideas.repec.org/c/boc/bocode/s457874.html"}.

{phang}
-----. 2015. hdfe: Stata module to partial out variables with respect to a set
of fixed effects. Statistical Software Components S457985, Department of
Economics, Boston College.
{browse "https://ideas.repec.org/c/boc/bocode/s457985.html"}.

{phang}
-----. 2016. ftools: Stata module to provide alternatives to common Stata
commands optimized for large datasets. Statistical Software Components S458213,
Department of Economics, Boston College.
{browse "https://ideas.repec.org/c/boc/bocode/s458213.html"}.

{phang}
Rios-Avila, F. 2020. mmqreg: Stata module to estimate quantile regressions
via method of moments. Statistical Software Components S458750, Department of
Economics, Boston College.
{browse "https://ideas.repec.org/c/boc/bocode/s458750.html"}.

{phang}
Vega Yon, G. G., and B. Quistorff. 2019. parallel: A command for parallel
computing. {it:Stata Journal} 19: 667-684. 
{browse "https://doi.org/10.1177/1536867X19874242"}.


{marker authors}{...}
{title:Authors}

{pstd}
Fernando Rios-Avila{break}
Universidad Privada Boliviana, La Paz, Bolivia{break}
and{break}
London School of Economics and Political Science, London, UK{break}
friosa@upb.edu

{pstd}
Leonardo Siles{break}
Universidad de Chile{break}
Santiago, Chile{break}
lsiles@fen.uchile.cl

{pstd}
Gustavo Canavire-Bacarreza{break}
The World Bank, Washington, DC{break}
and{break}
Universidad Privada Boliviana, La Paz, Bolivia
gcanavire@worldbank.org


{marker alsosee}{...}
{title:Also see}

{p 4 14 2}
Article:  {it:Stata Journal}, volume 26, number 1: {browse "https://doi.org/10.1177/1536867X261425793":st0799}{p_end}

{p 7 14 2}
Help:  {helpb qregplot}, {helpb mmqreg}, {helpb reghdfe}, {helpb bsqreg}, {helpb qrprocess} (if installed){p_end}
