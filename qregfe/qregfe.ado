*! v 1.0 Deployed FRA 
* Author: Fernando Rios-Avila
* Note: This is a wrapper for _qregfe_canay, _qregfe_cre and mmqreg
* All programs focus on the estimation of Quantile Regression with Fixed Effects
* The program requires reghdfe, ftools, and hdfe to be installed. 
* Parallel is optional, but recommended for speed with bootstrap
* There is a soft requirement for Stata 15 or higher, but it may work in earlier versions

program define qregfe, eclass

    if c(stata_version) >=15 {
        syntax [anything(everything)], [* BOOT BOOT1(str asis) /// Options for Bootstrap
                                        parallel parallel_cluster(int 2) /// Parallel for more power
                                        CANAY CANAY1(str asis) /// Options for Canay: Normal or Modified
                                        CRE   CRE1(str asis) /// Options for CRE: Normal or Compact
                                        MMQREG /// <- Plain Simple. But only accepts Boot
                                        seed(str asis) ] // Seed for Reproducibility

    }
    else {
        display "This program has been tested using Stata 15 or higher. It may not work properly in earlier versions."
        syntax [anything(everything)], [* BOOT BOOT1(str asis) /// Options for Bootstrap
                                        parallel parallel_cluster(int 2) /// Parallel for more power
                                        CANAY CANAY1(str asis) /// Options for Canay: Normal or Modified
                                        CRE   CRE1(str asis) /// Options for CRE: Normal or Compact
                                        MMQREG /// <- Plain Simple. But only accepts Boot
                                        seed(str asis) ] // Seed for Reproducibility
    }

	if replay() {
		display_results, `options'
        exit
    }
	else {

        if "`seed'"!="" set seed `seed'
        ** Required Program
        qui:capture which reghdfe
        if _rc!=0 {
            display as error "reghdfe is not installed. Please install it from SSC"
            display as error `"{stata "ssc install reghdfe"}"'
            error 101
        }
        qui:capture which ftools
        if _rc!=0 {
            display as error "ftools is not installed. Please install it from SSC"
            display as error `"{stata "ssc install ftools"}"'
            error 101
        }
        qui:capture which hdfe
        if _rc!=0 {
            display as error "hdfe is not installed. Please install it from SSC"
            display as error `"{stata "ssc install hdfe"}"'
            error 101
        }
        
        ** Checking for Canay and CRE
        if ("`canay'`canay1'"!="")+("`cre'`cre1'"!="")+("`mmqreg'"!="")>1 {
            display as error "You cannot Specify more than one method"
            error 110
        }

        if "`parallel'"!="" {
            capture which parallel
            if _rc!=0 {
                display as error "parallel is not installed. Please install it from GitHub"
                display as error `"{stata "net install parallel, from(https://raw.github.com/gvegayon/parallel/stable/) replace"}"'
                error 102
            }
        }

 
        
        /*** IF CANAY ***/
        if "`canay'`canay1'"!="" {
                if "`boot'`boot1'"!="" & "`parallel'"=="" {
                    ** Simple Bootstrap
                    capture : bootstrap, `boot1': _qregfe_canay `0'    
                    syntax varlist(fv ts) [if] [in] ,  [*] Quantile(numlist) ABSorb(varlist)
                        gettoken yvar aux: varlist
                    	ereturn local depvar "`yvar'"
                        ereturn local quantile `quantile'
                        ereturn local absorb "`absorb'"
                        ereturn local cmd "qregfe"
                        ereturn local cmdline qregfe `0'
                    if _rc==0 display_results    
                }
            else if "`boot'`boot1'"!="" & "`parallel'"!="" {
                    ** Parallel Bootstrap
                    parallel initialize `parallel_cluster'
                    capture : parallel bs, `boot1': _qregfe_canay `0' 
                    ** Recover for display
                    syntax varlist(fv ts) [if] [in] ,  [*] Quantile(numlist) ABSorb(varlist)
                        gettoken yvar aux: varlist
                    	ereturn local depvar "`yvar'"
                        ereturn local quantile `quantile'
                        ereturn local absorb "`absorb'"
                        ereturn local cmd "qregfe"
                        ereturn local cmdline qregfe `0'
                    
                    if _rc==0 display_results
            }
            else {
                ** NO Bootstrap
                _qregfe_canay `0'             
            }
        }
        /*** IF CRE ***/
        else if "`cre'`cre1'"!="" {
                if "`boot'`boot1'"!="" & "`parallel'"=="" {
                    ** Simple Bootstrap
                    qui: bootstrap, `boot1': _qregfe_cre `0'    
                    syntax varlist(fv ts) [if] [in] ,  [*] Quantile(numlist) ABSorb(varlist)
                        gettoken yvar aux: varlist
                    	ereturn local depvar "`yvar'"
                        ereturn local quantile `quantile'
                        ereturn local absorb "`absorb'"
                        ereturn local cmd "qregfe"
                        ereturn local cmdline qregfe `0'
                    if _rc==0 display_results    
                }
            else if "`boot'`boot1'"!="" & "`parallel'"!="" {
                    ** Parallel Bootstrap
                    parallel initialize `parallel_cluster'
                    qui: parallel bs, `boot1': _qregfe_cre `0' 
                    ** Recover for display
                    syntax varlist(fv ts) [if] [in] ,  [*] Quantile(numlist) ABSorb(varlist)
                        gettoken yvar aux: varlist
                    	ereturn local depvar "`yvar'"
                        ereturn local quantile `quantile'
                        ereturn local absorb "`absorb'"
                        ereturn local cmd "qregfe"
                        ereturn local cmdline qregfe `0'
                    
                    if _rc==0 display_results
            }
            else {
                ** NO Bootstrap
                _qregfe_cre `0'             
            }
        }
        else if "`mmqreg'"!="" {
                    mmqreg `0'
                    ereturn local cmd "qregfe"
                    ereturn local wcmd "mmqreg"
                    ereturn local cmdline qregfe `0'
        }            
        else {
            display as error "Need to provide a method. CRE, Canay, or mmqreg"
            error 111
        }
    }      
end
 
program display_parser, rclass
	syntax  ,  [ level(passthru) * ///
									 noci               ///
									 nopvalues          ///
									 noomitted          ///
									 vsquish            ///
									 noemptycells       ///
									 baselevels         ///
									 allbaselevels      ///
									 nofvlabel          ///
									 fvwrap(passthru)   ///
									 fvwrapon(passthru) ///
									 cformat(passthru)  ///
									 pformat(passthru)  ///
									 sformat(passthru)  ///
									 nolstretch ]
	return local display_opt `level' `noci' `nopvalues' `noomitted' `vsquish' `noemptycells' `baselevels' `allbaselevels' `nofvlabel' `fvwrap' `fvwrapon' `cformat' `pformat' `sformat' `nolstretch'
    return local other_opt `options'
end

program display_results
    syntax [anything(everything)], [*]
    display_parser, `options'
    if "`e(wcmd)'"=="qregfe" {
        display "Quantile Regression with Fixed Effects"
        `e(cmd)', `display_opt'
        display "Dependent Variable: `e(depvar)'"
        display "Quantile(s): `e(quantile)'"
        display "Fixed Effects: `e(absorb)'"
    }
    else {
        display in red "last estimates not found"
        error 301
    }
end 
