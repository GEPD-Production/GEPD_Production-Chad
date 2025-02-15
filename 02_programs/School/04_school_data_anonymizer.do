
*Anonymize GEPD data files for school, teachers, students
*Written by Mohammed El-desouky, and Last updated on April 18, 2024.

/*--------------------------------------------------------------------------------
*Note to users: Running multiple commands in this file requires manual verification 
and inspection, this as some of the anonymization procedures are dependant on the
distribution of the data particular to each country, and cutoffs and intervals must
be adjusted accordingly-- more explanations are given throughout this Do-file.
-------------------------------------------------------------------------------*/

clear all

*! PROFILE: Required step before running any dcommands in this project (select the "Run file in the same directory below")

*set the paths
gl data_dir ${clone}/03_GEPD_processed_data/
gl processed_dir ${clone}/03_GEPD_processed_data/

*Set working directory on your computer here
gl wrk_dir "${processed_dir}//School//Confidential//Cleaned//"
gl save_dir "${processed_dir}//School//Anonymized//"


********************************************************************************
* ************* 1- School data *********
********************************************************************************

use "${wrk_dir}/school_Stata.dta" 


*Checking IDs:
tab school_code_unique, m				//Typically all schools should have an ID

isid school_code_unique 
								//Typically obs should be identical 

*------------------------------------------------------------------------------*								
*Addressing the districts:
*----------------------------------------
*--- District name
tab school_district_preload, m	//Typically no missings

egen district_code = group(school_district_preload)
								//Generates IDs for each district name
								

{								//Run the follwoing as a bloc -- to extract district names and masked codes						
preserve 

bysort school_district_preload: gen ref_id = 1 if _n == 1
								//Needed for the following step-- extracting into a seperate file

drop if ref_id==.

keep school_district_preload district_code

save "${save_dir}\sensetive_masked\district_info.dta", replace

restore																							
}								

loc drop ref_id school_district_preload hashed_school_district _merge tag_dup_final flag_m5_dup_teach_id
foreach var of local drop{
      capture drop `var'
      di in r "return code for: `var': " _rc
}


order school_code school_code_preload school_name_preload district_code school_province_preload						
								//droping the district identifing variable
								//ordering other indentifing varibales 
								
								
*------------------------------------------------------------------------------*
*Addressing the strata varibale:
*---------------------------------
*--- Strata name
rename region strata
tab strata, m	//Typically no missings

egen strata_code = group(strata)
								//Generates IDs for each strata name



{								//Run the follwoing as a bloc -- to extract school codes official and masked					
preserve 

bysort strata: gen ref_id = 1 if _n == 1
	tab ref_id
	br strata strata_code ref_id

drop if ref_id==.

keep strata strata_code

save "${save_dir}\sensetive_masked\strata_info.dta", replace

restore																							
}								


loc drop ref_id strata _merge
foreach var of local drop{
      capture drop `var'
      di in r "return code for: `var': " _rc
}

	label var strata_code "Strata (region)"
								
								
*------------------------------------------------------------------------------*
*Addressing the schools:
*---------------------------------
*--- Official school codes and school names
egen school_code_maskd = group(school_code school_code_unique)

isid school_code_maskd


{								//Run the follwoing as a bloc -- to extract school codes official and masked					
preserve 

bysort school_code school_code_unique: gen ref_id = 1 if _n == 1
	tab ref_id
	br school_code school_code_maskd ref_id


drop if ref_id==.

keep school_code school_code_unique school_code_maskd school_name_preload

save "${save_dir}\sensetive_masked\school_info.dta", replace

restore																							
}								


loc drop ref_id school_name_preload school_code school_code_unique school_code_preload hashed_school_code _merge 
foreach var of local drop{
      capture drop `var'
      di in r "return code for: `var': " _rc
}


order school_code_maskd

*--- dropping School geospatial data
tab school_code_maskd, m
tab m1s0q9__Longitude, m
tab m1s0q9__Latitude, m

				

{								//Run the follwoing as a bloc -- to extract school geo data					
preserve 

keep school_code_maskd m1s0q9__Latitude m1s0q9__Longitude

save "${save_dir}\sensetive_masked\schoolgeo_info.dta", replace

restore																							
}	


loc drop m1s0q9__Latitude m1s0q9__Longitude m1s0q9__Accuracy m1s0q9__Altitude m1s0q9_Altitude  m1s0q9__Timestamp m1s0q9_Timestamp m1s0q9_Longitude m1s0q9_Latitude m1s0q9_Accuracy
foreach var of local drop{
      capture drop `var'
      di in r "return code for: `var': " _rc
}

*--- School land line number and principal mobile number
br m1saq2 m1saq2b

drop m1saq2 m1saq2b

*--- School enrollement 

