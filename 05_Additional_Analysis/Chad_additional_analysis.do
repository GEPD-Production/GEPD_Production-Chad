*-------------------------------------------
* GEPD - Chad
* Addressing addtitional analysis requests 
* By: Mohammed ElDesouky - Feb 29th 2024. 

*------------------------------------------


clear all
*Set working directory on your computer here
gl wrk_dir ${clone}/03_GEPD_processed_data/School/Confidential/Cleaned/
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
matrix define student_attendance = e(b)		// added to a matrix that we would keep adding estimates to it to tabulate later

svyset school_code [pw=school_weight], strata($strata) singleunit(scaled) 
svy: mean student_attendance_male
matrix student_attendance = student_attendance\e(b)

svyset school_code [pw=school_weight], strata($strata) singleunit(scaled) 
svy: mean student_attendance_female
matrix student_attendance = student_attendance\e(b)

*-- putting all in tables 
mat colname student_attendance= (%)
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

capture svy, over(m10s1q3): mean ecd2_exec_student_proficiency
matrix student_learning = student_learning\e(b)

svy, over(m10s1q3): mean ecd2_student_knowledge 
matrix student_learning = student_learning\e(b)

svy, over(m10s1q3): mean ecd2_math_student_knowledge
matrix student_learning = student_learning\e(b)

svy, over(m10s1q3): mean ecd2_literacy_student_knowledge
matrix student_learning = student_learning\e(b)

svy, over(m10s1q3): mean ecd2_soc_student_knowledge
matrix student_learning = student_learning\e(b)

capture svy, over(m10s1q3): mean ecd2_exec_student_knowledge
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
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || teachers_id, weight(teacher_questionnaire_weight)
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
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || teachers_id, weight(teacher_abs_weight)
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
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || teachers_id, weight(teacher_content_weight)

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
	
*-------------Teacher content knowledge, overall by grade of teacher (2 & 4)
frame change teachers

matrix content_knowledge_D = J(1, 3, .z)
matrix rownames content_knowledge_D = "Content knowledge score"
matrix colname content_knowledge_D = "Overall" "Grade 4" "Grade 2" 
matlist content_knowledge_D

svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || teachers_id, weight(teacher_content_weight)

svy: mean content_proficiency 
matrix content_knowledge_D[1, 1] = e(b)
	svy, over(grade): mean content_proficiency 
	matrix content_knowledge_D[1, 2] = e(b)[1,2]
	matrix content_knowledge_D[1, 3] = e(b)[1,1]
	
*-------------- putting all in tables 
matlist content_knowledge_D
esttab matrix (content_knowledge_D, fmt(2)) using ${save_dir}/analysis_Chad.rtf, mlab(none) append ///
	title(Teachers content knowledge (by the Grade the teacher teaches)) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up") ///
	modelwidth(12) varwidth(25)


*7. Teacher pedagogical skills, both proficiency and scores, overall and per domain/areas (table)
frame change teachers
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || teachers_id, weight(teacher_pedagogy_weight)

svy, over(m2saq3): mean teach_prof 
matrix teach_scores = e(b)

svy, over(m2saq3): mean classroom_culture_prof
matrix teach_scores = teach_scores\e(b)

svy, over(m2saq3): mean instruction_prof
matrix teach_scores = teach_scores\e(b)

svy, over(m2saq3): mean socio_emotional_skills_prof
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
	
*-------------Teacher pedagogical skills, overall by grade of teacher (2 & 4)
frame change teachers

matrix teach_scores_D = J(1, 3, .z)
matrix rownames teach_scores_D = "Pedagogical skills score"
matrix colname teach_scores_D = "Overall" "Grade 4" "Grade 2" 
matlist teach_scores_D

svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || teachers_id, weight(teacher_pedagogy_weight)

svy: mean teach_prof 
matrix teach_scores_D[1, 1] = e(b)
	svy, over(grade): mean teach_prof
	matrix teach_scores_D[1, 2] = e(b)[1,2]
	matrix teach_scores_D[1, 3] = e(b)[1,1]
	
