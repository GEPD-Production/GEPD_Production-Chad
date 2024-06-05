clear all

*set the paths
gl data_dir ${clone}/01_GEPD_raw_data/
gl processed_dir ${clone}/03_GEPD_processed_data/


*save some useful locals
local preamble_info_individual school_code 
local preamble_info_school school_code 
local not school_code
local not1 interview__id

***************
***************
* School File
***************
***************

********
*read in the raw school file
********
frame create school
frame change school

use "${data_dir}\\School\\EPDash_final.dta" 

********
*read in the school weights
********

frame create weights
frame change weights
import delimited "${data_dir}\\Sampling\\GEPD_TCD_weights_2023-05-31.csv"

* rename school code
*rename school_code ${school_code_name}

drop if school_code==585 & telephone_etablissement!="63170595"
drop if      school_code==773 & telephone_etablissement!="65941064"
drop if      school_code==2132 & telephone_etablissement!="91379418"
drop if      school_code==5737 & ipep!="MATADJANA"
drop if      school_code==5875 & ipep!="MOUSSORO URBAIN"
drop if      school_code==6699 & dpen!="HADJER LAMIS"
drop if      school_code==6950 & telephone_etablissement!="66031532/90684733"
drop if      school_code==7404 & ipep!="DABANSAKA URBAIN (MASSAGUET)"
drop if         school_code==12380 & ipep!="10EME ARROND N DJAMENA A"
drop if     school_code==220586 & ipep!="KALAÏT"
drop if      school_code==221233 & ipep!="DAGANA URBAIN"
drop if      school_code==224357 & ipep!="AM TIMAN URBAIN"
drop if    school_code==225988 & ipep!="5EME ARROND N DJAMENA"



keep school_code ${strata} urban_rural public strata_prob ipw 
destring school_code, replace force
destring ipw, replace force
duplicates drop school_code, force

******
* Merge the weights
*******
frame change school

gen school_code = m1s0q2_emis

destring school_code, replace force
replace school_code = 222760 if school_code==22760

drop if missing(school_code)

frlink m:1 school_code, frame(weights)
frget ${strata} urban_rural public strata_prob ipw, from(weights)

*correcting some errors
replace school_name_preload ="Information a completer" if school_name_preload=="Information � compl�ter"
replace school_address_preload="Information a completer" if school_address_preload=="Information � compl�ter"

replace school_name_preload ="ECOLE CENTRE A DE MASSAKORY, REGION DE HADJER LAMIS" if school_code==6699 
replace school_province_preload="HADJER LAMIS" if school_code==6699 
replace school_name_preload ="CS EVANGELIQUE NEHEMIE" if school_code==8669
replace school_name_preload="RENAISSANCE ARABE DE SARH" if school_code==10342
replace school_province_preload="MOYEN CHARI" if school_code==10342
replace school_province_preload="Information a completer" if school_code==8669
replace school_province_preload="LOGONE OCCIDENTAL" if school_code==221377 
replace school_province_preload="" if school_code==223748 & school_address_preload=="2EME ET 3EME ARROND MOUNDOU"
replace school_province_preload="LOGONE OCCIDENTAL" if school_code==223748 & school_address_preload=="2EME ET 3EME ARROND MOUNDOU"
replace school_province_preload="Information a completer" if school_province_preload=="Information � compl�ter"


// adding a unique_school_code varibale becuase the sampling frame had same code for different schools
unique school_code    //261 only identified
unique school_name_preload school_code //266 idenfied
unique school_name_preload school_code school_address_preload //267 identified 
unique school_name_preload school_code school_address_preload school_province_preload //267 identified 

egen school_code_unique = group(school_name_preload school_code school_address_preload )
unique school_code_unique

*create weight variable that is standardized
gen school_weight=1/strata_prob // school level weight

*fourth grade student level weight
egen g4_stud_count = mean(m4scq4_inpt), by(school_code)
egen g2_stud_count = mean(m4scq4_inpt_g2), by(school_code)


* drop if school weight missing as these could not be found in sampling frame
*br if missing(school_weight)
drop if missing(school_weight)

*create collapsed school file as a temp
frame copy school school_collapse_temp
frame change school_collapse_temp

order school_code
sort school_code

* collapse to school level
ds, has(type numeric)
local numvars "`r(varlist)'"
local numvars : list numvars - not

ds, has(type string)
local stringvars "`r(varlist)'"
local stringvars : list stringvars- not