sum m1saq7, d					//we will use the percentiles' values to recode the groups		
tab m1saq7						//fix our starting and ending points for recoding on (10% and 90%) 
								//rounding down/up the 10% values to the closest hundredth or tenth (depending on each countries distribution)
								//rounding down/up the 90% values to the closest hundredth
								//Then we split the rest of the categories in between into equal intervals.


recode m1saq7 (0/150=1 "150 or less") (151/200=2 "151-200 inclu") ///
(201/400=3 "201-400 inclu") (401/600=4 "401-600 inclu") ///
(601/800=5 "601-800 inclu") (801/1000=6 "801-1000 inclu") ///
(1000.01/max=7 "More than 1000")(.=.), gen (total_enrolled_c)

	tab total_enrolled_c
	label var total_enrolled_c "total enrolled at school"

loc drop total_enrolled m1saq7 m1saq8
foreach var of local drop{
      capture drop `var'
      di in r "return code for: `var': " _rc
}

*--- Total number of 5th grade enrollments 
sum m1saq8a_etri, d				//we will use the percentiles' values to recode the groups		
								//fix our starting and ending points for recoding on (10% and 90%) 
								//rounding down/up the 10% values to the closest hundredth or tenth (depending on each countries distribution)
								//rounding down/up the 90% values to the closest hundredth
								//Then we split the rest of the categories in between into equal intervals.


recode m1saq8a_etri (0/15=1 "15 and less") ///
(16/30=2 "16-30 inclu") ///
(31/50=3 "31-50 inclu") (51/70=4 "51-70 inclu") ///
(71/90=5 "71-90 inclu") (91/110=6 "91-110 inclu") ///
(111/130=7 "111-130 inclu") ///
(131/max=8 "More than 130")(.=.), gen (m1saq8a_etri_c)

	tab m1saq8a_etri_c, m
	label var m1saq8a_etri_c "total 5th grade enrolled at school"

drop m1saq8a_etri

*------------------------------------------------------------------------------*
*Addressing school principals:
*--------------------------------------
*--- name of principals and other var names (to be dropped)
br  m1saq1_first m1saq1_last m1s0q2_name m1s0q1_name m1s0q1_name_other name1 name2 name3 name4 name5 m6_teacher_name m8_teacher_name

drop  m1saq1_first m1saq1_last m1s0q2_name m1s0q1_name m1s0q1_name_other name1 name2 name3 name4 name5 m6_teacher_name m8_teacher_name

*--- Position in school (recoding low frequency obs if needed)
tab m7saq1
tab m1saq3

tab m7saq1, nolabel
replace m7saq1 =97 if m7saq1== 6 

drop m1saq3

*--- Position in school_other (drop var)
tab m7saq1_other
drop m7saq1_other

*--- Year started position teaching (turn dates into years, then interval recoding)
tab m7saq8

gen m7saq8_y = 2023-m7saq8		//First, we convert dates to years, by subtracting from the year of the survey
	tab m7saq8_y 
	tab m7saq8
	
sum  m7saq8_y , d				//Will use the percentiles' values to recode the low frequency groups at the end and bottom of the distribution
								//will use the values of 10% 
								//will use the values of 90% 
								//Then only recode the low frequency obs at top and the bottom

recode m7saq8_y (0/1=1 "1 year or less") (15/max=15 "15 years or more")(.=.), gen (m7saq8_c)

	label var m7saq8_c "Which year achieved the current position in the school- N. of years"

		tab m7saq8_c, m

drop m7saq8_y m7saq8


*--- Age (Two steps control)-- this shall be investigated on a case by case basis (depending on each dataset)
tab m7saq9, m

replace m7saq9 = m7saq9+1
	tab m7saq9, m
							//Introducing some noise by adding extra year to the age var

				 
sum  m7saq9 , d

							//Will use the percentiles' values to recode the groups
							//will use the values of 10% and 90%
							//Then, only recode the low frequency obs at top and the bottom
 

recode m7saq9 (0/35=35 " 35 years old and less")(60/max=60 "more than 59 years")(.=.), gen (m7saq9_c)
	tab m7saq9_c, m

	label var m7saq9_c "What is your age?"
	

drop m7saq9
							
*--- Education_other (drop var)
tab m7saq7_other
drop m7saq7_other

*--- gender (drop var)
tab m7saq10
drop m7saq10

*--- Salary variable (top/bottom recoding)
tab m7shq2_satt

sum  m7shq2_satt , d        //Will use the percentiles' values to recode the groups
							//will use the values of 10% and 90%
							//Then, only recode the low frequency obs at top and the bottom
 

recode m7shq2_satt (0/13000=13000 "13000 and less") (290000/max=290000 "290000 and more")(.=.), gen (m7shq2_satt_c)
	tab m7shq2_satt_c, m
	
	label var m7shq2_satt_c "What is your net monthly salary as a public-school principal?"
	