*-------------- putting all in tables 
matlist teach_scores_D
esttab matrix (teach_scores_D, fmt(2)) using ${save_dir}/analysis_Chad.rtf, mlab(none) append ///
	title(Teachers pedagogical (Teach) skills (by the Grade the teacher teaches)) ///
	addnote("* Sampling weights used in estimation calculation" "* Percent estimates are rounded up") ///
	modelwidth(12) varwidth(25)

	
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

capture svy, over(urban_rural_n): mean ecd2_exec_student_proficiency
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean ecd2_student_knowledge 
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean ecd2_math_student_knowledge
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean ecd2_literacy_student_knowledge
matrix student_learning = student_learning\e(b)

svy, over(urban_rural_n): mean ecd2_soc_student_knowledge
matrix student_learning = student_learning\e(b)

capture svy, over(urban_rural_n): mean ecd2_exec_student_knowledge
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
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || teachers_id, weight(teacher_questionnaire_weight)
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
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || teachers_id, weight(teacher_abs_weight)
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
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || teachers_id, weight(teacher_content_weight)

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
svyset school_code, strata($strata) singleunit(scaled) weight(school_weight)   || teachers_id, weight(teacher_pedagogy_weight)

svy, over(urban_rural_n): mean teach_prof 
matrix teach_scores = e(b)

svy, over(urban_rural_n): mean classroom_culture_prof
matrix teach_scores = teach_scores\e(b)

svy, over(urban_rural_n): mean instruction_prof
matrix teach_scores = teach_scores\e(b)

svy, over(urban_rural_n): mean socio_emotional_skills_prof
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
recode obs_no (1/3=1 "Fourth grade") (4/6=2 "Second grade") (7/9=3 "First grade") (.=.), gen(grade)
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
recode obs_no (1/3=1 "Fourth grade") (4/6=2 "Second grade") (7/9=3 "First grade") (.=.), gen(grade)
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
recode obs_no (1/3=1 "Fourth grade") (4/6=2 "Second grade") (7/9=3 "First grade") (.=.), gen(grade)
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



*based on this thread suggestion: https://www.statalist.org/forums/forum/general-stata-discussion/general/1398867-bar-chart-with-frequencies-of-one-variable-stacked-up-to-100
ssc install	tabplot


*Scores (% correct) for grade 4 by subtask (Math)
clear all
cap frame create fourth
frame change fourth
use "${wrk_dir}/fourth_grade_Stata"

br m8sbq*              
codebook m8sbq* 

replace m8sbq1_number_sense=0 if m8sbq1_number_sense <1
	tab m8sbq1_number_sense
	label define j 0 "Incorrect" 1 "Correct", replace
	label values m8sbq1_number_sense j

keep  m8sbq* interview__key fourth_grade_assessment__id 

local variable m8sbq*
foreach var of local variable {
	sum `var'
}

reshape long m8sbq, i(interview__key fourth_grade_assessment__id) j(Task) string
	
	replace Task="(a) Numbers knowledge" if Task=="1_number_sense"
	replace Task="(b) Order numbers" if Task=="2_number_sense"
	replace Task="(c) 8+7" if Task=="3a_arithmetic"
	replace Task="(d) 28+27" if Task=="3b_arithmetic"
	replace Task="(e) 335+145" if Task=="3c_arithmetic"
	replace Task="(f) 8-5" if Task=="3d_arithmetic"
	replace Task="(g) 57-49" if Task=="3e_arithmetic"
	replace Task="(h) 7x8" if Task=="3f_arithmetic"
	replace Task="(i) 37x40" if Task=="3g_arithmetic"
	replace Task="(j) 214*104" if Task=="3h_arithmetic"
	replace Task="(k) 6/3" if Task=="3i_arithmetic"
	replace Task="(l) 75/5" if Task=="3j_arithmetic"
	replace Task="(m) Smallest answer" if Task=="4_arithmetic"
	replace Task="(n) Oranges in boxes" if Task=="5_word_problem"
	replace Task="(o) Sequence" if Task=="6_sequences"


local opts subtitle(, fcolor(green*0.1)) 
local opts `opts' showval(format(%9.0f) offset(0.3) mlabsize(2)) ytitle("Sub-Task", size(small)) hor yla(, labsize(2.5))
local opts `opts' bar2(bfcolor(green*0.4) blcolor(green))
local opts `opts' bar1(bfcolor(red*0.4) blcolor(red)) scheme(s1color) 


	tabplot Task if m8sbq!=. , by( m8sbq, compact note("Percent (%)", pos(bottom)) title("4th Grade's Math (%) Correct Answers (by Task)", place(e) size(4))) separate(m8sbq) percent(Task) `opts' sort(Task) note("Raw (unweighted) count", size(2)) 

	graph export "C:\Users\wb589124\Downloads\4thmath.emf", as(emf) name("4thmath") replace  //saving as enhanced graph


*Scores (% correct) for grade 4 by subtask (Reading)
clear all
cap frame create fourth
frame change fourth
use "${wrk_dir}/fourth_grade_Stata"

br m8saq*          
codebook m8saq*

local list m8saq4_id m8saq2_id m8saq3_id 
foreach var of local list {
	tab `var'
	replace `var'=0 if `var' <1
	tab `var'
}


label define j 0 "Incorrect" 1 "Correct", replace 
foreach var of varlist m8saq* {
	sum `var'
	label values `var' j
	sum `var'
	}	



