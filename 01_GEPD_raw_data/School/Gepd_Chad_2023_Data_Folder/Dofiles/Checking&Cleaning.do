************************************ Organisation :  IHfRA								****************************
************************************ Project Tittle: GEPD TCHAD 2023					****************************
************************************ Purpose:         Data checking and cleanign 		****************************
************************************ Author:         Ambroise Dognon					****************************
************************************ Email:         adognon@hub4research.com			****************************
************************************ Description:	 This do file is designed to check 	****************************
************************************                 the compile data and proceded to  	****************************
************************************ 				 the data cleaning process			****************************
************************************ Date Craeation: 2023-06-012                		****************************

*initialize stata 
cls
clear all
cap drop all
version 17
set more off
set maxvar 120000

*set date for excel files generation
local today : display %tdCYND date(c(current_date), "DMY")
display in smcl as text "`today'"


**Set the work directory
global dir "D:\IHfRA\Projet GEPD TCHAD\GEPD TCHAD ORIGINAL\DATA QUALITY\HFC\Raw data\EPDash_5_STATA_All (4)"
cd "$dir"
global Check "D:\IHfRA\Projet GEPD TCHAD\GEPD TCHAD ORIGINAL\DATA QUALITY\HFC\Data_check_Files"

global Merge "D:\IHfRA\Projet GEPD TCHAD\GEPD TCHAD ORIGINAL\DATA QUALITY\HFC\Merged data"

*** Use the full merged dataset for checking and cleaning process
use "$Merge/GEPD_Tchad_Merged_full_data.dta",clear
gen all_ob=_N
gen id=_n

	
*** Some statistics
tab school_name_preload all_ob /* Nombre d'observation par école */
bys school_province_preload : tab school_name_preload all_ob /* Nombre d'observation par école et par région */

*** Check for all questionnaire for closed school 
ta m1s0q1,m

*** Check for duplicates and single questionnaires 

duplicates report m1s0q2_emis
duplicates tag m1s0q2_emis, gen(dup1)
order dup1, after(m1s0q2_emis)
export excel interview__key school_province_preload school_district_preload school_address_preload school_name_preload school_code_preload m1s0q2_code m1s0q2_emis m1s0q1_name_othe if dup>=3 using "$Check\Entretien_Doublons_`c(current_date)'.xlsx", datestring("%tc") firstrow(varl) sheet("Liste", replace)


* Checking for the number of school completed by school_name_preload variable
sort school_province_preload school_district_preload school_address_preload school_name_preload school_code_preload
count if school_name_preload[_n]!=school_name_preload[_n-1] /*Nombre d'écoles*/
count if school_name_preload[_n]==school_name_preload[_n-1] /*Nombre d'écoles avec au moins deux soumissions*/

* Checking for the number of school completed by m1s0q2_emis variable

count if m1s0q2_emis[_n]!=m1s0q2_emis[_n-1] /*Nombre d'écoles*/
count if m1s0q2_emis[_n]==m1s0q2_emis[_n-1] /*Nombre d'écoles avec au moins deux soumissions*/


*** Single questionnaire checking
export excel interview__key school_province_preload school_district_preload school_address_preload school_name_preload school_code_preload m1s0q1_comments m1s0q2_name m1s0q1_name_other if dup==0 using "$Check\Entretien_Uniq_survey_`c(current_date)'.xlsx", datestring("%tc") sheetreplace firstrow(var)

export excel interview__key school_province_preload school_district_preload school_address_preload school_name_preload school_code_preload m1s0q1_comments m1s0q2_code m1s0q2_emis m1s0q1_name_other if dup==0 using "$Check\Entretien_Codemiss_`c(current_date)'.xlsx", datestring("%tc") sheetreplace firstrow(var)

*** Blank questions checking
* Dorp variables with no preloaded enumerator names
drop enumerators_preload__0 enumerators_preload__1 enumerators_preload__2 enumerators_preload__3 enumerators_preload__4 enumerators_preload__5 enumerators_preload__6 enumerators_preload__7 enumerators_preload__8 enumerators_preload__9 enumerators_preload__10 enumerators_preload__11 enumerators_preload__12 enumerators_preload__13 enumerators_preload__14 enumerators_preload__15 enumerators_preload__16 enumerators_preload__17 enumerators_preload__18 enumerators_preload__19 enumerators_preload__20 enumerators_preload__21 enumerators_preload__22 enumerators_preload__23 enumerators_preload__24 enumerators_preload__25 enumerators_preload__26 enumerators_preload__27 enumerators_preload__28 enumerators_preload__29 enumerators_preload__30 enumerators_preload__31 enumerators_preload__32 enumerators_preload__33 enumerators_preload__34 enumerators_preload__35 enumerators_preload__36 enumerators_preload__37 enumerators_preload__38 enumerators_preload__39 enumerators_preload__40 enumerators_preload__41 enumerators_preload__42 enumerators_preload__43 enumerators_preload__44 enumerators_preload__45 enumerators_preload__46 enumerators_preload__47 enumerators_preload__48 enumerators_preload__49 enumerators_preload__50 enumerators_preload__51 enumerators_preload__52 enumerators_preload__53 enumerators_preload__54 enumerators_preload__55 enumerators_preload__56 enumerators_preload__57 enumerators_preload__58 enumerators_preload__59 enumerators_preload__60 enumerators_preload__61 enumerators_preload__62 enumerators_preload__63 enumerators_preload__64 enumerators_preload__65 enumerators_preload__66 enumerators_preload__67 enumerators_preload__68 enumerators_preload__69 enumerators_preload__70 enumerators_preload__71 enumerators_preload__72 enumerators_preload__73 enumerators_preload__74 enumerators_preload__75 enumerators_preload__76 enumerators_preload__77 enumerators_preload__78 enumerators_preload__79 enumerators_preload__80 enumerators_preload__81 enumerators_preload__82 enumerators_preload__83 enumerators_preload__84 enumerators_preload__85 enumerators_preload__86 enumerators_preload__87 enumerators_preload__88 enumerators_preload__89 enumerators_preload__90 enumerators_preload__91 enumerators_preload__92 enumerators_preload__93 enumerators_preload__94 enumerators_preload__95 enumerators_preload__96 enumerators_preload__97 enumerators_preload__98 enumerators_preload__99 m1s0q1_name