collapse (max) `numvars' (firstnm) `stringvars', by(school_code)


***************
***************
* Teacher File
***************
***************

frame create teachers
frame change teachers
********
* Addtional Cleaning may be required here to link the various modules
* We are assuming the teacher level modules (Teacher roster, Questionnaire, Pedagogy, and Content Knowledge have already been linked here)
* See Merge_Teacher_Modules code folder for help in this task if needed
********
log using "${clone}\02_programs\School\Raw_data_cleaning.smcl", replace
use "${data_dir}\\School\\TCD_teacher_level.dta" 
log off

cap drop urban_rural
cap drop public
cap drop school_weight
cap drop $strata

log on
*fix a school code
replace school_code = 222760 if school_code==22760
log off


** correcting some mistakes 
replace school_name_preload ="Information a completer" if school_name_preload=="Information � compl�ter"
replace school_province_preload="HADJER LAMIS" if school_code==6699 
replace school_province_preload="MOYEN CHARI" if school_code==10342
replace school_province_preload="Information a completer" if school_province_preload=="Information � compl�ter"
replace school_province_preload="LOGONE OCCIDENTAL" if school_code==221377 
replace school_province_preload="LOGONE OCCIDENTAL" if school_code==223748 & school_province_preload=="LOGONE OCCIDENTAL"


frlink m:1 school_code school_province_preload, frame(school_collapse_temp) 
frget school_code ${strata} urban_rural public school_weight numEligible numEligible4th school_code_unique, from(school_collapse_temp)



*get number of 4th grade teachers for weights
egen g4_teacher_count=sum(m3saq2_4), by(school_code)
egen g1_teacher_count=sum(m3saq2_1), by(school_code)
egen g2_teacher_count=sum(m3saq2_2), by(school_code)

log on
*fix teacher id for a few cases
replace teachers_id=m4saq1_number if missing(teachers_id)

list school_code teachers_id m2saq2 m3sb_troster m3sb_tnumber m4saq1 m4saq1_number m5sb_troster m5sb_tnumber if missing(teachers_id), compress
drop if missing(teachers_id)

log off
log close

order school_code
sort school_code


*weights
*teacher absense weights
*get number of teachers checked for absense
egen teacher_abs_count=count(m2sbq6_efft), by(school_code)
gen teacher_abs_weight=numEligible/teacher_abs_count
replace teacher_abs_weight=1 if missing(teacher_abs_weight) //fix issues where no g1 teachers listed. Can happen in very small schools

*teacher questionnaire weights
*get number of teachers checked for absense
egen teacher_quest_count=count(m3s0q1), by(school_code)
gen teacher_questionnaire_weight=numEligible4th/teacher_quest_count
replace teacher_questionnaire_weight=1 if missing(teacher_questionnaire_weight) //fix issues where no g1 teachers listed. Can happen in very small schools

*teacher content knowledge weights
*get number of teachers checked for absense
egen teacher_content_count=count(m3s0q1), by(school_code)
gen teacher_content_weight=numEligible4th/teacher_content_count
replace teacher_content_weight=1 if missing(teacher_content_weight) //fix issues where no g1 teachers listed. Can happen in very small schools

*teacher pedagogy weights
gen teacher_pedagogy_weight=numEligible4th/1 // one teacher selected
replace teacher_pedagogy_weight=1 if missing(teacher_pedagogy_weight) //fix issues where no g1 teachers listed. Can happen in very small schools

drop if missing(school_weight)


*checking duplicates 
unique school_code teachers_id

duplicates tag school_code teachers_id, gen(dups)
	tab dups
	tab dups, nol
	br if dups>0   //Seems more like the modules are split on two lines -- but some seem to be unique observations with a wrong ID
	
	/*For observations split on two lines (Will create a procedure for each school)
		to merge the obs split on two lines (done once for numeric vars and another for string vars). 
		
	*For unique observations with a wrong ID, we leave as is. 
					*/
	
sort school_code teachers_id, stable 

	
//-----1st obs dup (school_code 116 and teacher_id 2)

ds, has(type numeric)  
foreach v in `r(varlist)' { 
	replace `v' =max(`v'[12], `v'[13]) if _n == 12 & dups==1  & `v'[13] !=. & (mi("`var'"[12]) | `var'[12]==0)
} 