keep  m8saq* interview__key fourth_grade_assessment__id 

local variable m8saq*
foreach var of local variable {
	sum `var'
}

reshape long m8saq, i(interview__key fourth_grade_assessment__id) j(Task) string
	
	replace Task="(a) Letter idf" if Task=="2_id"
	replace Task="(b) Words idf" if Task=="3_id"
	replace Task="(c) Pictures correctly named" if Task=="4_id"
	replace Task="(d) Where they meet" if Task=="5_story"
	replace Task="(e) What animal sleep" if Task=="6_story"
	replace Task="(f) Correct word" if Task=="7_word_choice"
	replace Task="(g) Giraffe - talk" if Task=="7a_gir"
	replace Task="(h) Giraffe - listen" if Task=="7b_gir"
	replace Task="(i) Giraffe - leaves" if Task=="7c_gir"
	replace Task="(j) Giraffe - afriad" if Task=="7d_gir"
	replace Task="(k) Giraffe - Stopped" if Task=="7e_gir"
	replace Task="(l) Giraffe - huddle" if Task=="7f_gir"
	replace Task="(m) Giraffe - words" if Task=="7g_gir"
	replace Task="(n) Giraffe - roar" if Task=="7h_gir"
	replace Task="(o) Giraffe - climb who" if Task=="7i_gir"
	replace Task="(p) Giraffe - climb where" if Task=="7j_gir"
	replace Task="(q) Giraffe - climb why" if Task=="7k_gir"
	

local opts subtitle(, fcolor(green*0.1)) 
local opts `opts' showval(format(%9.0f) offset(0.4) mlabsize(2)) ytitle("Sub-Task", size(small)) hor yla(, labsize(2.3))
local opts `opts' bar2(bfcolor(green*0.4) blcolor(green))
local opts `opts' bar1(bfcolor(red*0.4) blcolor(red)) scheme(s1color) 


	tabplot Task if m8saq!=. , by( m8saq, compact note("Percent (%)", pos(bottom)) title("4th Grade's Literacy (%) Correct Answers (by Task)", place(e) size(4))) separate(m8saq) percent(Task) `opts' sort(Task) note("Raw (unweighted) count", size(2)) 


	graph export "C:\Users\wb589124\Downloads\4thlit.emf", as(emf) name("4thlit") replace  //saving as enhanced graph

*Scores (% correct) for grade 2 by subtask (math)
clear all
cap frame create second
frame change second
use "${wrk_dir}/second_grade_Stata"

br *counting *produce_set *number_ident *number_compare *simple_add pasec_7 pasec_9 pasec_101 pasec_102 pasec_103 pasec_104 pasec_105 pasec_106          
codebook *counting *produce_set *number_ident *number_compare *simple_add pasec_7 pasec_9 pasec_101 pasec_102 pasec_103 pasec_104 pasec_105 pasec_106



local list m10s2q8_counting  
foreach var of local list {
	tab `var'
	replace `var'=0 if `var' <1
	tab `var'
}


label define j 0 "Incorrect" 1 "Correct", replace 
foreach var of varlist *counting *produce_set *number_ident *number_compare *simple_add pasec_7 pasec_9 pasec_101 pasec_102 pasec_103 pasec_104 pasec_105 pasec_106 {
	sum `var'
	label values `var' j
	sum `var'
	}	


