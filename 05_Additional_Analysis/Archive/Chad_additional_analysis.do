*-------------------------------------------
* GEPD - Chad
* Addressing addtitional analysis requests 
* By: Mohammed ElDesouky - Feb 29th 2024. 

*------------------------------------------


**# Bookmark #1
clear all
*Set working directory on your computer here
gl wrk_dir "C:\Users\wb589124\Downloads\GEPD_Production-Chad\03_GEPD_processed_data\School\Confidential\Cleaned"
gl save_dir "C:\Users\wb589124\Downloads\\requests\\"


// Load data
cap frame create fourth
frame change fourth
use "${wrk_dir}/fourth_grade_Stata"

cap frame create second
frame change second
use "${wrk_dir}/second_grade_Stata"

cap frame create first
frame change first
use "${wrk_dir}/first_grade_Stata"

cap frame create school
frame change school
use "${wrk_dir}/school_Stata"

cap frame create teachers
frame change teachers
use "${wrk_dir}/teachers_Stata"


*1. Share of students by gender (for all grades- bar graph)
frame change fourth
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || fourth_grade_assessment__id, weight(g4_stud_weight)
estpost svy: tab m8s1q3, percent
matrix define student_ratio = e(b), e(obs)

frame change second
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || ecd_assessment_g2__id, weight(g2_stud_weight)
estpost svy: tab m10s1q3, percent col
matrix student_ratio = student_ratio\e(b), e(obs)

frame change first
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || ecd_assessment__id, weight(g1_stud_weight)
estpost svy: tab m6s1q3, percent col
matrix student_ratio = student_ratio\e(b), e(obs)

*-- putting all in tables 
mat colname student_ratio= Male(%) Female(%) Total Male(n) Female(n) N
mat rowname student_ratio= Grade4 Grade2 Grade1
esttab matrix (student_ratio, fmt(0))  using ${save_dir}/analysis_Chad.rtf, compress mlab(none) replace ///
	title(Student ratio per grade) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up")

	
*2. Student attendance by gender (for 4th grade- bar graph)
frame change school
svyset school_code [pw=school_weight], strata($strata) singleunit(scaled) 
svy: mean student_attendance   						 //mean is an estimation already stored in e() -- no need to post it with "post"
matrix define student_attendance = e(b), e(N)		// added to a matrix that we would keep adding estimates to it to tabulate later

svyset school_code [pw=school_weight], strata($strata) singleunit(scaled) 
svy: mean student_attendance_male
matrix student_attendance = student_attendance\e(b), e(N)

svyset school_code [pw=school_weight], strata($strata) singleunit(scaled) 
svy: mean student_attendance_female
matrix student_attendance = student_attendance\e(b), e(N)

*-- putting all in tables 
mat colname student_attendance= (%) (N)
mat rowname student_attendance= Total Male Female
esttab matrix (student_attendance, fmt(1))  using ${save_dir}/analysis_Chad.rtf, compress mlab(none) append ///
	title(Student attendance (Total and by Gender)) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up")


*3. Learning in grade 1, 2, and 4 by gender, both proficiency and knowledge scores (overall and per subject/domain) (table)
// -- Fourth grade
frame change fourth
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || fourth_grade_assessment__id, weight(g4_stud_weight)

svy, over(m8s1q3): mean student_proficient 
matrix student_learning = e(b)

svy, over(m8s1q3): mean math_student_proficient 
matrix student_learning = student_learning\e(b)

svy, over(m8s1q3): mean literacy_student_proficient
matrix student_learning = student_learning\e(b)

svy, over(m8s1q3): mean student_knowledge 
matrix student_learning = student_learning\e(b)

svy, over(m8s1q3): mean math_student_knowledge 
matrix student_learning = student_learning\e(b)

svy, over(m8s1q3): mean literacy_student_knowledge
matrix student_learning = student_learning\e(b)
*-- putting all in tables 
mat colname student_learning= Male Female
mat rowname student_learning= Proficiency(overall) Proficiency(Math) Proficiency(Literacy) Knowledge(overall) Knowledge(Math) knowledge(Literacy) 
esttab matrix (student_learning, fmt(2)) using ${save_dir}/analysis_Chad.rtf, compress mlab(none) append ///
	title(Fourth grade student learning (by Gender & Domain)) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up")

	
// -- Second grade
clear matrix
frame change second
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || ecd_assessment_g2__id, weight(g2_stud_weight)

svy, over(m10s1q3): mean ecd2_student_proficiency 
matrix student_learning = e(b)

svy, over(m10s1q3): mean ecd2_math_student_proficiency
matrix student_learning = student_learning\e(b)