gen n_qu_no_ask=0 /*Numeric questions not asked*/
quietly ds, has(type numeric) 
foreach var in `r(varlist)'{
replace n_qu_no_ask=n_qu_no_ask + cond(`var'==.a,1,0)
}

gen str_qu_no_ask=0 /*String questions not asked*/
quietly ds, has(type string) 
foreach var in `r(varlist)'{
replace str_qu_no_ask=str_qu_no_ask + cond(`var'=="##N/A##",1,0)
}

gen qu_no_ask=n_qu_no_ask+str_qu_no_ask

* Interviews with 100 to 200 unanswered questions
export excel interview__key school_province_preload school_district_preload school_address_preload school_name_preload school_code_preload qu_no_ask m1s0q1_comments m1s0q2_name m1s0q1_name_other if qu_no_ask <= 200 & qu_no_ask >101 using "$Check\Question_non_repondu_1_`c(current_date)'.xlsx", datestring("%tc") sheetreplace firstrow(var)

* Check Interviews with more than 200 blank questions
export excel interview__key school_province_preload school_district_preload school_address_preload school_name_preload school_code_preload qu_no_ask m1s0q1_comments m1s0q2_name m1s0q1_name_other if qu_no_ask > 200 using "$Check\Question_non_repondu_2_`c(current_date)'.xlsx", datestring("%tc") sheetreplace firstrow(var) 