keep  *counting *produce_set *number_ident *number_compare *simple_add pasec_7 pasec_9 pasec_101 pasec_102 pasec_103 pasec_104 pasec_105 pasec_106 interview__key ecd_assessment_g2__id 

local variable *counting *produce_set *number_ident *number_compare *simple_add pasec_7 pasec_9 pasec_101 pasec_102 pasec_103 pasec_104 pasec_105 pasec_106
foreach var of local variable {
	sum `var'
}

foreach var of varlist pasec* {
	rename `var' m10s2q_`var'
}

reshape long m10s2q, i(interview__key ecd_assessment_g2__id) j(Task) string
	
	replace Task="(a) Verbal Counting" if Task=="8_counting"
	replace Task="(b) Producing A Set" if Task=="9a_produce_set"
	replace Task="(c) Producing A Set" if Task=="9b_produce_set"
	replace Task="(d) Num Identification (2)" if Task=="10a_number_ident"
	replace Task="(e) Num Identification (7)" if Task=="10b_number_ident"
	replace Task="(f) Num Identification (10)" if Task=="10c_number_ident"
	replace Task="(g) Num Identification (8)" if Task=="10d_number_ident"
	replace Task="(h) Num Identification (5)" if Task=="10e_number_ident"
	replace Task="(i) Num Identification (13)" if Task=="10f_number_ident"
	replace Task="(j) Num Identification (17)" if Task=="10g_number_ident"
	replace Task="(k) Num Identification (12)" if Task=="10h_number_ident"
	replace Task="(l) Num Identification (14)" if Task=="10i_number_ident"
	replace Task="(m) Num Identification (20)" if Task=="10j_number_ident"
	replace Task="(n) Num Comparison (greater 3 or 5)" if Task=="11a_number_compare"
	replace Task="(o) Num Comparison (greater 8 or 6)" if Task=="11b_number_compare"
	replace Task="(p) Num Comparison (smaller 4 or 7)" if Task=="11c_number_compare"
	replace Task="(q) Addition (2 + 1)" if Task=="12a_simple_add"
	replace Task="(r) Addition (3 + 2)" if Task=="12b_simple_add"
	replace Task="(s) Addition (5 + 2)" if Task=="12c_simple_add"
	replace Task="(t) Read number" if Task=="_pasec_7"
	replace Task="(u) (33 + 29)" if Task=="_pasec_9"
	replace Task="(v) (8 + 5)" if Task=="_pasec_101"
	replace Task="(w) (13 - 7)" if Task=="_pasec_102"
	replace Task="(x) (14 + 23)" if Task=="_pasec_103"
	replace Task="(y) (33 + 29)" if Task=="_pasec_104"
	replace Task="(z) (34 - 11)" if Task=="_pasec_105"
	replace Task="(za) (50 - 18)" if Task=="_pasec_106"



local opts subtitle(, fcolor(green*0.1)) 
local opts `opts' showval(format(%9.0f) offset(0.6) mlabsize(2)) ytitle("Sub-Task", size(small)) hor yla(, labsize(2))
local opts `opts' bar2(bfcolor(green*0.4) blcolor(green))
local opts `opts' bar1(bfcolor(red*0.4) blcolor(red)) scheme(s1color) 


	tabplot Task if m10s2q!=. , by( m10s2q, compact note("Percent (%)", pos(bottom)) title("2nd Grade's Math (%) Correct Answers (by Task)", place(e) size(4))) separate(m10s2q) percent(Task) `opts' sort(Task) note("Raw (unweighted) count", size(2)) 

	graph export "C:\Users\wb589124\Downloads\2ndmath.emf", as(emf) name("2ndmath") replace  //saving as enhanced graph
	

*Scores (% correct) for grade 2 by subtask (reading)
clear all
cap frame create second
frame change second
use "${wrk_dir}/second_grade_Stata"

br *vocabn *comprehension *letters *words *sentence m10s2q6a_nm_writing *_print pasec_1 pasec_2 pasec_3 pasec_4 pasec_5 pasec_61 pasec_62 pasec_63         
codebook *vocabn *comprehension *letters *words *sentence m10s2q6a_nm_writing *_print pasec_1 pasec_2 pasec_3 pasec_4 pasec_5 pasec_61 pasec_62 pasec_63