svy, over(m10s1q3): mean ecd2_litera_student_proficiency
matrix student_learning = student_learning\e(b)

svy, over(m10s1q3): mean ecd2_soc_student_proficiency
matrix student_learning = student_learning\e(b)

svy, over(m10s1q3): mean ecd2_exec_student_proficiency
matrix student_learning = student_learning\e(b)

svy, over(m10s1q3): mean ecd2_student_knowledge 
matrix student_learning = student_learning\e(b)

svy, over(m10s1q3): mean ecd2_math_student_knowledge
matrix student_learning = student_learning\e(b)

svy, over(m10s1q3): mean ecd2_literacy_student_knowledge
matrix student_learning = student_learning\e(b)

svy, over(m10s1q3): mean ecd2_soc_student_knowledge
matrix student_learning = student_learning\e(b)

svy, over(m10s1q3): mean ecd2_exec_student_knowledge
matrix student_learning = student_learning\e(b)
*-- putting all in tables 
mat colname student_learning= Male Female
mat rowname student_learning= Proficiency(overall) Proficiency(Math) Proficiency(Literacy) ///
	Proficiency(Soc) Proficiency(exec) Knowledge(overall) Knowledge(Math) knowledge(Literacy) knowledge(Soc) knowledge(exec) 
esttab matrix (student_learning, fmt(1)) using ${save_dir}/analysis_Chad.rtf, compress mlab(none) append ///
	title(Second grade student learning (by Gender & Domain)) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up")

// -- First grade
clear matrix
frame change first
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || ecd_assessment__id, weight(g1_stud_weight)

svy, over(m6s1q3): mean ecd_student_proficiency
matrix student_learning = e(b)

svy, over(m6s1q3): mean ecd_math_student_proficiency
matrix student_learning = student_learning\e(b)

svy, over(m6s1q3): mean ecd_literacy_student_proficiency
matrix student_learning = student_learning\e(b)

svy, over(m6s1q3): mean ecd_soc_student_proficiency
matrix student_learning = student_learning\e(b)

svy, over(m6s1q3): mean ecd_exec_student_proficiency
matrix student_learning = student_learning\e(b)

svy, over(m6s1q3): mean ecd_student_knowledge
matrix student_learning = student_learning\e(b)

svy, over(m6s1q3): mean ecd_math_student_knowledge
matrix student_learning = student_learning\e(b)

svy, over(m6s1q3): mean ecd_literacy_student_knowledge
matrix student_learning = student_learning\e(b)

svy, over(m6s1q3): mean ecd_soc_student_knowledge
matrix student_learning = student_learning\e(b)

svy, over(m6s1q3): mean ecd_exec_student_knowledge
matrix student_learning = student_learning\e(b)
*-- putting all in tables 
mat colname student_learning= Male Female
mat rowname student_learning= Proficiency(overall) Proficiency(Math) Proficiency(Literacy) ///
	Proficiency(Soc) Proficiency(exec) Knowledge(overall) Knowledge(Math) knowledge(Literacy) knowledge(Soc) knowledge(exec)
esttab matrix (student_learning, fmt(1)) using ${save_dir}/analysis_Chad.rtf, compress mlab(none) append ///
	title(First grade student learning (by Gender & Domain)) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up")

