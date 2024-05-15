clear all
use "C:\Users\wb469649\WBG\HEDGE Files - HEDGE Documents\GEPD-Confidential\CNT\TCD\TCD_2023_GEPD\TCD_2023_GEPD_v01_RAW\Data\raw\School\EPDash.dta"


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

*save
save "C:\Users\wb469649\WBG\HEDGE Files - HEDGE Documents\GEPD-Confidential\CNT\TCD\TCD_2023_GEPD\TCD_2023_GEPD_v01_RAW\Data\raw\School\EPDash_cleaned.dta", replace