drop m7shq2_satt

*------------------------------------------------------------------------------*
*--- dropping unnecessary vars
*--------------------------------------
loc drop hashed_school_province school_address_preload ///
m1s0q2_name m1s0q2_code m1s0q2_emis school_info_correct school_emis_preload ///
school_address_preload survey_time m7saq10 ///
enumerator_name_other enumerator_number ///
m1s0q2_code m1s0q2_emis m1s0q9_latitude m1s0q9_longitude m1s0q9_accuracy ///
m1s0q9_altitude m1s0q9_timestamp survey_time m6_class_count m1s0q1_comments ///
m7sb_troster_pknw_0 m7sb_troster_pknw_1 m7sb_troster_pknw_2 m7sb_troster_pknw_3 ///
m7sb_troster_pknw_4 m7sb_troster_pknw_5 m7sb_troster_pknw_6 m7sb_troster_pknw_7 ///
m3sb_troster_0 m3sb_troster_1 m3sb_troster_2 m3sb_troster_3 m3sb_troster_4 ///
m5sb_troster_0 m5sb_troster_1 m5sb_troster_2 m5sb_troster_3 m5sb_troster_4 ///
m2saq2* m6s1q1* m8s1q1* m1saq3_other m1saq6a_other m1saq6b_other m1sbq9_other_infr ///
m1sbq17_other_infr m1scq2_other_imon m1scq8_other_imon m7saq6_other m7sbq2_other_opmn ///
m7sbq3_other_opmn m7sbq4_other_opmn m7sbq5_other_opmn m7scq1_other_opmn ///
m7scq5_other_opmn m7sdq4_other_pman m7sdq5_other_pman m7seq1_other_pman ///
m7seq2_other_pman m7seq3_other_pman m7sgq1_other_ssld m7sgq4_other_ssup ///
m7sgq6_other_ssup m7sgq10_other_sevl m7sgq11_other_sevl m7sgq12_other_sevl ///
enumerator_name_other m1s0q1_number_other m4saq1 comments m2saq2__0 m2saq2__1 m2saq2__2 ///
m2saq2__3 m2saq2__4 m2saq2__5 m2saq2__6 m2saq2__7 m2saq2__8 m2saq2__9 m2saq2__10 m2saq2__11 ///
m2saq2__12 m2saq2__13 m2saq2__14 m2saq2__15 m2saq2__16 m2saq2__17 m2saq2__18 m2saq2__19 ///
m2saq2__20 m2saq2__21 m2saq2__22 m2saq2__23 m2saq2__24 m2saq2__25 m2saq2__26 m2saq2__27 ///
m2saq2__28 m2saq2__29 m7sb_* m3sb_t* m3sb_etri_roster__0 m5sb_* m9saq1 m10s1q1* m10_teacher_name ///
m1s0q8 m1s0q9__Timestamp interview__id interview__key district tehsil schoollevel shift Date_time location Date_time_g2 ///
lga senatorialdistrict classification ///
modules__2 modules__1 modules__7 modules__3 modules__5 modules__6 modules__4 modules__8 modules__9 modules__10 ///
m2saq1 numEligible i1 i2 i3 i4 i5 available1 available2 available3 available4 available5 ///
teacher_phone_number1 teacher_phone_number2 teacher_phone_number3 teacher_phone_number4 ///
teacher_phone_number5 m1s0q6 m1saq2 m1saq2b fillout_teacher_q fillout_teacher_con ///
fillout_teacher_obs observation_id sssys_irnd has__errors interview__status teacher_etri_list_photo ///
m5s2q1c_number_new m5s2q1e_number_new m5s1q1f_grammer_new monitoring_inputs_temp monitoring_infrastructure_temp ///
principal_training_temp school_teacher_ques_INPT ///
coed_toilet pknw_actual_cont pknw_actual_exper school_goals_relevant_total principal_eval_tot weight m7covq10_other

foreach var of local drop{
      capture drop `var'
      di in r "return code for: `var': " _rc
}




label var district_code "Masked district code"
label var school_code_maskd"Masked school code"

order school_code_maskd district_code school_province_preload total_enrolled_c numEligible4th grade5_yesno  m1* m4* subject_test s1* s2*  m5* m6* m7* m8*



*--- dropping vars with all missing (no obs)