*4. Share of teachers by gender (bar graph staked)
frame change teachers
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || unique_teach_id, weight(teacher_questionnaire_weight)
estpost svy: tab m2saq3, percent
matrix define teachers_ratio = e(b), e(obs)
*-- putting all in tables 
mat colname teachers_ratio= Male(%) Female(%) Total Male(n) Female(n) N
mat rowname teachers_ratio= Teachers
esttab matrix (teachers_ratio, fmt(0))  using ${save_dir}/analysis_Chad.rtf, compress mlab(none) append ///
	title(Teachers' by-gender ratio) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up")

*5. Teacher attendance by gender (bar or distribution overlayed )
frame change teachers
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || unique_teach_id, weight(teacher_abs_weight)
gen sch_presence_rate= 1-sch_absence_rate
estpost svy: tab  sch_presence_rate m2saq3, percent col
matrix teachers_presence = e(b)
*-- putting all in tables 
mat colname teachers_presence=  Male:(No) Male:(Yes) Male:Total Female:(No) Female:(Yes) Female:Total Both:(No) Both:(Yes) Both:Total
mat rowname teachers_presence= Teachers-presence(%)
esttab matrix (teachers_presence, transpose fmt(1))  using ${save_dir}/analysis_Chad.rtf, compress mlab(none) append ///
	title(Teachers' presence by gender) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up")


*6. Teacher content knowledge, score and proficiency, overall and per subject (table)
frame change teachers
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || unique_teach_id, weight(teacher_content_weight)

svy, over(m2saq3): mean content_proficiency 
matrix content_knowledge = e(b)

svy, over(m2saq3): mean math_content_proficiency 
matrix content_knowledge = content_knowledge\e(b)

svy, over(m2saq3): mean literacy_content_proficiency
matrix content_knowledge = content_knowledge\e(b)

svy, over(m2saq3): mean content_knowledge 
matrix content_knowledge = content_knowledge\e(b)

svy, over(m2saq3): mean math_content_knowledge
matrix content_knowledge = content_knowledge\e(b)

svy, over(m2saq3): mean literacy_content_knowledge
matrix content_knowledge = content_knowledge\e(b)
*-- putting all in tables 
mat colname content_knowledge= Male Female
mat rowname content_knowledge= Proficiency(overall) Proficiency(Math) Proficiency(Literacy) Knowledge(overall) Knowledge(Math) knowledge(Literacy) 
esttab matrix (content_knowledge, fmt(2)) using ${save_dir}/analysis_Chad.rtf, compress mlab(none) append ///
	title(Teachers content knowledge (by Gender & Domain)) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up")


*7. Teacher pedagogical skills, both proficiency and scores, overall and per domain/areas (table)
frame change teachers
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || unique_teach_id, weight(teacher_pedagogy_weight)

gen teach_profi =. 
replace teach_profi=100 if teach_score>=3 & teach_score!=.
replace teach_profi=0 if  teach_score<3 & teach_score!=.

gen classroom_culture_profi =. 
replace classroom_culture_profi=100 if classroom_culture>=3 & classroom_culture!=.
replace classroom_culture_profi=0 if classroom_culture<3 & classroom_culture!=.

gen instruction_profi =. 
replace instruction_profi=100 if instruction>=3 & instruction!=.
replace instruction_profi=0 if instruction<3 & instruction!=.

gen socio_emotional_skills_profi =. 
replace socio_emotional_skills_profi=100 if socio_emotional_skills>=3 & socio_emotional_skills!=.
replace socio_emotional_skills_profi=0 if socio_emotional_skills<3 & socio_emotional_skills!=.


svy, over(m2saq3): mean teach_profi 
matrix teach_scores = e(b)

svy, over(m2saq3): mean classroom_culture_profi
matrix teach_scores = teach_scores\e(b)

svy, over(m2saq3): mean instruction_profi
matrix teach_scores = teach_scores\e(b)

svy, over(m2saq3): mean socio_emotional_skills_profi
matrix teach_scores = teach_scores\e(b)

svy, over(m2saq3): mean teach_score 
matrix teach_scores = teach_scores\e(b)

svy, over(m2saq3): mean classroom_culture
matrix teach_scores = teach_scores\e(b)

svy, over(m2saq3): mean instruction
matrix teach_scores = teach_scores\e(b)

svy, over(m2saq3): mean socio_emotional_skills
matrix teach_scores = teach_scores\e(b)
*-- putting all in tables 
mat colname teach_scores= Male Female
mat rowname teach_scores= Prof(teach) Prof(classroom_culture) Prof(instruction) Prof(socio_emotional) ///
	Score(teach) score(classroom_culture) score(instruction) score(socio_emotional)  
esttab matrix (teach_scores, fmt(2)) using ${save_dir}/analysis_Chad.rtf, compress mlab(none) append ///
	title(Teachers pedagogical skills proficiency & scores (by Gender & Domain)) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up")

	
*8. Share of principals, by gender (bar stacked)
frame change school
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)

estpost svy: tab m7saq10 , percent
matrix define principles_ratio = e(b), e(obs)
*-- putting all in tables 
mat colname principles_ratio= Male(%) Female(%) Total Male(n) Female(n) N
mat rowname principles_ratio= Principles
esttab matrix (principles_ratio, fmt(0))  using ${save_dir}/analysis_Chad.rtf, compress mlab(none) append ///
	title(Principles' by-gender ratio) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up")


*9. School management indicator (by gender of the principals) (bar graph)
frame change school
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)

svy, over(m7saq10): mean sch_management_clarity
matrix manage_scores = e(b)

svy, over(m7saq10): mean sch_management_attraction
matrix manage_scores = manage_scores\e(b)

svy, over(m7saq10): mean sch_selection_deployment
matrix manage_scores = manage_scores\e(b)

svy, over(m7saq10): mean sch_support
matrix manage_scores = manage_scores\e(b)

svy, over(m7saq10): mean principal_evaluation
matrix manage_scores = manage_scores\e(b)
*-- putting all in tables 
mat colname manage_scores= Male Female
mat rowname manage_scores= Clarity_of_Functions Attraction Selection_and_Deployment Support Evaluation
esttab matrix (manage_scores, fmt(2)) using ${save_dir}/analysis_Chad.rtf, compress mlab(none) append ///
	title(School management indicators (by Gender)) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up")



*-------------------------------------------------------
* Repeat all above but for urban_rural instead of Gender
*--------------------------------------------------------
clear matrix
*1. Share of students by urban_rural (for all grades- bar graph)
frame change fourth
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || fourth_grade_assessment__id, weight(g4_stud_weight)
estpost svy: tab urban_rural, percent
matrix define student_ratio = e(b), e(obs)

frame change second
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || ecd_assessment_g2__id, weight(g2_stud_weight)
estpost svy: tab urban_rural, percent col
matrix student_ratio = student_ratio\e(b), e(obs)

frame change first
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || ecd_assessment__id, weight(g1_stud_weight)
estpost svy: tab urban_rural, percent col
matrix student_ratio = student_ratio\e(b), e(obs)

*-- putting all in tables 
mat colname student_ratio= Rural(%) Urban(%) Total Rural(n) Urban(n) N
mat rowname student_ratio= Grade4 Grade2 Grade1
esttab matrix (student_ratio, fmt(0))  using ${save_dir}/analysis_Chad.rtf, compress mlab(none) append ///
	title(Student ratio per grade (by Urban/Rural)) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up")

	
*2. Student attendance by urban_rural (for 4th grade- bar graph)
frame change school
svyset school_code [pw=school_weight], strata($strata) singleunit(scaled) 
svy: mean student_attendance   						 //mean is an estimation already stored in e() -- no need to post it with "post"
*matrix define student_attendance = e(b), e(N)		// added to a matrix that we would keep adding estimates to it to tabulate later

svyset school_code [pw=school_weight], strata($strata) singleunit(scaled) 
encode urban_rural, gen(urban_rural_n)
svy, over(urban_rural_n): mean student_attendance
matrix student_attendance = e(b)
*-- putting all in tables 
mat colname student_attendance= Rural(%) Urban(%)
mat rowname student_attendance= Student_Attendance
esttab matrix (student_attendance, fmt(1))  using ${save_dir}/analysis_Chad.rtf, compress mlab(none) append ///
	title(Student attendance (by Urban/Rural)) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up")


*3. Learning in grade 1, 2, and 4 by urban_rural, both proficiency and knowledge scores (overall and per subject/domain) (table)
// -- Fourth grade
frame change fourth
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || fourth_grade_assessment__id, weight(g4_stud_weight)

encode urban_rural, gen(urban_rural_n)
svy, over(urban_rural_n): mean student_proficient 
matrix student_learning = e(b)

svy, over(urban_rural_n): mean math_student_proficient 
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean literacy_student_proficient
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean student_knowledge 
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean math_student_knowledge 
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean literacy_student_knowledge
matrix student_learning = student_learning\e(b)
*-- putting all in tables 
mat colname student_learning= Rural Urban
mat rowname student_learning= Proficiency(overall) Proficiency(Math) Proficiency(Literacy) Knowledge(overall) Knowledge(Math) knowledge(Literacy) 
esttab matrix (student_learning, fmt(2)) using ${save_dir}/analysis_Chad.rtf, compress mlab(none) append ///
	title(Fourth grade student learning (by Urban/Rural & Domain)) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up")


// -- Second grade
clear matrix
frame change second
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || ecd_assessment_g2__id, weight(g2_stud_weight)

encode urban_rural, gen(urban_rural_n)
svy, over(urban_rural_n): mean ecd2_student_proficiency 
matrix student_learning = e(b)

svy, over(urban_rural_n): mean ecd2_math_student_proficiency
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean ecd2_litera_student_proficiency
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean ecd2_soc_student_proficiency
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean ecd2_exec_student_proficiency
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean ecd2_student_knowledge 
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean ecd2_math_student_knowledge
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean ecd2_literacy_student_knowledge
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean ecd2_soc_student_knowledge
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean ecd2_exec_student_knowledge
matrix student_learning = student_learning\e(b)
*-- putting all in tables 
mat colname student_learning= Rural Urban
mat rowname student_learning= Proficiency(overall) Proficiency(Math) Proficiency(Literacy) ///
	Proficiency(Soc) Proficiency(exec) Knowledge(overall) Knowledge(Math) knowledge(Literacy) knowledge(Soc) knowledge(exec) 
esttab matrix (student_learning, fmt(1)) using ${save_dir}/analysis_Chad.rtf, compress mlab(none) append ///
	title(Second grade student learning (by Urban/Rural & Domain)) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up")

// -- First grade
clear matrix
frame change first
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || ecd_assessment__id, weight(g1_stud_weight)

encode urban_rural, gen(urban_rural_n)
svy, over(urban_rural_n): mean ecd_student_proficiency
matrix student_learning = e(b)

svy, over(urban_rural_n): mean ecd_math_student_proficiency
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean ecd_literacy_student_proficiency
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean ecd_soc_student_proficiency
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean ecd_exec_student_proficiency
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean ecd_student_knowledge
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean ecd_math_student_knowledge
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean ecd_literacy_student_knowledge
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean ecd_soc_student_knowledge
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean ecd_exec_student_knowledge
matrix student_learning = student_learning\e(b)
*-- putting all in tables 
mat colname student_learning= Rural Urban
mat rowname student_learning= Proficiency(overall) Proficiency(Math) Proficiency(Literacy) ///
	Proficiency(Soc) Proficiency(exec) Knowledge(overall) Knowledge(Math) knowledge(Literacy) knowledge(Soc) knowledge(exec)
esttab matrix (student_learning, fmt(1)) using ${save_dir}/analysis_Chad.rtf, compress mlab(none) append ///
	title(First grade student learning (by Urban/Rural & Domain)) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up")

*4. Share of teachers by urban_rural (bar graph staked)
frame change teachers
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || unique_teach_id, weight(teacher_questionnaire_weight)
encode urban_rural, gen(urban_rural_n)

estpost svy: tab urban_rural_n, percent
matrix define teachers_ratio = e(b), e(obs)
*-- putting all in tables 
mat colname teachers_ratio= Rural(%) Urban(%) Total Rural(n) Urban(n) N
mat rowname teachers_ratio= Teachers
esttab matrix (teachers_ratio, fmt(0))  using ${save_dir}/analysis_Chad.rtf, compress mlab(none) append ///
	title(Teachers' by-urban/rural ratio) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up")

*5. Teacher attendance by urban_rural (bar or distribution overlayed )
frame change teachers
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || unique_teach_id, weight(teacher_abs_weight)
estpost svy: tab  sch_presence_rate urban_rural_n, percent col
matrix teachers_presence = e(b)
*-- putting all in tables 
mat colname teachers_presence=  Rural:(No) Rural:(Yes) Rural:Total Urban:(No) Urban:(Yes) Urban:Total Both:(No) Both:(Yes) Both:Total
mat rowname teachers_presence= Teachers-presence(%)
esttab matrix (teachers_presence, transpose fmt(1))  using ${save_dir}/analysis_Chad.rtf, compress mlab(none) append ///
	title(Teachers' presence by urban/rural) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up")


*6. Teacher content knowledge, score and proficiency, overall and per subject (table)
frame change teachers
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || unique_teach_id, weight(teacher_content_weight)

svy, over(urban_rural_n): mean content_proficiency 
matrix content_knowledge = e(b)

svy, over(urban_rural_n): mean math_content_proficiency 
matrix content_knowledge = content_knowledge\e(b)

svy, over(urban_rural_n): mean literacy_content_proficiency
matrix content_knowledge = content_knowledge\e(b)

svy, over(urban_rural_n): mean content_knowledge 
matrix content_knowledge = content_knowledge\e(b)

svy, over(urban_rural_n): mean math_content_knowledge
matrix content_knowledge = content_knowledge\e(b)

svy, over(urban_rural_n): mean literacy_content_knowledge
matrix content_knowledge = content_knowledge\e(b)
*-- putting all in tables 
mat colname content_knowledge= Rural Urban
mat rowname content_knowledge= Proficiency(overall) Proficiency(Math) Proficiency(Literacy) Knowledge(overall) Knowledge(Math) knowledge(Literacy) 
esttab matrix (content_knowledge, fmt(2)) using ${save_dir}/analysis_Chad.rtf, compress mlab(none) append ///
	title(Teachers content knowledge (by Urban/Rural & Domain)) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up")


*7. Teacher pedagogical skills, both proficiency and scores, overall and per domain/areas (table)
frame change teachers
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || unique_teach_id, weight(teacher_pedagogy_weight)

svy, over(urban_rural_n): mean teach_profi 
matrix teach_scores = e(b)

svy, over(urban_rural_n): mean classroom_culture_profi
matrix teach_scores = teach_scores\e(b)

svy, over(urban_rural_n): mean instruction_profi
matrix teach_scores = teach_scores\e(b)

svy, over(urban_rural_n): mean socio_emotional_skills_profi
matrix teach_scores = teach_scores\e(b)

svy, over(urban_rural_n): mean teach_score 
matrix teach_scores = teach_scores\e(b)

svy, over(urban_rural_n): mean classroom_culture
matrix teach_scores = teach_scores\e(b)

svy, over(urban_rural_n): mean instruction
matrix teach_scores = teach_scores\e(b)

svy, over(urban_rural_n): mean socio_emotional_skills
matrix teach_scores = teach_scores\e(b)
*-- putting all in tables 
mat colname teach_scores= Rural Urban
mat rowname teach_scores= Prof(teach) Prof(classroom_culture) Prof(instruction) Prof(socio_emotional) ///
	Score(teach) score(classroom_culture) score(instruction) score(socio_emotional)  
esttab matrix (teach_scores, fmt(2)) using ${save_dir}/analysis_Chad.rtf, compress mlab(none) append ///
	title(Teachers pedagogical skills proficiency & scores (by Urban/Rural & Domain)) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up")

	
*8. Share of principals, by urban/rural (bar stacked)
frame change school
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)

estpost svy: tab urban_rural_n , percent
matrix define principles_ratio = e(b), e(obs)
*-- putting all in tables 
mat colname principles_ratio= Rural(%) Urban(%) Total Rural(n) Urban(n) N
mat rowname principles_ratio= Principles
esttab matrix (principles_ratio, fmt(0))  using ${save_dir}/analysis_Chad.rtf, compress mlab(none) append ///
	title(Principles' by-urban/rural ratio) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up")


*9. School management indicator (by urban_rural of the principals) (bar graph)
frame change school
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)

svy, over(urban_rural_n): mean sch_management_clarity
matrix manage_scores = e(b)

svy, over(urban_rural_n): mean sch_management_attraction
matrix manage_scores = manage_scores\e(b)

svy, over(urban_rural_n): mean sch_selection_deployment
matrix manage_scores = manage_scores\e(b)

svy, over(urban_rural_n): mean sch_support
matrix manage_scores = manage_scores\e(b)

svy, over(urban_rural_n): mean principal_evaluation
matrix manage_scores = manage_scores\e(b)
*-- putting all in tables 
mat colname manage_scores= Rural Urban
mat rowname manage_scores= Clarity_of_Functions Attraction Selection_and_Deployment Support Evaluation
esttab matrix (manage_scores, fmt(2)) using ${save_dir}/analysis_Chad.rtf, compress mlab(none) append ///
	title(School management indicators (by Rural/Urban)) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up")







*End



*[overall]math and literacy proficiency accross all grades (bar chart with y axis 0-100 and x= categorical by grade)

clear all 
*Set working directory on your computer here
gl wrk_dir "C:\Users\wb589124\Downloads\GEPD_Production-Chad\03_GEPD_processed_data\School\Confidential\Cleaned"
gl save_dir "C:\Users\wb589124\Downloads\\requests\\"

// Load data
cap frame create fourth
frame change fourth
use "${wrk_dir}/fourth_grade_Stata"

cap frame create second
frame change second
use "${wrk_dir}/second_grade_Stata"

cap frame create first
frame change first
use "${wrk_dir}/first_grade_Stata"



ssc install xsvmat

frame change fourth
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || fourth_grade_assessment__id, weight(g4_stud_weight)
svy: mean student_knowledge
matrix student_learning_g = e(b)
svy: mean math_student_knowledge
matrix student_learning_g = student_learning_g\e(b)
svy: mean literacy_student_knowledge
matrix student_learning_g = student_learning_g\e(b)

frame change second
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || ecd_assessment_g2__id, weight(g2_stud_weight)
svy: mean ecd2_student_knowledge
matrix student_learning_g = student_learning_g\e(b)
svy: mean ecd2_math_student_knowledge
matrix student_learning_g = student_learning_g\e(b)
svy: mean ecd2_literacy_student_knowledge
matrix student_learning_g = student_learning_g\e(b)

frame change first
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || ecd_assessment__id, weight(g1_stud_weight)
svy: mean ecd_student_knowledge
matrix student_learning_g = student_learning_g\e(b)
svy: mean ecd_math_student_knowledge
matrix student_learning_g = student_learning_g\e(b)
svy: mean ecd_literacy_student_knowledge
matrix student_learning_g = student_learning_g\e(b)


xsvmat, from (student_learning_g) rownames(rname) names(scores) norestore
*renaming
gen long obs_no = _n
replace rname="student knowledge" if obs_no==1
replace rname="math knowledge" if obs_no==2
replace rname="literacy knowledge" if obs_no==3
replace rname="student knowledge" if obs_no==4
replace rname="math knowledge" if obs_no==5
replace rname="literacy knowledge" if obs_no==6
replace rname="student knowledge" if obs_no==7
replace rname="math knowledge" if obs_no==8
replace rname="literacy knowledge" if obs_no==9

*coverting into categorical variable that segements score by grade
recode obs_no (1/3=1 "fourth grade") (4/6=2 "second grade") (7/9=3 "first grade") (.=.), gen(grade)
drop obs_no

encode rname,gen (subject)
recode subject (1=3 "literacy") (2=2 "math") (3=1 "student knowledge (overall)") (.=.), gen(subject_r)
drop rname subject
rename subject_r subject 

graph bar (asis) scores1 , over( subject, sort(subject) label(nolabel)) over( grade, label(angle(45) labsize(small)) ) showyvars asyvar legend(size(small)) ///
title("Average test scores for students (%)", size(medlarge) span) ///
 subtitle("by (subject and grade)", size(small) span) ///
note("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up", size(2.5) span)

graph export "C:\Users\wb589124\Downloads\Graph.emf", as(emf) name("Graph") replace  //saving as enhanced graph


*[by gender]math and literacy proficiency accross all grades (bar chart with y axis 0-100 and x= categorical by grade)

clear all 
*Set working directory on your computer here
gl wrk_dir "C:\Users\wb589124\Downloads\GEPD_Production-Chad\03_GEPD_processed_data\School\Confidential\Cleaned"
gl save_dir "C:\Users\wb589124\Downloads\\requests\\"

// Load data
cap frame create fourth
frame change fourth
use "${wrk_dir}/fourth_grade_Stata"

cap frame create second
frame change second
use "${wrk_dir}/second_grade_Stata"

cap frame create first
frame change first
use "${wrk_dir}/first_grade_Stata"


frame change fourth
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || fourth_grade_assessment__id, weight(g4_stud_weight)
svy, over(m8s1q3): mean student_knowledge
matrix student_learning_g = e(b)
svy, over(m8s1q3): mean math_student_knowledge
matrix student_learning_g = student_learning_g\e(b)
svy, over(m8s1q3): mean literacy_student_knowledge
matrix student_learning_g = student_learning_g\e(b)

frame change second
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || ecd_assessment_g2__id, weight(g2_stud_weight)
svy, over(m10s1q3): mean ecd2_student_knowledge
matrix student_learning_g = student_learning_g\e(b)
svy, over(m10s1q3): mean ecd2_math_student_knowledge
matrix student_learning_g = student_learning_g\e(b)
svy, over(m10s1q3): mean ecd2_literacy_student_knowledge
matrix student_learning_g = student_learning_g\e(b)

frame change first
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || ecd_assessment__id, weight(g1_stud_weight)
svy, over(m6s1q3): mean ecd_student_knowledge
matrix student_learning_g = student_learning_g\e(b)
svy, over(m6s1q3): mean ecd_math_student_knowledge
matrix student_learning_g = student_learning_g\e(b)
svy, over(m6s1q3): mean ecd_literacy_student_knowledge
matrix student_learning_g = student_learning_g\e(b)


xsvmat, from (student_learning_g) rownames(rname) names(scores) norestore
*renaming
gen long obs_no = _n
replace rname="student knowledge" if obs_no==1
replace rname="math knowledge" if obs_no==2
replace rname="literacy knowledge" if obs_no==3
replace rname="student knowledge" if obs_no==4
replace rname="math knowledge" if obs_no==5
replace rname="literacy knowledge" if obs_no==6
replace rname="student knowledge" if obs_no==7
replace rname="math knowledge" if obs_no==8
replace rname="literacy knowledge" if obs_no==9

*coverting into categorical variable that segements score by grade
recode obs_no (1/3=1 "fourth grade") (4/6=2 "second grade") (7/9=3 "first grade") (.=.), gen(grade)
drop obs_no

encode rname,gen (subject)
recode subject (1=3 "literacy") (2=2 "math") (3=1 "student knowledge (overall)") (.=.), gen(subject_r)
drop rname subject
rename subject_r subject 

*reshaping long 
reshape long scores, i(grade subject) j(gender)
recode gender (1=1 "Male") (2=2 "Female") (.=.), gen(gender_r)
drop gender
rename gender_r gender 

*adding labels
lab var grade "Grade"
lab var subject "Subject"
lab var scores "Scores"
lab var gender "Gender"


graph bar (asis) scores , over( subject, sort(subject) label(nolabel)) over( grade, label(angle(45) labsize(small)) ) showyvars asyvar legend(size(small)) by(gender, note("") title("Average test scores for students (%)", size(medlarge))) blabel(bar, format(%9.0f) position(center) color(white)) ///
subtitle(, size(2.5) )

graph export "C:\Users\wb589124\Downloads\Gender.emf", as(emf) name("Graph") replace  //saving as enhanced graph


*[by urban_rural]math and literacy proficiency accross all grades (bar chart with y axis 0-100 and x= categorical by grade)

clear all 
*Set working directory on your computer here
gl wrk_dir "C:\Users\wb589124\Downloads\GEPD_Production-Chad\03_GEPD_processed_data\School\Confidential\Cleaned"
gl save_dir "C:\Users\wb589124\Downloads\\requests\\"

// Load data
cap frame create fourth
frame change fourth
use "${wrk_dir}/fourth_grade_Stata"

cap frame create second
frame change second
use "${wrk_dir}/second_grade_Stata"

cap frame create first
frame change first
use "${wrk_dir}/first_grade_Stata"


frame change fourth
encode urban_rural, gen(urban_rural_n)
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || fourth_grade_assessment__id, weight(g4_stud_weight)
svy, over(urban_rural_n): mean student_knowledge
matrix student_learning_g = e(b)
svy, over(urban_rural_n): mean math_student_knowledge
matrix student_learning_g = student_learning_g\e(b)
svy, over(urban_rural_n): mean literacy_student_knowledge
matrix student_learning_g = student_learning_g\e(b)

frame change second
encode urban_rural, gen(urban_rural_n)
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || ecd_assessment_g2__id, weight(g2_stud_weight)
svy, over(urban_rural_n): mean ecd2_student_knowledge
matrix student_learning_g = student_learning_g\e(b)
svy, over(urban_rural_n): mean ecd2_math_student_knowledge
matrix student_learning_g = student_learning_g\e(b)
svy, over(urban_rural_n): mean ecd2_literacy_student_knowledge
matrix student_learning_g = student_learning_g\e(b)

frame change first
encode urban_rural, gen(urban_rural_n)
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || ecd_assessment__id, weight(g1_stud_weight)
svy, over(urban_rural_n): mean ecd_student_knowledge
matrix student_learning_g = student_learning_g\e(b)
svy, over(urban_rural_n): mean ecd_math_student_knowledge
matrix student_learning_g = student_learning_g\e(b)
svy, over(urban_rural_n): mean ecd_literacy_student_knowledge
matrix student_learning_g = student_learning_g\e(b)


xsvmat, from (student_learning_g) rownames(rname) names(scores) norestore
*renaming
gen long obs_no = _n
replace rname="student knowledge" if obs_no==1
replace rname="math knowledge" if obs_no==2
replace rname="literacy knowledge" if obs_no==3
replace rname="student knowledge" if obs_no==4
replace rname="math knowledge" if obs_no==5
replace rname="literacy knowledge" if obs_no==6
replace rname="student knowledge" if obs_no==7
replace rname="math knowledge" if obs_no==8
replace rname="literacy knowledge" if obs_no==9

*coverting into categorical variable that segements score by grade
recode obs_no (1/3=1 "fourth grade") (4/6=2 "second grade") (7/9=3 "first grade") (.=.), gen(grade)
drop obs_no

encode rname,gen (subject)
recode subject (1=3 "literacy") (2=2 "math") (3=1 "student knowledge (overall)") (.=.), gen(subject_r)
drop rname subject
rename subject_r subject 

*reshaping long 
reshape long scores, i(grade subject) j(urban_rural)
recode urban_rural (1=1 "Rural") (2=2 "Urban") (.=.), gen(rual_r)
drop urban_rural
rename rual_r urban_rural

*adding labels
lab var grade "Grade"
lab var subject "Subject"
lab var scores "Scores"
lab var urban_rural "Urban/Rural"


graph bar (asis) scores , over( subject, sort(subject) label(nolabel)) over( grade, label(angle(45) labsize(small)) ) showyvars asyvar legend(size(small)) by(urban_rural, note("") title("Average test scores for students (%)", size(medlarge))) blabel(bar, format(%9.0f) position(center) color(white)) ///
subtitle(, size(2.5) )

graph export "C:\Users\wb589124\Downloads\Rural.emf", as(emf) name("rural") replace  //saving as enhanced graph