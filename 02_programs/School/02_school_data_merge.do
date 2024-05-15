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

drop if school_code == 223748 & iden == "N DJAMENA 8"
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


*create weight variable that is standardized
gen school_weight=1/strata_prob // school level weight

*fourth grade student level weight
egen g4_stud_count = mean(m4scq4_inpt), by(school_code)


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

*fix a school code
replace school_code = 222760 if school_code==22760

frlink m:1 school_code, frame(school_collapse_temp)
frget school_code ${strata} urban_rural public school_weight numEligible numEligible4th, from(school_collapse_temp)

*get number of 4th grade teachers for weights
egen g4_teacher_count=sum(m3saq2_4), by(school_code)
egen g1_teacher_count=sum(m3saq2_1), by(school_code)

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

save "${processed_dir}\\School\\Confidential\\Merged\\teachers.dta" , replace



********
* Add some useful info back onto school frame for weighting
********

*collapse to school level
frame copy teachers teachers_school
frame change teachers_school

collapse g1_teacher_count g4_teacher_count, by(school_code)

frame change school
frlink m:1 school_code, frame(teachers_school)

frget g1_teacher_count g4_teacher_count, from(teachers_school)



***************
***************
* 1st Grade File
***************
***************

frame create first_grade
frame change first_grade
use "${data_dir}\\School\\ecd_assessment.dta" 


frlink m:1 interview__key interview__id, frame(school)
frget school_code ${strata} urban_rural public school_weight m6_class_count g1_teacher_count, from(school)


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
* 4th Grade File
***************
***************

frame create fourth_grade
frame change fourth_grade
use "${data_dir}\\School\\fourth_grade_assessment.dta" 


frlink m:1 interview__key interview__id, frame(school)
frget school_code ${strata} urban_rural public school_weight m4scq4_inpt g4_stud_count g4_teacher_count, from(school)

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