foreach var of varlist * {
    capture assert missing(`var')
    if !_rc codebook `var', compact
}


foreach var of varlist * {
    capture assert missing(`var')
    if !_rc drop `var'
}
 


*------------------------------------------------------------------------------*
*Saving anonymized school dataset:
*-------------------------------------
save "${save_dir}\school.dta", replace

	clear


*------------------------------------------------------------------------------*
*Comparing anonymized & confidential school datasets:
*-------------------------------------
log using "${save_dir}\sensetive_masked\QA_anonymization",  name("QA_anonymization") replace

use "${wrk_dir}/school_Stata.dta" 

di c(filename)
di c(current_time)
di c(current_date)

*------------------------------------------------------------------------------*
* Quality control the anonymized dataset by comparing it to confidential set 
*  Note----: 
*		[if the follwoing code returns no error -- then the values and variables of the two datsets are identical]
*		[if the follwoing code returns error code "r(9)" -- then some/all values and variables of two datsets are different]

* Master dataset = [confidential]
* using  dataset = [anonymized]

* This test compares the individual values of the varibales 
* There are 4 possible test outcomes: 
/*
	a- [Match]: means varibales' values are identical 
	b- [Doesnt exist in using]: means var was dropped in anonymized set
	c- [# mistamtches in using]: varibales' values of two data are changed (# values/obs)
	d- [formate in master vs. formate in using]: varibales formatting has changed (e.g. int - str)
*/
*-------------------------------------
capture noisily cf _all using "${save_dir}\school.dta", all verbose

clear
use "${save_dir}\school.dta"
codebook, compact


log off QA_anonymization
log close QA_anonymization
	clear

********************************************************************************
* ************* 2- Teachers data *********
********************************************************************************	

use "${wrk_dir}/teachers_Stata.dta" 

*Checking IDs:
cap rename TEACHERS__id teachers_id
tab teachers_id, m				//Typically all teachers should have an ID
tab school_code, m				//Typically all schools should have an ID

unique teachers_id school_code
								//Typically obs should be identical 
								
*------------------------------------------------------------------------------*
*Addressing the districts:
*--------------------------------------------
*--- District name 

tab school_district_preload, m 
								//Since we have already extracted district data above, we don't need to generate random codes to them again
								//We will only matched the random codes generated and stored while anonymizing school data

joinby school_district_preload using "${save_dir}\sensetive_masked\district_info.dta", unmatched(both)
								//merging district anonymous codes to the school data
								
tab _merge
								//Checking the quality of the merge -- clean and error free merge							

local drop ref_id school_district_preload _merge tag_dup_final flag_m5_dup_teach_id
foreach var of local drop{
      capture drop `var'
      di in r "return code for: `var': " _rc
}


local order hashed_school_code hashed_school_province hashed_school_district school_code school_name_preload district_code
foreach var of local order{
      capture order `var'
      di in r "return code for: `var': " _rc
}

*------------------------------------------------------------------------------*
*Addressing Strata varibale (adding the masked variblae extracted previously from the school file):
*--------------------------------------------
rename region strata
tab strata

joinby strata using "${save_dir}\sensetive_masked\strata_info.dta", unmatched(both)
								//merging district anonymous codes to the school data
								
tab _merge
drop _merge
								//Checking the quality of the merge -- clean merge
br strata strata_code	

	label var strata_code "Strata (district_urban/rural)"

*------------------------------------------------------------------------------*
*Addressing the Schools:
*--------------------------------------------
*--- Official school codes and school names
br school_code

joinby school_code school_code_unique using "${save_dir}\sensetive_masked\school_info.dta", unmatched(both)
								//merging school anonymous codes to the school data
								
tab _merge
								//Checking the quality of the merge -- clean and error free merge							
drop if _merge==2

 
local drop school_code school_code_preload hashed_school_code _merge school_name_preload
foreach var of local drop{
      capture drop `var'
      di in r "return code for: `var': " _rc
}
 


local order hashed_school_province district_code school_code_maskd
foreach var of local order{
      capture order `var'
      di in r "return code for: `var': " _rc
}

*--- School geospatial data
 
loc drop m1s0q9__Latitude m1s0q9__Longitude m1s0q9__Accuracy m1s0q9__Altitude m1s0q9_Altitude  m1s0q9__Timestamp m1s0q9_Timestamp m1s0q9_Longitude m1s0q9_Latitude m1s0q9_Accuracy lat lon latitude longitude
foreach var of local drop{
      capture drop `var'
      di in r "return code for: `var': " _rc
}
 


*--- School enrollement (dropping it since already addressed in the school file)

 
loc drop m1s0q9__Latitude m1s0q9__Longitude m1s0q9__Accuracy m1s0q9__Altitude m1s0q9_Altitude  m1s0q9__Timestamp m1s0q9_Timestamp m1s0q9_Longitude m1s0q9_Latitude m1s0q9_Accuracy lat lon latitude longitude
foreach var of local drop{
      capture drop `var'
      di in r "return code for: `var': " _rc
}
 

*------------------------------------------------------------------------------*
*Addressing teachers:
*--------------------------------------------
*--- Teacher name (to be dropped)
 
local drop m2saq2 teacher_name_x m4saq1 teacher_name_y m5sb_troster teacher_name m3sb_troster  
foreach var of local drop{
      capture drop `var'
      di in r "return code for: `var': " _rc
}
 

*--- Position in school (recoding low frequency obs if needed)
tab m2saq4
tab m2saq4, nolabel									
replace m2saq4 =97 if m2saq4== 6 

*--- Position in school_other (drop var)
 
drop m2saq4_other
 

*--- Contract status_other (drop var)
 
drop m2saq5_other
 

*--- Age (Two steps control)-- this shall be investigated on a case by case basis (depending on each dataset)
tab m3saq6, m			

replace m3saq6 = m3saq6+1
	tab m3saq6
							//Step 1- Introducing some noise by adding extra year to the age var

							//Obs above 60 are low frequency (1 and 2 obs) on each age category
							//Obs below 26 are low frequency (2 and 3 obs) on each age category
							//Step 2- Recoding their values 
sum m3saq6, d
	
recode m3saq6 (0/25=25 " 25 years old and less")(60/max=60 "more than 59 years")(.=.), gen (m3saq6_c)
	tab m3saq6_c

	label var m3saq6_c "What is your age?"
	
 
drop m3saq6
 

*--- Education_other (drop var)
tab m3saq4_other
 
drop m3saq4_other
 

*--- Salary delay (recoding)
tab m3seq7_tatt
sum m3seq7_tatt, d

*recode m3seq7_tatt (4/max=4 "more than 3 months")(.=.), gen (m3seq7_tatt_c)
*label var m3seq7_tatt_c "How many months was your salary delayed in the last academic year"
*	tab m3seq7_tatt_c
*drop m3seq7_tatt

*--- Year starting teaching (turn dates into years, then interval recoding)
tab m3saq5

gen m3saq5_y = 2023-m3saq5
	tab m3saq5_y 
	tab m3saq5
	
sum m3saq5_y , d				//Will use the percentiles' values to recode the groups
								//will use the values of 10% and 90%
								//Just recode the low frequency var

recode m3saq5_y (26/max=26 "more than 25 years")(.=.), gen (m3saq5_c)

	label var m3saq5_c "What year did you begin teaching - N. of years"

		tab m3saq5_c

 
drop m3saq5_y m3saq5
 

*------------------------------------------------------------------------------*
*--- dropping unnecessary vars
*--------------------------------------
 
loc drop hashed_school_code hashed_school_province hashed_school_district ///
m1s0q2_name m1s0q2_code m1s0q2_emis school_info_correct school_emis_preload ///
school_address_preload school_code_preload school_name survey_time m7saq10 ///
m2saq8_other teacher_available_other m3s0q1_other m3saq3_other m3sbq1_other_tatt ///
m3sbq2_other_tmna m3sbq5_other_pedg m2sbq8_other_tmna m3sbq9_other_tmna ///
m3sbq10_other_tmna m3sdq5_tsup_other m3sdq12_other_tsup m3sdq17_other_ildr ///
m3sdq18_other_ildr m3sdq25_other_ildr m3seq5_other_tatt m3seq8_other_tsdp ///
unique_teach_id teacher_unique_id iden district interview__key interview__id ///
school tehsil shift schoollevel strata m4saq1_lwr m3_lwr m5_lwr enumerators_preload__0-enumerators_preload__99 ///
m1s0q1_name_other m1s0q1_comments m1s0q8 m1s0q9__Timestamp m1s0q1_name m6_teacher_name m6s1q1__0-m6s1q1__5 Date_time m8_teacher_name m8s1q1__0-comments second_name first_name m2saq22 location teacher_name1-teacher_name4 senatorialdistrict classification province ///
teacher_abs_count teacher_quest_count teacher_content_count ///
emis_code xcoordinate ycoordinate total_enrollment school_headmaster_contact_no ///
nstudents_district total_district share_district /// 
sample_size totalstudents strata_count strata_size strata_school_prob strata_prob index tag ///
flag_unmatched tag_v2 flag_mismatch school_collapse_temp v1_sch_absence_rate v1_absence_rate name_dup pedagogy_matched questionnaire_matched merge1 merge2 assessment_matched nteachers_cont total_cont weight school_code_unique

foreach var of local drop{
      capture drop `var'
      di in r "return code for: `var': " _rc
}




order district_code school_code_maskd teachers_id

label var district_code "Masked district code"
label var school_code_maskd"Masked school code"


*--- dropping vars with all missing (no obs)

foreach var of varlist * {
    capture assert missing(`var')
    if !_rc codebook `var', compact
}


foreach var of varlist * {
    capture assert missing(`var')
    if !_rc drop `var'
}





*------------------------------------------------------------------------------*
*Saving anonymized teacher dataset:
*-------------------------------------
save "${save_dir}\teachers.dta", replace

	clear

*------------------------------------------------------------------------------*
*Comparing anonymized & confidential teachers datasets:
*-------------------------------------
log using "${save_dir}\sensetive_masked\QA_anonymization",  name("QA_anonymization") append

use "${wrk_dir}/teachers_Stata.dta" 

di c(filename)
di c(current_time)
di c(current_date)

*------------------------------------------------------------------------------*
* Quality control the anonymized dataset by comparing it to confidential set 
*  Note----: 
*		[if the follwoing code returns no error -- then the values and variables of the two datsets are identical]
*		[if the follwoing code returns error code "r(9)" -- then some/all values and variables of two datsets are different]

* Master dataset = [confidential]
* using  dataset = [anonymized]

* This test compares the individual values of the varibales 
* There are 4 possible test outcomes: 
/*
	a- [Match]: means varibales' values are identical 
	b- [Doesnt exist in using]: means var was dropped in anonymized set
	c- [# mistamtches in using]: varibales' values of two data are changed (# values/obs)
	d- [formate in master vs. formate in using]: varibales formatting has changed (e.g. int - str)
*/
*-------------------------------------
capture noisily cf _all using "${save_dir}\teachers.dta", all verbose

clear
use "${save_dir}\teachers.dta"
codebook, compact

log off QA_anonymization
log close QA_anonymization
	clear

	
********************************************************************************
* ************* 3- Students g1 and g4 data *********
********************************************************************************
*------------------------------------------------------------------------------*
*For first grade students
*------------------------------------------------------------------------------*
use "${wrk_dir}/first_grade_Stata.dta" 


*Checking IDs:
tab school_code, m						//Typically all schools should have an ID
tab ecd_assessment__id, m				//Typically all students should have an ID

unique school_code school_code_unique ecd_assessment__id 
								//Typically obs should be identical -- ununique 

*Masking school information:								
br school_code

joinby school_code school_code_unique using "${save_dir}\sensetive_masked\school_info.dta", unmatched(both)
								//merging school anonymous codes to the school data
								
tab _merge
tab _merge, nolab
	drop if _merge==2
	drop _merge	
	
							//Clean merge, all obs from master were matched
							
*Addressing Strata varibale (adding the masked variblae extracted previously from the school file):

rename region strata
tab strata

joinby strata using "${save_dir}\sensetive_masked\strata_info.dta", unmatched(both)
								//merging district anonymous codes to the school data
								
tab _merge
tab _merge, nolab
	drop if _merge==2
	drop _merge
								//Clean merge, all obs from master were matched						
br strata strata_code	

	label var strata_code "Strata (district_urban/rural)"
	
*Addressing district variable
tab school_district_preload, m 
								//Since we have already extracted district data above, we don't need to generate random codes to them again
								//We will only matched the random codes generated and stored while anonymizing school data

joinby school_district_preload using "${save_dir}\sensetive_masked\district_info.dta", unmatched(both)
								//merging district anonymous codes to the school data
								
tab _merge
								//Checking the quality of the merge -- clean and error free merge							


local drop school_district_preload _merge 
foreach var of local drop{
      capture drop `var'
      di in r "return code for: `var': " _rc
}


*Dropping un necessary varibales 
loc drop school_code school_code_unique school_name_preload m6s1q1 interview__id interview__key school district tehsil shift schoollevel strata location senatorialdistrict classification ///
g1_assess_count g1_student_weight_temp weight
foreach var of local drop{
      capture drop `var'
      di in r "return code for: `var': " _rc
}



order district_code school_code_maskd ecd_assessment__id

label var school_code_maskd"Masked school code"


*--- dropping vars with all missing (no obs)

foreach var of varlist * {
    capture assert missing(`var')
    if !_rc codebook `var', compact
}


foreach var of varlist * {
    capture assert missing(`var')
    if !_rc drop `var'
}



* Saving anonymized g1 dataset 
save "${save_dir}\first_grade_assessment.dta", replace

	clear

*------------------------------------------------------------------------------*
*Comparing anonymized & confidential 1st grade datasets:
*-------------------------------------
log using "${save_dir}\sensetive_masked\QA_anonymization",  name("QA_anonymization") append

use "${wrk_dir}/first_grade_Stata.dta" 

di c(filename)
di c(current_time)
di c(current_date)

*------------------------------------------------------------------------------*
* Quality control the anonymized dataset by comparing it to confidential set 
*  Note----: 
*		[if the follwoing code returns no error -- then the values and variables of the two datsets are identical]
*		[if the follwoing code returns error code "r(9)" -- then some/all values and variables of two datsets are different]

* Master dataset = [confidential]
* using  dataset = [anonymized]

* This test compares the individual values of the varibales 
* There are 4 possible test outcomes: 
/*
	a- [Match]: means varibales' values are identical 
	b- [Doesnt exist in using]: means var was dropped in anonymized set
	c- [# mistamtches in using]: varibales' values of two data are changed (# values/obs)
	d- [formate in master vs. formate in using]: varibales formatting has changed (e.g. int - str)
*/
*-------------------------------------

capture noisily cf _all using "${save_dir}\first_grade_assessment.dta", all verbose

clear
use "${save_dir}\first_grade_assessment.dta"
codebook, compact 

log off QA_anonymization
log close QA_anonymization
	clear

*------------------------------------------------------------------------------*	
*For fourth grade students
*------------------------------------------------------------------------------*
use "${wrk_dir}/fourth_grade_Stata.dta" 


*Checking IDs:
tab school_code, m					//Typically all schools should have an ID
tab fourth_grade_assessment__id, m	//Typically all students should have an ID

unique school_code school_code_unique fourth_grade_assessment__id 
								//Typically obs should be identical -- ununique 					

*Masking school information:								
br school_code

joinby school_code school_code_unique using "${save_dir}\sensetive_masked\school_info.dta", unmatched(both)
								//merging school anonymous codes to the school data
								
tab _merge
tab _merge, nolab
	drop if _merge==2
	drop _merge
								//Clean merge, all obs from master were matched

*Addressing Strata varibale (adding the masked variblae extracted previously from the school file):
rename region strata
tab strata

joinby strata using "${save_dir}\sensetive_masked\strata_info.dta", unmatched(both)
								//merging district anonymous codes to the school data
								
tab _merge
tab _merge, nolab
	drop if _merge==2
	drop _merge
								//Clean merge, all obs from master were matched						
br strata strata_code	

	label var strata_code "Strata (district_urban/rural)"							

	
*Addressing district variable

tab school_district_preload, m 
								//Since we have already extracted district data above, we don't need to generate random codes to them again
								//We will only matched the random codes generated and stored while anonymizing school data

joinby school_district_preload using "${save_dir}\sensetive_masked\district_info.dta", unmatched(both)
								//merging district anonymous codes to the school data
								
tab _merge
								//Checking the quality of the merge -- clean and error free merge							


local drop school_district_preload _merge 
foreach var of local drop{
      capture drop `var'
      di in r "return code for: `var': " _rc
}
								
*Dropping un necessary varibales 
loc drop school_code school_name_preload _merge m8s1q1 interview__id interview__key school interview__id interview__key school district tehsil shift schoollevel strata location senatorialdistrict classification g4_stud_count g4_assess_count g4_student_weight_temp weight school_code_unique

foreach var of local drop{
      capture drop `var'
      di in r "return code for: `var': " _rc
}


order district_code school_code_maskd fourth_grade_assessment__id

label var school_code_maskd"Masked school code"


*--- dropping vars with all missing (no obs)

foreach var of varlist * {
    capture assert missing(`var')
    if !_rc codebook `var', compact
}


foreach var of varlist * {
    capture assert missing(`var')
    if !_rc drop `var'
}




* Saving anonymized g4 dataset 
save "${save_dir}\fourth_grade_assessment.dta", replace

	clear
	
	
*------------------------------------------------------------------------------*
*Comparing anonymized & confidential 4th grade datasets:
*-------------------------------------
log using "${save_dir}\sensetive_masked\QA_anonymization",  name("QA_anonymization") append

use "${wrk_dir}/fourth_grade_Stata.dta" 

di c(filename)
di c(current_time)
di c(current_date)

*------------------------------------------------------------------------------*
* Quality control the anonymized dataset by comparing it to confidential set 
*  Note----: 
*		[if the follwoing code returns no error -- then the values and variables of the two datsets are identical]
*		[if the follwoing code returns error code "r(9)" -- then some/all values and variables of two datsets are different]

* Master dataset = [confidential]
* using  dataset = [anonymized]

* This test compares the individual values of the varibales 
* There are 4 possible test outcomes: 
/*
	a- [Match]: means varibales' values are identical 
	b- [Doesnt exist in using]: means var was dropped in anonymized set
	c- [# mistamtches in using]: varibales' values of two data are changed (# values/obs)
	d- [formate in master vs. formate in using]: varibales formatting has changed (e.g. int - str)
	
*/
*-------------------------------------

capture noisily cf _all using "${save_dir}\fourth_grade_assessment.dta", all verbose

clear
use "${save_dir}\fourth_grade_assessment.dta"
codebook, compact

log off QA_anonymization
log close QA_anonymization
	clear
	

*------------------------------------------------------------------------------*	
*For second grade students
*------------------------------------------------------------------------------*
use "${wrk_dir}/second_grade_Stata.dta" 


*Checking IDs:
tab school_code, m					//Typically all schools should have an ID
tab ecd_assessment_g2__id, m	//Typically all students should have an ID

unique school_code school_code_unique ecd_assessment_g2__id
								//Typically obs should be identical -- ununique 					

*Masking school information:								
br school_code

joinby school_code school_code_unique using "${save_dir}\sensetive_masked\school_info.dta", unmatched(both)
								//merging school anonymous codes to the school data
								
tab _merge
tab _merge, nolab
	drop if _merge==2
	drop _merge
								//Clean merge, all obs from master were matched

*Addressing Strata varibale (adding the masked variblae extracted previously from the school file):
rename region strata
tab strata

joinby strata using "${save_dir}\sensetive_masked\strata_info.dta", unmatched(both)
								//merging district anonymous codes to the school data
								
tab _merge
tab _merge, nolab
	drop _merge
								//Clean merge, all obs from master were matched						
br strata strata_code	

	label var strata_code "Strata (district_urban/rural)"							

	
*Addressing district variable

tab school_district_preload, m 
								//Since we have already extracted district data above, we don't need to generate random codes to them again
								//We will only matched the random codes generated and stored while anonymizing school data

joinby school_district_preload using "${save_dir}\sensetive_masked\district_info.dta", unmatched(both)
								//merging district anonymous codes to the school data
								
tab _merge
								//Checking the quality of the merge -- clean and error free merge							


local drop school_district_preload _merge 
foreach var of local drop{
      capture drop `var'
      di in r "return code for: `var': " _rc
}
								
*Dropping un necessary varibales 
loc drop school_code school_name_preload _merge m8s1q1 interview__id interview__key school interview__id interview__key school district tehsil shift schoollevel strata location senatorialdistrict classification g2_stud_count g2_assess_count g2_student_weight_temp weight m10s1q1 school_code_unique

foreach var of local drop{
      capture drop `var'
      di in r "return code for: `var': " _rc
}


order district_code school_code_maskd ecd_assessment_g2__id

label var school_code_maskd "Masked school code"
label var  ecd2_soc_student_proficiency "ecd2_soc_student_proficiency"
label var  ecd2_exec_student_proficiency "ecd2_exec_student_proficiency"
label var  ecd2_litera_student_proficiency "ecd2_litera_student_proficiency"
label var  ecd2_math_student_proficiency "ecd2_math_student_proficiency"
label var  ecd2_student_proficiency "ecd2_student_proficiency"
label var  ecd2_student_knowledge "ecd2_student_knowledge"
label var  ecd2_soc_student_knowledge "ecd2_soc_student_knowledge"
label var  ecd2_exec_student_knowledge "ecd2_exec_student_knowledge"
label var  ecd2_math_student_knowledge "ecd2_math_student_knowledge"
label var  ecd2_literacy_student_knowledge "ecd2_literacy_student_knowledge"
label var  g2_stud_weight "g2_stud_weight"
label var  g2_class_weight "g2_class_weight"
label var public "Public/private"
label var school_weight "School weight"

          
*--- dropping vars with all missing (no obs)

foreach var of varlist * {
    capture assert missing(`var')
    if !_rc codebook `var', compact
}


foreach var of varlist * {
    capture assert missing(`var')
    if !_rc drop `var'
}




* Saving anonymized g4 dataset 
save "${save_dir}\second_grade_assessment.dta", replace

	clear
	
	
*------------------------------------------------------------------------------*
*Comparing anonymized & confidential 4th grade datasets:
*-------------------------------------
log using "${save_dir}\sensetive_masked\QA_anonymization",  name("QA_anonymization") append

use "${wrk_dir}/second_grade_Stata.dta" 

di c(filename)
di c(current_time)
di c(current_date)

*------------------------------------------------------------------------------*
* Quality control the anonymized dataset by comparing it to confidential set 
*  Note----: 
*		[if the follwoing code returns no error -- then the values and variables of the two datsets are identical]
*		[if the follwoing code returns error code "r(9)" -- then some/all values and variables of two datsets are different]

* Master dataset = [confidential]
* using  dataset = [anonymized]

* This test compares the individual values of the varibales 
* There are 4 possible test outcomes: 
/*
	a- [Match]: means varibales' values are identical 
	b- [Doesnt exist in using]: means var was dropped in anonymized set
	c- [# mistamtches in using]: varibales' values of two data are changed (# values/obs)
	d- [formate in master vs. formate in using]: varibales formatting has changed (e.g. int - str)
	
*/
*-------------------------------------

capture noisily cf _all using "${save_dir}\second_grade_assessment.dta", all verbose

clear
use "${save_dir}\second_grade_assessment.dta"
codebook, compact

log off QA_anonymization
log close QA_anonymization
	clear 
		clear 	all