local list m10s2q1_vocabn m10s2q1b_vocabn 
foreach var of local list {
	tab `var'
	replace `var'=0 if `var' <1
	tab `var'
}


label define j 0 "Incorrect" 1 "Correct", replace 
foreach var of varlist *vocabn *comprehension *letters *words *sentence m10s2q6a_nm_writing *_print pasec_1 pasec_2 pasec_3 pasec_4 pasec_5 pasec_61 pasec_62 pasec_63 {
	sum `var'
	label values `var' j
	sum `var'
	}	


keep  *vocabn *comprehension *letters *words *sentence m10s2q6a_nm_writing *_print pasec_1 pasec_2 pasec_3 pasec_4 pasec_5 pasec_61 pasec_62 pasec_63 interview__key ecd_assessment_g2__id

local variable *vocabn *comprehension *letters *words *sentence m10s2q6a_nm_writing *_print pasec_1 pasec_2 pasec_3 pasec_4 pasec_5 pasec_61 pasec_62 pasec_63
foreach var of local variable {
	sum `var'
}


foreach var of varlist pasec* {
	rename `var' m10s2q_`var'
}

reshape long m10s2q, i(interview__key ecd_assessment_g2__id) j(Task) string
	
	replace Task="(a) Count - many things" if Task=="1_vocabn"
	replace Task="(b) Count - animals names" if Task=="1b_vocabn"
	replace Task="(c) Story" if Task=="5a_comprehension"
	replace Task="(d) Story" if Task=="5b_comprehension"
	replace Task="(e) Story" if Task=="5c_comprehension"
	replace Task="(f) Story" if Task=="5d_comprehension"
	replace Task="(g) Story" if Task=="5e_comprehension"
	replace Task="(h) Name of the letter (B)" if Task=="2a_letters"
	replace Task="(i) Name of the letter (S)" if Task=="2b_letters"
	replace Task="(j) Name of the letter (A)" if Task=="2c_letters"
	replace Task="(k) Name of the letter (T)" if Task=="2d_letters"
	replace Task="(l) Name of the letter (M)" if Task=="2e_letters"
	replace Task="(m) Name of the letter (U)" if Task=="2f_letters"
	replace Task="(n) Name of the letter (D)" if Task=="2g_letters"
	replace Task="(o) Name of the letter (V)" if Task=="2h_letters"
	replace Task="(p) Read a word (cat)" if Task=="3a_words"
	replace Task="(q) Read a word (dog)" if Task=="3b_words"
	replace Task="(r) Read a word (house)" if Task=="3c_words"
	replace Task="(s) Read a sentence (run)" if Task=="4a_sentence"
	replace Task="(t) Read a sentence (kick)" if Task=="4b_sentence"
	replace Task="(u) Read a sentence (sleeps)" if Task=="4c_sentence"
	replace Task="(v) Name writing" if Task=="6a_nm_writing"
	replace Task="(w) Print aware (open a book)" if Task=="7a_print"
	replace Task="(x) Print aware (Where to read)" if Task=="7b_print"
	replace Task="(y) Print aware (Where continue)" if Task=="7c_print"
	replace Task="(z) Show foot" if Task=="_pasec_1"
	replace Task="(za) Show image" if Task=="_pasec_2"
	replace Task="(zb) show picture goes with a word" if Task=="_pasec_3"
	replace Task="(zc) Read letters" if Task=="_pasec_4"
	replace Task="(zd) Read words" if Task=="_pasec_5"
	replace Task="(ze) Party where" if Task=="_pasec_61"
	replace Task="(zf) Teachers where" if Task=="_pasec_62"
	replace Task="(zg) Who dance" if Task=="_pasec_63"


local opts subtitle(, fcolor(green*0.1)) 
local opts `opts' showval( format(%9.0f) offset(0.7) mlabsize(2)) ytitle("Sub-Task", size(small)) hor yla(, labsize(2))
local opts `opts' bar2(bfcolor(green*0.4) blcolor(green))
local opts `opts' bar1(bfcolor(red*0.4) blcolor(red)) scheme(s1color) 


	tabplot Task if m10s2q!=. , by( m10s2q, compact note("Percent (%)", pos(bottom)) title("2nd Grade's Literacy (%) Correct Answers (by Task)", place(e) size(4))) separate(m10s2q) percent(Task) `opts' sort(Task) note("Raw (unweighted) count", size(2)) 

	graph export "C:\Users\wb589124\Downloads\1stliteracy.emf", as(emf) name("2ndliteracy") replace  //saving 


