*! version 1.2.1  27jul2015
program balance, sortpreserve
	syntax, [SUMmary UNWeighted Weighted width(integer 6)]
	* check that ps was last estimation command run
	if ("`e(cmd)'" != "ps" & "`e(cmd)'" != "dxwts" ) {
		error 301
	}
	
	* we create output table with estout, so check that it is installed
	capture which estout
	if _rc >0 {
		capture ssc install estout, replace
		local estout = _rc
	}
	else{
		local estout = 0
	}

	if "`summary'"!="" | ("`summary'"=="" & "`unweighted'"=="" & "`weighted'"=="") {
		if (`estout' !=0) {
			di "Summary"
			matrix list e(summary), noh f(%6.2f)
			display ""
			*display "Warning: estout could not be installed. Display of balance table will not have anticipated formatting." 
		}
		else{
			estout e(summary, f(%`width'.0g)), ti("Summary") mlabels(,none) note("") varwidth(10) modelwidth(`=`width'+2')
			*estout e(summary), ti("Summary") mlabels(,none) note("")
		}
	}
	
	if "`unweighted'"!="" {
		if (`estout' !=0) {
			di "Unweighted"
			matrix list e(unw), noh f(%10.2f)
			display ""
			*display "Warning: estout could not be installed. Display of balance table will not have anticipated formatting." 
		}
		else{
			estout e(unw, f(%`width'.0g)), ti("Unweighted") mlabels(,none) note("") varwidth(10) modelwidth(`=`width'+2')
		}
	}
	
	if "`weighted'"!="" {
		local weightvars `e(weightvars)'
		foreach var of local weightvars { 
			if (`estout' !=0) {
				di "Weighted: `var'"
				matrix list e(`var'), noh f(%10.2f)
				display ""
				*display "Warning: estout could not be installed. Display of balance table will not have anticipated formatting." 
			}
			else{
			di "`var'"
				estout e(`var', f(%`width'.0g)), ti("Weighted: `var'") mlabels(,none) note("") varwidth(10) modelwidth(`=`width'+2')
			}
		}
	}
	

	if (`estout'!=0) {
		display as text "Warning: estout could not be installed. Display of balance table will not have anticipated formatting."
	}
	
end