*** Number of modules 
global mod modules__1 modules__2 modules__3 modules__4 modules__5 modules__6 modules__7 modules__8  modules__9 modules__10
gen nb_mod=0 /*String questions not asked*/
quietly ds, has(type numeric) 
foreach var in $mod {
replace nb_mod=nb_mod + cond(`var'==1,1,0)
}
ta nb_mod


***********************************
*STATISTICS - APPROUVED QUESTIONNAIRES 
tab1 school_district_preload school_address_preload school_name_preload school_province_preload



***********************************


*** Vérification des écoles dont les informations sont incorrecte
global ecol school_name_preload m1s0q1_comments m1s0q2_name m1s0q1_name_other
foreach v in $ecol{
	export excel $ecol if school_info_correct==0 using "$Check\Ecole_non_preload_`c(current_date)'.xlsx", datestring("%tc") 		firstrow(varl) sheet("Liste", replace)
}


sort school_name_preload
foreach v in school_name_preload m1s0q1_comments{
	export excel school_name_preload m1s0q1_comments m1s0q1_name_other using "$Check\Ecole_`c(current_date)'.xlsx", datestring("%tc") 		firstrow(varl) sheet("Liste", replace)
}


* Check for missing GPS
foreach v in school_name_preload m1s0q1_name_other m1s0q1_comments m1s0q2_name {
	export excel school_name_preload m1s0q1_comments m1s0q2_name m1s0q1_name_other if m1s0q9__Latitude==.a using "$Check\Pas_de_GPS_`c(current_date)'.xlsx", datestring("%tc") 		firstrow(varl) sheet("Ecole", replace)	
}


* Check for selected moduls
sort school_name_preload
gen ecol_bis=cond(school_name_preload[_n]==school_name_preload[_n-1],1,0)
count if modules__1==1
count if modules__2==1
count if modules__3==1
count if modules__4==1
count if modules__5==1
count if modules__6==1
count if modules__7==1
count if modules__8==1
count if modules__9==1
count if modules__10==1


/* Les directeurs ayant refusé d'etre interrogé
foreach v in school_name_preload m1s0q1_name_other{
	export excel school_name_preload m1s0q1_name_other if m1s0q6==0 using "$Check\Refus_Enseignant_`c(current_date)'.xlsx", datestring("%tc") firstrow(varl) sheet("Liste", replace)
}
*/

/* Vérification de autre à préciser (Quelle est votre position dans l'école ?)
foreach v in school_name_preload m1s0q1_name_othe m7saq1_other{
	export excel school_name_preload m1s0q1_name_othe m7saq1_other if m7saq1==97 using "$Check\Autre_Preciser_`c(current_date)'.xlsx", datestring("%tc") firstrow(varl) sheet("Liste", replace)
}
*/

*Check variables with others options
ds *_other
foreach v of varlist *_other {
sort m1s0q2_emis interview__id `v'
export excel interview__key school_province_preload school_district_preload school_address_preload school_name_preload school_code_preload m1s0q2_code m1s0q2_emis m1s0q1_name_othe `v' using "$Check\Autre_Preciser_`c(current_date)'.xlsx", ///
		datestring("%tc") ///
		firstrow(var) ///
		sheet(`v') ///
		sheetreplace
}



gen experience=2023-m7saq3
tab experience
gen dure_post=2023-m7saq8
ta dure_post
br m1s0q1_name_othe m7saq9 experience if m7saq9[_n] < experience[_n] & experience[_n]!=.
list experience dure_post m7saq9


foreach v in m7saq3 m7saq8{
	export excel school_province_preload school_district_preload school_address_preload school_name_preload m1s0q1_comments m1s0q2_name m1s0q1_name_othe m7saq3 m7saq8 if m7saq3[_n] > m7saq8[_n] using  "$Check\Date_Incoh_`c(current_date)'.xlsx", datestring("%tc") firstrow(varl) sheet("Liste", replace)
}


/*
foreach v in s1_0_1_1 {
	export excel school_province_preload school_district_preload school_address_preload school_name_preload m1s0q1_comments m1s0q2_name m1s0q1_name_othe if `v'==1 | `v'==0 using  "$Check\TEACH_RENSEIG_`c(current_date)'.xlsx", datestring("%tc") firstrow(varl) sheet("Liste", replace)
}*/

*-------------------------------------------------------------------------------
*                                   CORRECTIONS
*-------------------------------------------------------------------------------
order modules__*

order modules__1 modules__2 modules__3 modules__4 modules__5 modules__6 modules__7 modules__8 modules__9 modules__10, after(m1s0q9__Timestamp)
br if school_info_correct == 0
/*
replace m1s0q2_emis ="" if m1s0q2_emis == "##N/A##"
destring m1s0q2_emis, gen(m1s0q2_emis_destring_destring)
br if m1s0q2_emis_destring == 5875 | m1s0q2_emis_destring == 6699| m1s0q2_emis_destring ==7282|m1s0q2_emis_destring == 7404 |m1s0q2_emis_destring ==	7746 |m1s0q2_emis_destring == 7819 |m1s0q2_emis_destring == 7719 |m1s0q2_emis_destring ==	222746 |m1s0q2_emis_destring ==	116 |m1s0q2_emis_destring ==	247 |m1s0q2_emis_destring ==	222760 |m1s0q2_emis_destring ==	871 |m1s0q2_emis_destring ==	6086 |m1s0q2_emis_destring == 5984 |m1s0q2_emis_destring ==	8669 |m1s0q2_emis_destring ==	13019 |m1s0q2_emis_destring ==	7708 |m1s0q2_emis_destring ==	226666 |m1s0q2_emis_destring ==	5891 |m1s0q2_emis_destring == 7285 |m1s0q2_emis_destring ==	223859 |m1s0q2_emis_destring ==	7460 |m1s0q2_emis_destring == 5893 |m1s0q2_emis_destring == 7006 |m1s0q2_emis_destring ==	224357 |m1s0q2_emis_destring ==	5175 |m1s0q2_emis_destring == 221377 |m1s0q2_emis_destring ==	67 |m1s0q2_emis_destring ==	10342 |m1s0q2_emis_destring ==	10354 |m1s0q2_emis_destring ==	2222 |m1s0q2_emis_destring ==	2041 |m1s0q2_emis_destring ==	223890 |m1s0q2_emis_destring ==	224262 |m1s0q2_emis_destring ==	2190 |m1s0q2_emis_destring ==	9253 |m1s0q2_emis_destring == 226788 |m1s0q2_emis_destring ==	223305 |m1s0q2_emis_destring ==	12953 |m1s0q2_emis_destring == 6435 |m1s0q2_emis_destring == 6539 |m1s0q2_emis_destring ==	8188 |m1s0q2_emis_destring ==	225986 |m1s0q2_emis_destring ==	6503 |m1s0q2_emis_destring == 6433 |m1s0q2_emis_destring == 6455
*/
* Replacing emis, code and name of school according to the monitoring file  on replaced schools
br if school_emis_preload == "Information a completer"

replace school_info_correct = 0 if interview__id == "40ba85fadc784d47a682c7e4f5c6ca0c"
replace m1s0q2_emis = "225921" if interview__id == "40ba85fadc784d47a682c7e4f5c6ca0c"
replace m1s0q2_code = "225921" if interview__id == "40ba85fadc784d47a682c7e4f5c6ca0c"
replace m1s0q2_name = "EVANGELIQUE SOURCE DE LA NOUVELLE VIE" if interview__id == "40ba85fadc784d47a682c7e4f5c6ca0c"

replace school_info_correct = 0 if interview__id == "5c4dfeb9cf73449486e3ebf83a15048b"
replace m1s0q2_emis = "4885" if interview__id == "5c4dfeb9cf73449486e3ebf83a15048b"
replace m1s0q2_code = "4885" if interview__id == "5c4dfeb9cf73449486e3ebf83a15048b"
replace m1s0q2_name = "ÉCOLE DE BALOUNGOU" if interview__id == "5c4dfeb9cf73449486e3ebf83a15048b"
replace m1s0q2_code = "13019" if interview__id == "b5286a4df5da4ae9b1a67e910f14e753"



replace m1s0q2_code = m1s0q2_emis if interview__id == "d51ee3379ac74c7f8d06d83b36b3eced"
replace m1s0q2_code = m1s0q2_emis if interview__id == "20e08f64d3fe4979a632d190b6876ac6"

duplicates report m1s0q2_emis

**Replacing missing informations in the identification variables according to the preloaded informations
replace m1s0q2_name = school_name_preload if school_info_correct == 1
replace m1s0q2_code = school_code_preload if school_info_correct == 1
replace m1s0q2_emis = school_emis_preload if school_info_correct == 1

br if m1s0q2_name == "##N/A##" | m1s0q2_code == "##N/A##" | m1s0q2_emis == "##N/A##"

replace m1s0q2_name = school_name_preload if m1s0q2_name == "##N/A##"
replace m1s0q2_code = school_code_preload if m1s0q2_code == "##N/A##"
replace m1s0q2_emis = school_emis_preload if m1s0q2_emis == "##N/A##"


**Gps missing correction referecing to the v3  of the questionnaire used by the enumators instead of the v5

replace m1s0q8 = "2023-05-20T07:46:08" if interview__id =="10533cbca4a54e59a6d4bf84da270b91" | interview__id == "28423511375c4a548c84aa7a3e38cdf1"
replace m1s0q9__Latitude = 8.92 if interview__id =="10533cbca4a54e59a6d4bf84da270b91" | interview__id == "28423511375c4a548c84aa7a3e38cdf1"
replace m1s0q9__Longitude = 17.55 if interview__id =="10533cbca4a54e59a6d4bf84da270b91" | interview__id == "28423511375c4a548c84aa7a3e38cdf1"
replace m1s0q9__Accuracy =  8.58 if interview__id =="10533cbca4a54e59a6d4bf84da270b91" | interview__id == "28423511375c4a548c84aa7a3e38cdf1"
replace m1s0q9__Altitude =  422.70 if interview__id =="10533cbca4a54e59a6d4bf84da270b91" | interview__id == "28423511375c4a548c84aa7a3e38cdf1"
replace m1s0q9__Timestamp =  "2023-05-20T07:02:01" if interview__id =="10533cbca4a54e59a6d4bf84da270b91" | interview__id == "28423511375c4a548c84aa7a3e38cdf1"


****Gps missing correction referecing to the v3 ( Assignement 106) of the questionnaire used by the enumators instead of the v5 
replace m1s0q8 = "2023-05-17T07:24:39" if interview__id =="cea8f9eba4604e399bba53da65b2868e" | interview__id == "2edefbbb00c64f8aa566cf047b95e60a"
replace m1s0q9__Latitude = 8.62 if interview__id =="cea8f9eba4604e399bba53da65b2868e" | interview__id == "2edefbbb00c64f8aa566cf047b95e60a"
replace m1s0q9__Longitude = 16.08 if interview__id =="cea8f9eba4604e399bba53da65b2868e" | interview__id == "2edefbbb00c64f8aa566cf047b95e60a"
replace m1s0q9__Accuracy =  9.80 if interview__id =="cea8f9eba4604e399bba53da65b2868e" | interview__id == "2edefbbb00c64f8aa566cf047b95e60a"
replace m1s0q9__Altitude =  454.70 if interview__id =="cea8f9eba4604e399bba53da65b2868e" | interview__id == "2edefbbb00c64f8aa566cf047b95e60a"
replace m1s0q9__Timestamp =  "2023-05-17T07:27:00" if interview__id =="cea8f9eba4604e399bba53da65b2868e" | interview__id == "2edefbbb00c64f8aa566cf047b95e60a"

****Gps missing correction referecing to the second questionnaire ( school code 224277)  
replace m1s0q9__Latitude = 12.06 if interview__id =="a49c7818badd4ef7a3311a9addf58f0d" 
replace m1s0q9__Longitude = 15.33 if interview__id =="a49c7818badd4ef7a3311a9addf58f0d" 
replace m1s0q9__Accuracy =  6.60 if interview__id =="a49c7818badd4ef7a3311a9addf58f0d" 
replace m1s0q9__Altitude =  310.20 if interview__id =="a49c7818badd4ef7a3311a9addf58f0d" 
replace m1s0q9__Timestamp =  "2023-05-18T06:40:33" if interview__id =="a49c7818badd4ef7a3311a9addf58f0d" 

****Gps missing correction referecing to the second questionnaire ( school code 13258)  
replace m1s0q9__Latitude = 8.92 if interview__id =="e2e2bb2a7f564111a66dad6036b9eb3f" 
replace m1s0q9__Longitude = 17.55 if interview__id =="e2e2bb2a7f564111a66dad6036b9eb3f" 
replace m1s0q9__Accuracy =  8.58 if interview__id =="e2e2bb2a7f564111a66dad6036b9eb3f" 
replace m1s0q9__Altitude =  375.31 if interview__id =="e2e2bb2a7f564111a66dad6036b9eb3f" 
replace m1s0q9__Timestamp =  "2023-05-13T10:09:51" if interview__id =="e2e2bb2a7f564111a66dad6036b9eb3f" 

****Gps missing correction referecing to the second questionnaire ( school code 1190)  
replace m1s0q9__Latitude = 8.73 if interview__id =="f7d699d110fb4086bfc0201a5d227fd4" 
replace m1s0q9__Longitude = 17.01 if interview__id =="f7d699d110fb4086bfc0201a5d227fd4" 
replace m1s0q9__Accuracy =  20.37 if interview__id =="f7d699d110fb4086bfc0201a5d227fd4" 
replace m1s0q9__Altitude =  318.88 if interview__id =="f7d699d110fb4086bfc0201a5d227fd4" 
replace m1s0q9__Timestamp =  "2023-05-03T14:16:16" if interview__id =="f7d699d110fb4086bfc0201a5d227fd4" 

****Gps missing correction referecing to the second questionnaire ( school code 589)  
replace m1s0q9__Latitude = 9.00 if interview__id =="79a7718843444a1f8c6e7f13cfeda99c" 
replace m1s0q9__Longitude = 16.34 if interview__id =="79a7718843444a1f8c6e7f13cfeda99c" 
replace m1s0q9__Accuracy =  8.60 if interview__id =="79a7718843444a1f8c6e7f13cfeda99c" 
replace m1s0q9__Altitude =  439.90 if interview__id =="79a7718843444a1f8c6e7f13cfeda99c" 
replace m1s0q9__Timestamp =  "2023-05-06T14:21:06" if interview__id =="79a7718843444a1f8c6e7f13cfeda99c" 


****Gps missing correction referecing to the second questionnaire ( school code 526)  
replace m1s0q9__Latitude = 8.98 if interview__id =="87264515f51d4b9c86613896863a915f" 
replace m1s0q9__Longitude = 16.32 if interview__id =="87264515f51d4b9c86613896863a915f" 
replace m1s0q9__Accuracy =  6.50 if interview__id =="87264515f51d4b9c86613896863a915f" 
replace m1s0q9__Altitude =  436.40 if interview__id =="87264515f51d4b9c86613896863a915f" 
replace m1s0q9__Timestamp =  "2023-05-03T07:03:05" if interview__id =="87264515f51d4b9c86613896863a915f" 


****Gps missing correction referecing to the second questionnaire ( school code 5302)  
replace m1s0q9__Latitude = 9.06 if interview__id =="71b5d15038b54b6ba3a54692aecfd94d" 
replace m1s0q9__Longitude = 15.60 if interview__id =="71b5d15038b54b6ba3a54692aecfd94d" 
replace m1s0q9__Accuracy =  3.22 if interview__id =="71b5d15038b54b6ba3a54692aecfd94d" 
replace m1s0q9__Altitude =  448.69 if interview__id =="71b5d15038b54b6ba3a54692aecfd94d" 
replace m1s0q9__Timestamp =  "2023-05-08T07:46:50" if interview__id =="71b5d15038b54b6ba3a54692aecfd94d" 


****Gps missing correction referecing to the second questionnaire ( school code 291)  
replace m1s0q9__Latitude = 8.59 if interview__id =="b0ebe820140743aaa56bf21f3b7e9577" 
replace m1s0q9__Longitude = 16.05 if interview__id =="b0ebe820140743aaa56bf21f3b7e9577" 
replace m1s0q9__Accuracy =  8.10 if interview__id =="b0ebe820140743aaa56bf21f3b7e9577" 
replace m1s0q9__Altitude =  421.80 if interview__id =="b0ebe820140743aaa56bf21f3b7e9577" 
replace m1s0q9__Timestamp =  "2023-05-03T08:21:20" if interview__id =="b0ebe820140743aaa56bf21f3b7e9577" 


****Gps missing correction referecing to the second questionnaire ( school code 5193)  
replace m1s0q9__Latitude = 9.29 if interview__id =="f4f8df29f26841fc8703230029c83530" 
replace m1s0q9__Longitude = 15.80 if interview__id =="f4f8df29f26841fc8703230029c83530" 
replace m1s0q9__Accuracy =  4.29 if interview__id =="f4f8df29f26841fc8703230029c83530" 
replace m1s0q9__Altitude =  400.41 if interview__id =="f4f8df29f26841fc8703230029c83530" 
replace m1s0q9__Timestamp =  "2023-05-12T06:52:25" if interview__id =="f4f8df29f26841fc8703230029c83530" 


****Gps missing correction referecing to the second questionnaire ( school code 50)  
replace m1s0q9__Latitude = 8.89 if interview__id =="a5f66a07164b4564a7f9cf76365d5226" 
replace m1s0q9__Longitude = 15.61 if interview__id =="a5f66a07164b4564a7f9cf76365d5226" 
replace m1s0q9__Accuracy = 9.70 if interview__id =="a5f66a07164b4564a7f9cf76365d5226" 
replace m1s0q9__Altitude =  354.10 if interview__id =="a5f66a07164b4564a7f9cf76365d5226" 
replace m1s0q9__Timestamp =  "2023-05-16T10:07:27" if interview__id =="a5f66a07164b4564a7f9cf76365d5226" 



****Gps missing correction referecing to the second questionnaire ( school code 9946)  
replace m1s0q9__Latitude = 9.05 if interview__id =="03d6580ea99d46678376cdd939b46e6a" 
replace m1s0q9__Longitude = 16.29 if interview__id =="03d6580ea99d46678376cdd939b46e6a" 
replace m1s0q9__Accuracy = 10.20 if interview__id =="03d6580ea99d46678376cdd939b46e6a" 
replace m1s0q9__Altitude =  400.10 if interview__id =="03d6580ea99d46678376cdd939b46e6a" 
replace m1s0q9__Timestamp =  "2023-05-05T06:45:12" if interview__id =="03d6580ea99d46678376cdd939b46e6a" 


****Gps missing correction referecing to the second questionnaire ( school code 10799)  
replace m1s0q9__Latitude = 9.30 if interview__id =="55d0fd1ab07443dd850a2dfdcd03d62d" 
replace m1s0q9__Longitude = 15.80 if interview__id =="55d0fd1ab07443dd850a2dfdcd03d62d" 
replace m1s0q9__Accuracy = 10.72 if interview__id =="55d0fd1ab07443dd850a2dfdcd03d62d" 
replace m1s0q9__Altitude =  394.54 if interview__id =="55d0fd1ab07443dd850a2dfdcd03d62d" 
replace m1s0q9__Timestamp =  "2023-05-11T08:30:48" if interview__id =="55d0fd1ab07443dd850a2dfdcd03d62d" 


****Gps missing correction referecing to the second questionnaire ( school code 224574)  
replace m1s0q9__Latitude = 9.11 if interview__id =="ccac2a81a3304e54a7485672cf88f8f8" 
replace m1s0q9__Longitude = 16.23 if interview__id =="ccac2a81a3304e54a7485672cf88f8f8" 
replace m1s0q9__Accuracy = 11.20 if interview__id =="ccac2a81a3304e54a7485672cf88f8f8" 
replace m1s0q9__Altitude =  412.00 if interview__id =="ccac2a81a3304e54a7485672cf88f8f8" 
replace m1s0q9__Timestamp =  "2023-05-08T07:01:48" if interview__id =="ccac2a81a3304e54a7485672cf88f8f8" 


****Gps missing correction referecing to the second questionnaire ( school code 5186)  
replace m1s0q9__Latitude = 9.31 if interview__id =="3773199f8cc14606b7a5d8581df2c15a" 
replace m1s0q9__Longitude = 15.78 if interview__id =="3773199f8cc14606b7a5d8581df2c15a" 
replace m1s0q9__Accuracy = 6.43 if interview__id =="3773199f8cc14606b7a5d8581df2c15a" 
replace m1s0q9__Altitude =  385.67 if interview__id =="3773199f8cc14606b7a5d8581df2c15a" 
replace m1s0q9__Timestamp =  "2023-05-12T09:07:14" if interview__id =="3773199f8cc14606b7a5d8581df2c15a" 


****Gps missing correction referecing to the second questionnaire ( school code 203)  
replace m1s0q9__Latitude = 9.02 if interview__id =="c951135c4da241399def58e37be7a098" 
replace m1s0q9__Longitude = 16.12 if interview__id =="c951135c4da241399def58e37be7a098" 
replace m1s0q9__Accuracy = 11.70 if interview__id =="c951135c4da241399def58e37be7a098" 
replace m1s0q9__Altitude =  445.60 if interview__id =="c951135c4da241399def58e37be7a098" 
replace m1s0q9__Timestamp =  "2023-05-10T08:17:16" if interview__id =="c951135c4da241399def58e37be7a098" 


****Gps missing correction referecing to the second questionnaire ( school code 10140)  
replace m1s0q9__Latitude = 8.72 if interview__id =="552ffd76b98b496c8885c60eb2d5335d" 
replace m1s0q9__Longitude = 17.69 if interview__id =="552ffd76b98b496c8885c60eb2d5335d" 
replace m1s0q9__Accuracy = 9.65 if interview__id =="552ffd76b98b496c8885c60eb2d5335d" 
replace m1s0q9__Altitude =  392.05 if interview__id =="552ffd76b98b496c8885c60eb2d5335d" 
replace m1s0q9__Timestamp =  "2023-05-06T13:54:44" if interview__id =="552ffd76b98b496c8885c60eb2d5335d" 

****Gps missing correction referecing to the second questionnaire ( school code 220530)  
replace m1s0q9__Latitude = 8.97 if interview__id =="33b3ff106019445f8e605e02f9133995" 
replace m1s0q9__Longitude = 15.79 if interview__id =="33b3ff106019445f8e605e02f9133995" 
replace m1s0q9__Accuracy = 10.70 if interview__id =="33b3ff106019445f8e605e02f9133995" 
replace m1s0q9__Altitude =  511.90 if interview__id =="33b3ff106019445f8e605e02f9133995" 
replace m1s0q9__Timestamp =  "2023-05-11T09:43:51" if interview__id =="33b3ff106019445f8e605e02f9133995" 



****Gps missing correction referecing to the second questionnaire ( school code 225689)  
replace m1s0q9__Latitude = 8.59 if interview__id =="3aa481c4864a404b91b581a41365d555" 
replace m1s0q9__Longitude = 16.02 if interview__id =="3aa481c4864a404b91b581a41365d555" 
replace m1s0q9__Accuracy = 12.50 if interview__id =="3aa481c4864a404b91b581a41365d555" 
replace m1s0q9__Altitude =  389.80 if interview__id =="3aa481c4864a404b91b581a41365d555" 
replace m1s0q9__Timestamp =  "2023-05-09T06:36:19" if interview__id =="3aa481c4864a404b91b581a41365d555" 


****Gps missing correction referecing to the second questionnaire ( school code 226260) 
replace m1s0q8 = "2023-05-11T07:09:07" if interview__id =="84e696df97494b63b3650846efb6d208"  
replace m1s0q9__Latitude = 8.93 if interview__id =="84e696df97494b63b3650846efb6d208" 
replace m1s0q9__Longitude = 15.82 if interview__id =="84e696df97494b63b3650846efb6d208" 
replace m1s0q9__Accuracy = 10.30 if interview__id =="84e696df97494b63b3650846efb6d208" 
replace m1s0q9__Altitude =  389.50 if interview__id =="84e696df97494b63b3650846efb6d208" 
replace m1s0q9__Timestamp =  "2023-05-11T07:11:40" if interview__id =="84e696df97494b63b3650846efb6d208" 


****Gps missing correction referecing to the second questionnaire ( school code 4885) 
replace m1s0q9__Latitude = 9.43 if interview__id =="5c4dfeb9cf73449486e3ebf83a15048b" 
replace m1s0q9__Longitude = 16.43 if interview__id =="5c4dfeb9cf73449486e3ebf83a15048b" 
replace m1s0q9__Accuracy = 16.08 if interview__id =="5c4dfeb9cf73449486e3ebf83a15048b" 
replace m1s0q9__Altitude =  346.50 if interview__id =="5c4dfeb9cf73449486e3ebf83a15048b" 
replace m1s0q9__Timestamp =  "2023-05-17T07:40:07" if interview__id =="5c4dfeb9cf73449486e3ebf83a15048b" 


****Gps missing correction referecing to the second questionnaire ( school code 67) 
replace m1s0q9__Latitude = 8.86 if interview__id =="7a92d7e3e36a43f4ad3a019b3c8a4670" 
replace m1s0q9__Longitude = 15.67 if interview__id =="7a92d7e3e36a43f4ad3a019b3c8a4670" 
replace m1s0q9__Accuracy = 8.20 if interview__id =="7a92d7e3e36a43f4ad3a019b3c8a4670" 
replace m1s0q9__Altitude =  429.30 if interview__id =="7a92d7e3e36a43f4ad3a019b3c8a4670" 
replace m1s0q9__Timestamp =  "2023-05-16T12:36:01" if interview__id =="7a92d7e3e36a43f4ad3a019b3c8a4670" 

****Gps missing correction referecing to the second questionnaire ( school code 9984) 
replace m1s0q9__Latitude = 8.90 if interview__id =="45f2e3b6811248298223b2cf1132c9f7" 
replace m1s0q9__Longitude = 15.85 if interview__id =="45f2e3b6811248298223b2cf1132c9f7" 
replace m1s0q9__Accuracy = 4.00 if interview__id =="45f2e3b6811248298223b2cf1132c9f7" 
replace m1s0q9__Altitude =  415.00 if interview__id =="45f2e3b6811248298223b2cf1132c9f7" 
replace m1s0q9__Timestamp =  "2023-05-12T09:06:00" if interview__id =="45f2e3b6811248298223b2cf1132c9f7" 


****Gps missing correction referecing to the second questionnaire ( school code 529) 
replace m1s0q9__Latitude =9.02 if interview__id =="109023e3377e4fbcb0319d3d45a4e521" 
replace m1s0q9__Longitude = 16.23 if interview__id =="109023e3377e4fbcb0319d3d45a4e521" 
replace m1s0q9__Accuracy = 10.70 if interview__id =="109023e3377e4fbcb0319d3d45a4e521" 
replace m1s0q9__Altitude =  412.40 if interview__id =="109023e3377e4fbcb0319d3d45a4e521" 
replace m1s0q9__Timestamp =  "2023-05-04T07:05:38" if interview__id =="109023e3377e4fbcb0319d3d45a4e521" 

replace m1s0q8 = "2023-05-11T06:57:56" if interview__id =="f1a23807f79b4e90b62c34f4ffb2357c"  
replace m1s0q8 = "2023-05-03T08:21:09" if interview__id =="35cc475a859d443499e7c931fc3ecf4f"  
replace m1s0q8 = "2023-05-16T06:36:37" if interview__id =="38eb3d2dd02041e8a5969942b17ab2d9"  

**** Correction on others to precise

replace 	m1saq3 	 = 	3	 if 	interview__key	 ==	"78-04-90-88"
replace 	m1saq3 	 = 	3	 if 	interview__key	 ==	"59-34-69-23"
replace 	m1saq6a	 = 	2	 if 	interview__key	 ==	"29-82-62-42"

*Redifine the codebook of m1saq6b variable (Arabic and French instead of Arabic and English)
label define mylabel1 1 "Arabic" 2 "French", modify
label values m1saq6b mylabel1, nofix

*Replace the mean language of var m1saq6b code according to the variable m1saq6b_other
replace m1saq6b= 2 if m1saq6b==99
br m1saq6b m1saq6b_other

* Replace the codebook of m7saq7 according to m7saq7_other
replace m7saq7 = 6 if interview__key =="73-29-45-33"
replace m7saq7 = 6 if interview__key =="60-08-58-30"
replace m7saq7 = 6 if interview__key =="88-81-81-48"
replace m7saq7 = 6 if interview__key =="42-90-04-56"
replace m7saq7 = 6 if interview__key =="61-07-92-25"
replace m7saq7 = 6 if interview__key =="19-70-15-88"
replace m7saq7 = 6 if interview__key =="16-69-84-45"
replace m7saq7 = 6 if interview__key =="70-02-69-71"
replace m7saq7 = 6 if interview__key =="55-70-20-91"
replace m7saq7 = 6 if interview__key =="89-54-63-18"
replace m7saq7 = 6 if interview__key =="46-52-59-73"
replace m7saq7 = 7 if interview__key =="66-63-23-27"
replace m7saq7 = 6 if interview__key =="12-52-61-17"
replace m7saq7 = 6 if interview__key =="22-49-63-18"
replace m7saq7 = 6 if interview__key =="21-45-58-75"

replace m7saq7 = 5 if interview__key =="77-76-13-71"
replace m7saq7 = 5 if interview__key =="99-96-93-36"
replace m7saq7 = 5 if interview__key =="42-21-17-97"
replace m7saq7 = 5 if interview__key =="82-63-41-92"
replace m7saq7 = 5 if interview__key =="52-74-66-97"
replace m7saq7 = 5 if interview__key =="35-10-74-04"
replace m7saq7 = 5 if interview__key =="47-44-91-68"
replace m7saq7 = 5 if interview__key =="15-73-53-12"
replace m7saq7 = 5 if interview__key =="66-29-69-32"
replace m7saq7 = 5 if interview__key =="33-41-16-18"
replace m7saq7 = 5 if interview__key =="89-85-52-94"
replace m7saq7 = 5 if interview__key =="98-60-08-72"
replace m7saq7 = 5 if interview__key =="05-49-18-67"
replace m7saq7 = 5 if interview__key =="88-81-81-48"
replace m7saq7 = 5 if interview__key =="34-03-77-54"
replace m7saq7 = 5 if interview__key =="19-65-47-75"
replace m7saq7 = 5 if interview__key =="90-19-64-87"
replace m7saq7 = 5 if interview__key =="30-67-31-65"
replace m7saq7 = 5 if interview__key =="88-03-20-86"
replace m7saq7 = 5 if interview__key =="54-20-28-21"
replace m7saq7 = 5 if interview__key =="40-95-10-40"
replace m7saq7 = 5 if interview__key =="84-76-30-49"
replace m7saq7 = 5 if interview__key =="37-43-98-07"
replace m7saq7 = 5 if interview__key =="82-56-98-18"
replace m7saq7 = 5 if interview__key =="16-09-24-34"
replace m7saq7 = 5 if interview__key =="39-13-94-18"
replace m7saq7 = 5 if interview__key =="90-23-86-88"
replace m7saq7 = 5 if interview__key =="51-93-26-44"
replace m7saq7 = 5 if interview__key =="37-91-67-79"
replace m7saq7 = 5 if interview__key =="57-80-07-16"
replace m7saq7 = 5 if interview__key =="96-91-26-30"
replace m7saq7 = 5 if interview__key =="07-19-44-32"
replace m7saq7 = 5 if interview__key =="48-54-23-23"
replace m7saq7 = 5 if interview__key =="66-63-57-74"
replace m7saq7 = 5 if interview__key =="78-04-90-88"
replace m7saq7 = 5 if interview__key =="94-44-46-32"
replace m7saq7 = 5 if interview__key =="59-34-69-23"
replace m7saq7 = 5 if interview__key =="85-43-84-31"
replace m7saq7 = 5 if interview__key =="46-52-59-73"
replace m7saq7 = 5 if interview__key =="84-38-84-31"
replace m7saq7 = 5 if interview__key =="40-72-46-09"
replace m7saq7 = 5 if interview__key =="16-66-56-52"
replace m7saq7 = 5 if interview__key =="49-49-27-65"
replace m7saq7 = 5 if interview__key =="82-11-82-47"
replace m7saq7 = 5 if interview__key =="99-85-51-16"
replace m7saq7 = 5 if interview__key =="26-48-15-76"
replace m7saq7 = 5 if interview__key =="63-86-92-21"
replace m7saq7 = 5 if interview__key =="75-70-17-91"
replace m7saq7 = 5 if interview__key =="73-76-66-15"
replace m7saq7 = 5 if interview__key =="34-06-73-09"
replace m7saq7 = 5 if interview__key =="60-53-69-01"
replace m7saq7 = 5 if interview__key =="03-34-49-26"
replace m7saq7 = 5 if interview__key =="68-69-92-84"
replace m7saq7 = 5 if interview__key =="25-34-98-19"
replace m7saq7 = 5 if interview__key =="66-12-89-95"
replace m7saq7 = 5 if interview__key =="15-46-62-25"
replace m7saq7 = 5 if interview__key =="41-02-59-75"
replace m7saq7 = 5 if interview__key =="62-95-59-72"
replace m7saq7 = 5 if interview__key =="68-11-98-61"
replace m7saq7 = 5 if interview__key =="11-50-55-10"
replace m7saq7 = 5 if interview__key =="54-15-80-10"
replace m7saq7 = 5 if interview__key =="20-68-04-19"
replace m7saq7 = 5 if interview__key =="35-12-23-37"
replace m7saq7 = 5 if interview__key =="02-31-22-20"
replace m7saq7 = 5 if interview__key =="82-56-98-18"
replace m7saq7 = 5 if interview__key =="05-78-00-84"
replace m7saq7 = 5 if interview__key =="56-81-64-80"
replace m7saq7 = 5 if interview__key =="50-40-61-79"

sort school_emis
br

***Drop all variables created for the cleaning process
drop dup* _merge all_ob id n_qu_no_ask str_qu_no_ask qu_no_ask nb_mod ecol_bis experience dure_post



********************************************************************************
* 						SAVE THE CLEANED DATA IN CSV , STATA AND EXCEL FORMAT
********************************************************************************


export delimited "D:\IHfRA\Projet GEPD TCHAD\GEPD TCHAD ORIGINAL\DATA QUALITY\HFC\Cleaned data\GEPD_CHAD_SCHOOL_2023.csv",  replace 

*save "D:\IHfRA\Projet GEPD TCHAD\GEPD TCHAD ORIGINAL\DATA QUALITY\HFC\Cleaned data\GEPD_CHAD_SCHOOL_2023.dta", replace

*export excel using "D:\IHfRA\Projet GEPD TCHAD\GEPD TCHAD ORIGINAL\DATA QUALITY\HFC\Cleaned data\GEPD_CHAD_SCHOOL_2023.xlsx", sheet("GEPD_CHAD_SCHOOL_2023", replace) firstrow(variables) 


/*	
 ***************************** End of do-file ************************