ds, has(type string)  
foreach v in `r(varlist)' { 
	replace `v'=`v'[13] if _n == 12 & dups==1 & `v'[12]=="" & !missing("`v'"[13])
} 

		drop if _n==13
		
		
//-----2nd obs dup (school_code 2640 and teacher_id 5)

ds, has(type numeric)  
foreach v in `r(varlist)' { 
	replace `v' =max(`v'[341], `v'[342]) if _n == 341 & dups==1  & `v'[342] !=. & (mi("`var'"[341]) | `var'[341]==0)
} 


ds, has(type string)  
foreach v in `r(varlist)' { 
	replace `v'=`v'[342] if _n == 341 & dups==1 & `v'[341]=="" & !missing("`v'"[342])
} 

		drop if _n==342
		

//-----3rd obs dup (school_code 2679 and teacher_id 6)

ds, has(type numeric)  
foreach v in `r(varlist)' { 
	replace `v' =max(`v'[352], `v'[353]) if _n == 352 & dups==1  & `v'[353] !=. & (mi("`var'"[352]) | `var'[352]==0)
} 


ds, has(type string)  
foreach v in `r(varlist)' { 
	replace `v'=`v'[353] if _n == 352 & dups==1 & `v'[352]=="" & !missing("`v'"[353])
} 

		drop if _n==353
		

//-----4th obs dup (school_code 3258 and teacher_id 2)-- issue here is wrong teacher_id-- do nothing

* ....


//-----5th obs dup (school_code 5203 and teacher_id 3)

ds, has(type numeric)  
foreach v in `r(varlist)' { 
	replace `v' =max(`v'[619], `v'[620]) if _n == 619 & dups==1 & `v'[620] !=. & (mi("`var'"[619]) | `var'[619]==0)
} 


ds, has(type string)  
foreach v in `r(varlist)' { 
	replace `v'=`v'[620] if _n == 619 & dups==1 & `v'[619]=="" & !missing("`v'"[620])
} 

		drop if _n==620


//-----6th obs dup (school_code 5288 and teacher_id 3)

ds, has(type numeric)  
foreach v in `r(varlist)' { 
	replace `v' =max(`v'[623], `v'[624]) if _n == 623 & dups==1  & `v'[624] !=. & (mi("`var'"[623]) | `var'[623]==0)
} 


ds, has(type string)  
foreach v in `r(varlist)' { 
	replace `v'=`v'[624] if _n == 623 & dups==1 & `v'[623]=="" & !missing("`v'"[624])
} 

		drop if _n==624

		
//-----7th obs dup (school_code 5716 and teacher_id 1)-- issue here is wrong teacher_id-- do nothing

* ....


//-----8th obs dup (school_code 6261 and teacher_id 12)
ds, has(type numeric)  
foreach v in `r(varlist)' { 
	replace `v' =max(`v'[814], `v'[815]) if _n == 814 & dups==1  & `v'[815] !=. & (mi("`var'"[814]) | `var'[814]==0)
} 


ds, has(type string)  
foreach v in `r(varlist)' { 
	replace `v'=`v'[815] if _n == 814 & dups==1 & `v'[814]=="" & !missing("`v'"[815])
} 

		drop if _n==815

	
//-----9th obs dup (school_code 8371 and teacher_id 5)
ds, has(type numeric)  
foreach v in `r(varlist)' { 
	replace `v' =max(`v'[1013], `v'[1014]) if _n == 1013 & dups==1  & `v'[1014] !=. & (mi("`var'"[1013]) | `var'[1013]==0)
} 


ds, has(type string)  
foreach v in `r(varlist)' { 
	replace `v'=`v'[1014] if _n == 1013 & dups==1 & `v'[1013]=="" & !missing("`v'"[1014])
} 

		drop if _n==1014
		

//-----10th obs dup (school_code 8669 and teacher_id 2)
ds, has(type numeric)  
foreach v in `r(varlist)' { 
	replace `v' =max(`v'[1058], `v'[1059]) if _n == 1058 & dups==1  & `v'[1059] !=. & (mi("`var'"[1058]) | `var'[1058]==0)
} 


ds, has(type string)  
foreach v in `r(varlist)' { 
	replace `v'=`v'[1059] if _n == 1058 & dups==1 & `v'[1058]=="" & !missing("`v'"[1059])
} 

		drop if _n==1059
	
	
