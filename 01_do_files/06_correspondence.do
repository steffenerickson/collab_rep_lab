********************************************************************************
		   *Correspondence Test function (not a function yet :( ) *
********************************************************************************

/*

	*mata inputs 
	mata clear 
	refstudy = 3
	alpha = .05
	e_th = 1
	
	*stata matrix input 
	*Input is Matrix T with Treatment Effects and SE's 
*/

********************************************************************************
	                ** a. DISTANCE BASED MEASURES ** 
********************************************************************************
	

	
	****************************************
	** i. Difference Test ** 
	****************************************	
	mata 
	
	T = st_matrix("T")
	TE = T[1,1...]'
	SE = T[2,1...]'
	c = cols(T)
	D = st_matrix("D")
	
	
	zstat = TE :/ SE
	
	pvalue = J(0,1,.)
	for (i=1;i<=length(zstat); i++) {	
		a = (1 - normal(zstat[i,1]))
		pvalue = (pvalue\a)
	}
	
	sig = pvalue :<= alpha 
	
	rtau = J(1,c-1,T[1,refstudy])'
	rse = J(1,c-1,T[2,refstudy])'	 

	ctau = J(0,1,.)
	cse = J(0,1,.)
	for (i=1;i<=c; i++) {
		if (i == refstudy) continue 
			
		else {
			a = T[1,i]
			b = T[2,i]
			ctau = (ctau\a)
			cse = (cse\b)
		}
	}
	
	poolse = sqrt(cse:^2 + rse:^2)
	
	delta = abs(rtau - ctau)
	
	zstatdelta = delta :/ poolse
	
	pvaluedelta = J(0,1,.)
	for (i=1;i<=length(zstatdelta); i++) {	
		a = (1 - normal(abs(zstatdelta[i,1])))
		pvaluedelta = (pvaluedelta\a)
	}
	
	sig_delta = pvaluedelta :<= alpha / 2 
	
	z_crit = abs(invnormal(.05/2))		

	upperciTE = TE +  z_crit:*SE 
	lowerciTE = TE + -z_crit:*SE
	ciTE = (lowerciTE,upperciTE)
	
	uppercidelta = delta + z_crit:*poolse
	lowercidelta= delta + -z_crit:*poolse
	cidelta = (lowercidelta,uppercidelta)
	
	
	effect_stats = (TE,SE,pvalue,ciTE, sig)
	
	difference_stats = (delta,poolse,pvaluedelta:*2,cidelta, sig_delta)

	
	
	st_matrix("effect_stats", effect_stats)
	st_matrix("difference_stats", difference_stats)
	
	end 
	

	****************************************
	** ii. Equivalence Test ** 
	****************************************
	
	mata 
	
	poolse = sqrt(cse:^2 + rse:^2)
	delta = abs(rtau - ctau)
	
	
	l_z_eq = (delta :+ -e_th):/poolse
	u_z_eq = (delta :+ e_th):/poolse
	z_eq = (l_z_eq,u_z_eq)
	
	// pval_below_e_th
	p_eqp = J(0,1,.)
	for (i=1;i<=length(l_z_eq); i++) {	
		a = (normal(l_z_eq[i,1]))
		p_eqp = (p_eqp\a)
	}
	
	// pval_above_e_th
	p_eqn = J(0,1,.)
	for (i=1;i<=length(u_z_eq); i++) {	
		a = ((1 - normal(u_z_eq[i,1])))
		p_eqn = (p_eqn\a)
	}
	
	p_eq = (p_eqp, p_eqn)
	
	sig_eq = J(0,1,.)
	for (i=1;i<=rows(p_eq ); i++) {

		if (p_eq[i,1] <= alpha  & p_eq[i,2] <= alpha) {
			a = 1 
			}
		else a = 0 
		
		sig_eq = (sig_eq\a)
	}
	
	equiv = (delta, p_eq, sig_eq)
	
	
	st_matrix("equiv_stats", equiv)
	
	end 
	
	****************************************
	** iii. Correspondence Test ** 
	****************************************
	
	mata 
	
	sig = (sig_delta,sig_eq)
	
	corr_test = J(0,1,"")
	for (i=1;i<=rows(sig); i++) {	
		if (sig[i,1] == 1 & sig[i,2] == 1 ) {
		 a = "Trivial Difference"
				} 
		if (sig[i,1] == 1 & sig[i,2] == 0 ) {
		 a = "Difference"  
				} 
		if (sig[i,1] == 0 & sig[i,2] == 1) {
		 a = "Equivalence"   
			   } 
		if ( sig[i,1] == 0 & sig[i,2] == 0) {
           a = "Indeterminacy"     
				} 
	corr_test = (corr_test\a)
	}
	
	
	corr_test_num = J(0,1,.)
	for (i=1;i<=rows(sig); i++) {	
		
		if (sig[i,1] == 1 & sig[i,2] == 1 ) {
		 a = 1
                } 
		if (sig[i,1] == 1 & sig[i,2] == 0 ) {
		 a = 2
                } 
		if (sig[i,1] == 0 & sig[i,2] == 1) {
		 a = 3
                } 
		if ( sig[i,1] == 0 & sig[i,2] == 0) {
		 a = 4
                } 
		
		corr_test_num = (corr_test_num\a)
		
	}

	corr_test

	correspondence = (sig_delta,sig_eq,corr_test_num)
	
	st_matrix("correspondence", correspondence)
	st_matrix("e_th", e_th)
	

	end 
	
	
	*Table Output * 
	
	scalar a = e_th[1,1]
	local b a
	
	*Distance Based Measures Output 
	

	*Treatment Effect Output row and col names 
	${table3rownames}
	matrix colnames effect_stats = "Treatment Effect" "Std Error" "P-value" "CI Lower" "CI Upper" "Significant"
	
	*Difference Test Output row and col names 
	${table3difftestrownames}
	matrix colnames difference_stats = "Difference" "Std Error" "P-value" "CI Lower" "CI Upper" "Significant"
	
	*Equivalence Test Output row and col names 
	${table3equivtestrownames}
	matrix colnames equiv_stats = "Difference" "P-value Below Threshhold" "P-value Above Threshhold" "Significant"
	
	*Correspondence Test Output row and col names 
	${table3corrtestrownames}
	matrix colnames correspondence = "Significant Difference Test" "Significant Equivalence Test" "Correspondence Test at `b' SD"

	
	
	esttab matrix(effect_stats) 
    esttab matrix(difference_stats)
	esttab matrix(equiv_stats)  
	esttab matrix(correspondence)
	
	#delimit ;
	
	di   
	   "---------------------------" _newline 
		  "Correspondence Test Key"    _newline 
	   "---------------------------"   _newline 
	   "| 1 = Trivial Difference  |"   _newline 
	   "| 2 = Difference          |"   _newline 
	   "| 3 = Equivalence         |"   _newline 
	   "| 4 = Indeterminacy       |"   _newline 
	   "---------------------------" ;
	#delimit cr
	
	
	
********************************************************************************
	                ** b. CONCLUSION BASED MEASURES ** 
********************************************************************************
	

  *       significance patterns
  *       Magnitude                     ?
  *       Sign of Effects 