*Scores (% correct) for grade 1 by subtask (math)
clear all
cap frame create first
frame change first
use "${wrk_dir}/first_grade_Stata"

br *counting *produce_set *number_ident *number_compare *simple_add              
codebook *counting *produce_set *number_ident *number_compare *simple_add



local list m6s2q8_counting 
foreach var of local list {
	tab `var'
	replace `var'=0 if `var' <1
	tab `var'
}


label define j 0 "Incorrect" 1 "Correct", replace 
foreach var of varlist *counting *produce_set *number_ident *number_compare *simple_add {
	sum `var'
	label values `var' j
	sum `var'
	}	


keep  *counting *produce_set *number_ident *number_compare *simple_add interview__key ecd_assessment__id 

local variable *counting *produce_set *number_ident *number_compare *simple_add
foreach var of local variable {
	sum `var'
}

reshape long m6s2q, i(interview__key ecd_assessment__id) j(Task) string
	
	replace Task="(a) Verbal Counting" if Task=="8_counting"
	replace Task="(b) Producing A Set" if Task=="9a_produce_set"
	replace Task="(c) Producing A Set" if Task=="9b_produce_set"
	replace Task="(d) Num Identification (2)" if Task=="10a_number_ident"
	replace Task="(e) Num Identification (7)" if Task=="10b_number_ident"
	replace Task="(f) Num Identification (10)" if Task=="10c_number_ident"
	replace Task="(g) Num Identification (8)" if Task=="10d_number_ident"
	replace Task="(h) Num Identification (5)" if Task=="10e_number_ident"
	replace Task="(i) Num Identification (13)" if Task=="10f_number_ident"
	replace Task="(j) Num Identification (17)" if Task=="10g_number_ident"
	replace Task="(k) Num Identification (12)" if Task=="10h_number_ident"
	replace Task="(l) Num Identification (14)" if Task=="10i_number_ident"
	replace Task="(m) Num Identification (20)" if Task=="10j_number_ident"
	replace Task="(n) Num Comparison (greater 3 or 5)" if Task=="11a_number_compare"
	replace Task="(o) Num Comparison (greater 8 or 6)" if Task=="11b_number_compare"
	replace Task="(p) Num Comparison (smaller 4 or 7)" if Task=="11c_number_compare"
	replace Task="(q) Addition (2 + 1)" if Task=="12a_simple_add"
	replace Task="(r) Addition (3 + 2)" if Task=="12b_simple_add"
	replace Task="(s) Addition (5 + 2)" if Task=="12c_simple_add"


local opts subtitle(, fcolor(green*0.1)) 
local opts `opts' showval(format(%9.0f) offset(0.4) mlabsize(2)) ytitle("Sub-Task", size(small)) hor yla(, labsize(2.5))
local opts `opts' bar2(bfcolor(green*0.4) blcolor(green))
local opts `opts' bar1(bfcolor(red*0.4) blcolor(red)) scheme(s1color) 


	tabplot Task if m6s2q!=. , by( m6s2q, compact note("Percent (%)", pos(bottom)) title("1st Grade's Math (%) Correct Answers (by Task)", place(e) size(4))) separate(m6s2q) percent(Task) `opts' sort(Task) note("Raw (unweighted) count", size(2)) 

	graph export "C:\Users\wb589124\Downloads\1stmath.emf", as(emf) name("1stmath") replace  //saving as enhanced graph



*Scores (% correct) for grade 1 by subtask (reading)
clear all
cap frame create first
frame change first
use "${wrk_dir}/first_grade_Stata"

br *vocabn *comprehension *letters *words *sentence m6s2q6a_nm_writing *_print          
codebook *vocabn *comprehension *letters *words *sentence m6s2q6a_nm_writing *_print



local list m6s2q1b_vocabn m6s2q1_vocabn
foreach var of local list {
	tab `var'
	replace `var'=0 if `var' <1
	tab `var'
}


label define j 0 "Incorrect" 1 "Correct", replace 
foreach var of varlist *vocabn *comprehension *letters *words *sentence m6s2q6a_nm_writing *_print {
	sum `var'
	label values `var' j
	sum `var'
	}	