//-----11th obs dup (school_code 9344 and teacher_id 5)
ds, has(type numeric)  
foreach v in `r(varlist)' { 
	replace `v' =max(`v'[1109], `v'[1110]) if _n == 1109 & dups==1  & `v'[1110] !=. & (mi("`var'"[1109]) | `var'[1109]==0)
} 


ds, has(type string)  
foreach v in `r(varlist)' { 
	replace `v'=`v'[1110] if _n == 1109 & dups==1 & `v'[1109]=="" & !missing("`v'"[1110])
} 

		drop if _n==1110
	
//-----12th obs dup (school_code 9731 and teacher_id 2)
ds, has(type numeric)  
foreach v in `r(varlist)' { 
	replace `v' =max(`v'[1150], `v'[1151]) if _n == 1150 & dups==1  & `v'[1151] !=. & (mi("`var'"[1150]) | `var'[1150]==0)
} 


ds, has(type string)  
foreach v in `r(varlist)' { 
	replace `v'=`v'[1151] if _n == 1150 & dups==1 & `v'[1150]=="" & !missing("`v'"[1151])
} 

		drop if _n==1151
	
		
//-----13th obs dup (school_code 11575 and teacher_id 1)-- issue here is wrong teacher_id-- do nothing

***
	
//-----14th obs dup (school_code 12177 and teacher_id 4)
ds, has(type numeric)  
foreach v in `r(varlist)' { 
	replace `v' =max(`v'[1335], `v'[1336]) if _n == 1335 & dups==1  & `v'[1336] !=. & (mi("`var'"[1335]) | `var'[1335]==0)
} 


ds, has(type string)  
foreach v in `r(varlist)' { 
	replace `v'=`v'[1336] if _n == 1335 & dups==1 & `v'[1335]=="" & !missing("`v'"[1336])
} 

		drop if _n==1336	
	
	

//-----15th obs dup (school_code 220476 and teacher_id 3)
ds, has(type numeric)  
foreach v in `r(varlist)' { 
	replace `v' =max(`v'[1418], `v'[1419]) if _n == 1418 & dups==1  & `v'[1419] !=. & (mi("`var'"[1418]) | `var'[1418]==0)
} 


ds, has(type string)  
foreach v in `r(varlist)' { 
	replace `v'=`v'[1419] if _n == 1418 & dups==1 & `v'[1418]=="" & !missing("`v'"[1419])
} 

		drop if _n==1419
		
		

//-----16th obs dup (school_code 222140 and teacher_id 2)
ds, has(type numeric)  
foreach v in `r(varlist)' { 
	replace `v' =max(`v'[1595], `v'[1596]) if _n == 1595 & dups==1  & `v'[1596] !=. & (mi("`var'"[1595]) | `var'[1595]==0)
} 


ds, has(type string)  
foreach v in `r(varlist)' { 
	replace `v'=`v'[1596] if _n == 1595 & dups==1 & `v'[1595]=="" & !missing("`v'"[1596])
} 

		drop if _n==1596
		
		
		
//-----17th obs dup (school_code 222746 and teacher_id 2)
ds, has(type numeric)  
foreach v in `r(varlist)' { 
	replace `v' =max(`v'[1631], `v'[1632]) if _n == 1631 & dups==1  & `v'[1632] !=. & (mi("`var'"[1631]) | `var'[1631]==0)
} 


ds, has(type string)  
foreach v in `r(varlist)' { 
	replace `v'=`v'[1632] if _n == 1631 & dups==1 & `v'[1631]=="" & !missing("`v'"[1632])
} 

		drop if _n==1632
		
		
//-----18th obs dup (school_code 223668 and teacher_id 3)
ds, has(type numeric)  
foreach v in `r(varlist)' { 
	replace `v' =max(`v'[1729], `v'[1730]) if _n == 1729 & dups==1  & `v'[1730] !=. & (mi("`var'"[1729]) | `var'[1729]==0)
} 


ds, has(type string)  
foreach v in `r(varlist)' { 
	replace `v'=`v'[1730] if _n == 1729 & dups==1 & `v'[1729]=="" & !missing("`v'"[1730])
} 

		drop if _n==1730
		
//-----19th obs dup (school_code 224774 and teacher_id 1)
ds, has(type numeric)  
foreach v in `r(varlist)' { 
	replace `v' =max(`v'[1848], `v'[1849]) if _n == 1848 & dups==1  & `v'[1849] !=. & (mi("`var'"[1848]) | `var'[1848]==0)
} 


ds, has(type string)  
foreach v in `r(varlist)' { 
	replace `v'=`v'[1849] if _n == 1848 & dups==1 & `v'[1848]=="" & !missing("`v'"[1849])
} 

		drop if _n==1849

//-----20th obs dup (school_code 224774 and teacher_id 4)
ds, has(type numeric)  
foreach v in `r(varlist)' { 
	replace `v' =max(`v'[1851], `v'[1852]) if _n == 1851 & dups==1  & `v'[1852] !=. & (mi("`var'"[1851]) | `var'[1851]==0)
} 


ds, has(type string)  
foreach v in `r(varlist)' { 
	replace `v'=`v'[1852] if _n == 1851 & dups==1 & `v'[1851]=="" & !missing("`v'"[1852])
} 

		drop if _n==1852
		

//-----21th obs dup (school_code 225973and teacher_id 2)
ds, has(type numeric)  
foreach v in `r(varlist)' { 
	replace `v' =max(`v'[1950], `v'[1951]) if _n == 1950 & dups==1  & `v'[1951] !=. & (mi("`var'"[1950]) | `var'[1950]==0)
} 


ds, has(type string)  
foreach v in `r(varlist)' { 
	replace `v'=`v'[1951] if _n == 1950 & dups==1 & `v'[1950]=="" & !missing("`v'"[1951])
} 

		drop if _n==1951
		
		
drop dups
unique school_code teachers_id

*correcting some ids on teacher assessment IDs
unique school_code m5sb_tnumber if !missing(m5sb_tnumber)
duplicates tag school_code m5sb_tnumber if !missing(m5sb_tnumber), gen(dups)
	tab dups
	br school_code teachers_id m5sb_tnumber m5sb_troster if dups>0 & !missing(m5sb_tnumber)
	
replace m5sb_tnumber=teachers_id if dups>0 & !missing(m5sb_tnumber)
	drop dups 
	unique school_code m5sb_tnumber if !missing(m5sb_tnumber)

*correcting some ids on teacher questionnaire 
unique school_code m3sb_tnumber if !missing(m3sb_tnumber)
duplicates tag school_code m3sb_tnumber if !missing(m3sb_tnumber), gen(dups)
	tab dups
	br school_code teachers_id m3sb_tnumber m3sb_troster if dups>0 & !missing(m3sb_tnumber)
	
replace m3sb_tnumber=teachers_id if dups>0 & !missing(m3sb_tnumber)
	drop dups 
	unique school_code m3sb_tnumber if !missing(m3sb_tnumber)

*checking missing IDs on Teach data_dir 

br  school_code teachers_id  m4saq1_number if missing(m4saq1_number) & in_pedagogy==1

replace m4saq1_number=teachers_id if missing(m4saq1_number) & in_pedagogy==1
	unique school_code m4saq1_number if in_pedagogy==1

	

save "${processed_dir}\\School\\Confidential\\Merged\\teachers.dta" , replace



********
* Add some useful info back onto school frame for weighting
********

*collapse to school level
frame copy teachers teachers_school
frame change teachers_school

collapse g1_teacher_count g4_teacher_count g2_teacher_count, by(school_code)

frame change school
frlink m:1 school_code, frame(teachers_school)

frget g1_teacher_count g4_teacher_count g2_teacher_count, from(teachers_school)



***************
***************
* 1st Grade File
***************
***************

frame create first_grade
frame change first_grade
use "${data_dir}\\School\\ecd_assessment.dta" 


frlink m:1 interview__key interview__id, frame(school)
frget school_code ${strata} urban_rural public school_weight m6_class_count g1_teacher_count school_code_unique school_district_preload, from(school)


order school_code
sort school_code

*weights
gen g1_class_weight=g1_teacher_count/1, // weight is the number of 1st grade streams divided by number selected (1)
replace g1_class_weight=1 if g1_class_weight<1 //fix issues where no g1 teachers listed. Can happen in very small schools

bysort school_code: gen g1_assess_count=_N
gen g1_student_weight_temp=m6_class_count/g1_assess_count // 3 students selected from the class

gen g1_stud_weight=g1_class_weight*g1_student_weight_temp

save "${processed_dir}\\School\\Confidential\\Merged\\first_grade_assessment.dta" , replace

***************
***************
* 2nd Grade File
***************
***************
*-pesec6
frame create pesec6
frame change pesec6
use"${data_dir}\\School\\pasec_6_roster.dta"