keep  *vocabn *comprehension *letters *words *sentence m6s2q6a_nm_writing *_print interview__key ecd_assessment__id 

local variable *vocabn *comprehension *letters *words *sentence m6s2q6a_nm_writing *_print
foreach var of local variable {
	sum `var'
}

reshape long m6s2q, i(interview__key ecd_assessment__id) j(Task) string
	
	replace Task="(a) Count - many things" if Task=="1_vocabn"
	replace Task="(b) Count - animals names" if Task=="1b_vocabn"
	replace Task="(c) Story" if Task=="5a_comprehension"
	replace Task="(d) Story" if Task=="5b_comprehension"
	replace Task="(e) Story" if Task=="5c_comprehension"
	replace Task="(f) Story" if Task=="5d_comprehension"
	replace Task="(g) Story" if Task=="5e_comprehension"
	replace Task="(h) Name of the letter (B)" if Task=="2a_letters"
	replace Task="(i) Name of the letter (S)" if Task=="2b_letters"
	replace Task="(j) Name of the letter (A)" if Task=="2c_letters"
	replace Task="(k) Name of the letter (T)" if Task=="2d_letters"
	replace Task="(l) Name of the letter (M)" if Task=="2e_letters"
	replace Task="(m) Name of the letter (U)" if Task=="2f_letters"
	replace Task="(n) Name of the letter (D)" if Task=="2g_letters"
	replace Task="(o) Name of the letter (V)" if Task=="2h_letters"
	replace Task="(b) Read a word (cat)" if Task=="3a_words"
	replace Task="(q) Read a word (dog)" if Task=="3b_words"
	replace Task="(r) Read a word (house)" if Task=="3c_words"
	replace Task="(s) Read a sentence (run)" if Task=="4a_sentence"
	replace Task="(t) Read a sentence (kick)" if Task=="4b_sentence"
	replace Task="(u) Read a sentence (sleeps)" if Task=="4c_sentence"
	replace Task="(v) Name writing" if Task=="6a_nm_writing"
	replace Task="(w) Print aware (open a book)" if Task=="7a_print"
	replace Task="(x) Print aware (Where to read)" if Task=="7b_print"
	replace Task="(y) Print aware (Where continue)" if Task=="7c_print"


local opts subtitle(, fcolor(green*0.1)) 
local opts `opts' showval(format(%9.0f) offset(0.6) mlabsize(2)) ytitle("Sub-Task", size(small)) hor yla(, labsize(2))
local opts `opts' bar2(bfcolor(green*0.4) blcolor(green))
local opts `opts' bar1(bfcolor(red*0.4) blcolor(red)) scheme(s1color) 


	tabplot Task if m6s2q!=. , by( m6s2q, compact note("Percent (%)", pos(bottom)) title("1st Grade's Literacy (%) Correct Answers (by Task)", place(e) size(4))) separate(m6s2q) percent(Task) `opts' sort(Task) note("Raw (unweighted) count", size(2)) 

	graph export "C:\Users\wb589124\Downloads\1stliteracy.emf", as(emf) name("1stliteracy") replace  //saving as enhanced graph



*End




/* to improve form maryam 
ppt reference slide (Chad): https://worldbankgroup-my.sharepoint.com/:p:/r/personal/molina_worldbank_org/_layouts/15/doc2.aspx?sourcedoc=%7B965E8B25-C6F5-47C1-A506-67C20436F855%7D&file=Education_Dashboard_Chad.pptx&action=edit&mobileredirect=true&CID=c2efa402-10fd-da04-ec63-3e22e9f70455


comments: 
Slide 51 – confirm why Total N is 259 when males and females are 255 each.
Slide 52, 53, 59 – put values of bar above bar, also add stacked bars for overall values, capitalize fourth, second, first
Slide 54-58, 61-63 – introduce a space between Proficiency and (Overall), Male and (%), Male and (N), etc., remove _ from labels, use n or N for sample size consistently, and let's use consistent capitalization across labels
Slide 52 – remove "by(subject and grade)" from heading
If headings are automatically populated, please adjust spellings for "graphical", "representation", "disaggregation", "characteristics" etc.