unique interview__key  ecd_assessment_g2__id pasec_6_roster__id   //unique 

tab pasec_6_roster__id
tab pasec_6_roster__id, nol

sort interview__key ecd_assessment_g2__id
reshape wide  pasec_6,  i(interview__key ecd_assessment_g2__id) j(pasec_6_roster__id)

la var pasec_61 "Where is the party happening? "
la var pasec_62 "Where are the teachers?"
la var pasec_63 "Who dance?"

unique interview__key  ecd_assessment_g2__id    //unique 
unique interview__id  ecd_assessment_g2__id    //unique 

*-pesec10
frame create pesec10
frame change pesec10
use"${data_dir}\\School\\pasec_10_roster.dta"

unique interview__key  ecd_assessment_g2__id pasec_10_roster__id   //unique 

tab pasec_10_roster__id
tab pasec_10_roster__id, nol

sort interview__key ecd_assessment_g2__id
reshape wide  pasec_10,  i(interview__key ecd_assessment_g2__id) j(pasec_10_roster__id)

la var pasec_101 "8 + 5"
la var pasec_102 "13 - 7"
la var pasec_103 "14 + 23"
la var pasec_104 "33 + 29"
la var pasec_105 "34 - 11"
la var  pasec_106 "50 - 18"

unique interview__key  ecd_assessment_g2__id    //unique 
unique interview__id  ecd_assessment_g2__id    //unique 

**second grade main file
frame create second_grade
frame change second_grade
use "${data_dir}\\School\\ecd_assessment_g2.dta" 


frlink m:1 interview__key interview__id, frame(school)
frget school_code ${strata} urban_rural public school_weight m4scq4_inpt_g2 m10_class_count g2_stud_count g2_teacher_count school_code_unique school_district_preload, from(school)

order school_code
sort school_code

frlink m:1 interview__key interview__id ecd_assessment_g2__id, frame(pesec6)
frget pasec_61 pasec_62 pasec_63, from(pesec6)

frlink m:1 interview__key interview__id ecd_assessment_g2__id, frame(pesec10)
frget pasec_101 pasec_102 pasec_103 pasec_104 pasec_105 pasec_106, from(pesec10)

*weights
gen g2_class_weight=g2_teacher_count/1, // weight is the number of 2nd grade streams divided by number selected (1)
replace g2_class_weight=1 if g2_class_weight<1 //fix issues where no g2 teachers listed. Can happen in very small schools

bysort school_code: gen g2_assess_count=_N

gen g2_student_weight_temp=m10_class_count/g2_assess_count 

gen g2_stud_weight=g2_class_weight*g2_student_weight_temp

save "${processed_dir}\\School\\Confidential\\Merged\\second_grade_assessment.dta" , replace



***************
***************
* 4th Grade File
***************
***************

frame create fourth_grade
frame change fourth_grade
use "${data_dir}\\School\\fourth_grade_assessment.dta" 


frlink m:1 interview__key interview__id, frame(school)
frget school_code ${strata} urban_rural public school_weight m4scq4_inpt g4_stud_count g4_teacher_count school_code_unique school_district_preload, from(school)

order school_code
sort school_code

*weights
gen g4_class_weight=g4_teacher_count/1, // weight is the number of 4tg grade streams divided by number selected (1)
replace g4_class_weight=1 if g4_class_weight<1 //fix issues where no g4 teachers listed. Can happen in very small schools

bysort school_code: gen g4_assess_count=_N

gen g4_student_weight_temp=g4_stud_count/g4_assess_count // max of 25 students selected from the class

gen g4_stud_weight=g4_class_weight*g4_student_weight_temp

save "${processed_dir}\\School\\Confidential\\Merged\\fourth_grade_assessment.dta" , replace

***************
***************
* Collapse school data file to be unique at school_code level
***************
***************

frame change school

*******
* collapse to school level
*******

*drop some unneeded info
drop enumerators*

order school_code
sort school_code

* collapse to school level
ds, has(type numeric)
local numvars "`r(varlist)'"
local numvars : list numvars - not

ds, has(type string)
local stringvars "`r(varlist)'"
local stringvars : list stringvars- not

collapse (mean) `numvars' (firstnm) `stringvars', by(school_code)



save "${processed_dir}\\School\\Confidential\\Merged\\school.dta" , replace