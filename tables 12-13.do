**********************
* paper
* 12-7-2021
**********************



*** open merged data ****
use "\\Client\C$\Users\anahi\Desktop\men and women merged 11-3.dta"



********************* create control variables  *******************

*generate age variable for both men and women
generate age = v012 if female == 1
replace age = mv012 if female == 0



*generate place of residence variable for both men and women
	*categorical variable: capital/large city, small city, town, & countryside
generate large_city = 1 if female == 0 & mv026 == 0
replace large_city = 1 if female == 1 & v026 == 0
replace large_city = 0 if mv026 == 1 | mv026 == 2 | mv026 == 3 | v026 == 1 | v026 == 2 | v026 == 3

generate small_city = 1 if mv026 == 1 | v026 == 1
replace small_city = 0 if  mv026 == 0 | mv026 == 2 | mv026 == 3 | v026 == 0 | v026 == 2 | v026 == 3

generate town = 1 if  mv026 == 2 | v026 == 2
replace town = 0 if mv026 == 0 | mv026 == 1 | mv026 == 3 | v026 == 0 | v026 == 1 | v026 == 3

generate countryside = 1 if mv026 == 3 | v026 == 3
replace countryside = 0 if mv026 == 1 | mv026 == 2 | mv026 == 0 | v026 == 0 | v026 == 1 | v026 == 2


*generate new total children ever born variable for both men and women 
generate total_kids = v201 if female == 1
replace total_kids = mv201 if female == 0


*generate highest year of education variable for both men and women
generate years_educ = v133 if female == 1
replace years_educ = mv133 if female == 0


*generate sex of household head variable for both men and women
	* male marked as 1 and female marked as 2
replace mv151 = 0 if mv151 == 1
replace mv151 = 1 if mv151 == 2
replace v151 = 0 if v151 == 1
replace v151 = 1 if v151 == 2

generate hh_sex = v151 if female == 1
replace hh_sex = mv151 if female == 0



*generate total number of household members variable for both men and women
generate total_num_hh = v136 if female == 1
replace total_num_hh = mv136 if female == 0


*generate number of sons at home variable for both men and women
generate sons_home = mv202 if female == 0
replace sons_home = v202 if female == 1


*generate number of daughters at home variable for both men and women
generate daughters_home = mv203 if female == 0
replace daughters_home = v203 if female == 1
	
	
**** create interaction term with mv111 and v111 that measures if respndent uses radio every day

	* first create radio variable for both men and women 
gen radio = 1 if mv111 == 1
replace radio = 1 if v111== 1
replace radio = 0 if mv111 == 0
replace radio = 0 if v111 == 0
*replace 5 missing observations with average
replace radio = 0.784 if radio == .



************************************ Table 1 ********************************







** column 1 values
sum total_kid large_city small_city town countryside years_educ total_num_hh hh_sex age  sons_home daughters_home radio


** column 2 values
sum total_kid if female == 1
sum large_city if female == 1
sum small_city if female == 1
sum town if female == 1
sum countryside if female == 1
sum years_educ if female == 1
sum total_num_hh if female == 1
sum hh_sex if female == 1
sum age if female == 1
sum sons_home if female == 1
sum daughters_home if female == 1
sum radio if female == 1





**column 3 values
sum total_kid if female == 0
sum large_city if female == 0
sum small_city if female == 0
sum town if female == 0
sum countryside if female == 0
sum years_educ if female == 0
sum total_num_hh if female == 0
sum hh_sex if female == 0
sum age if female == 0
sum sons_home if female == 0
sum daughters_home if female == 0
sum radio if female == 0




**column 4
reg total_kid female
reg large_city female
reg small_city female
reg town female
reg countryside female
reg years_educ female
reg total_num_hh female
reg hh_sex female
reg age female
reg sons_home female
reg daughters_home female
reg radio female






************ create left side variable ***************


generate lc_bd = s215d_15 if num_kids == 15 & female ==1
replace lc_bd = s215d_14 if num_kids == 14 & female ==1
replace lc_bd = s215d_13 if num_kids == 13 & female ==1
replace lc_bd = s215d_12 if num_kids == 12 & female ==1
replace lc_bd = s215d_11 if num_kids == 11 & female ==1
replace lc_bd = s215d_10 if num_kids == 10 & female ==1
replace lc_bd = s215d_09 if num_kids == 9 & female ==1
replace lc_bd = s215d_08 if num_kids == 8 & female ==1
replace lc_bd = s215d_07 if num_kids == 7 & female ==1
replace lc_bd = s215d_06 if num_kids == 6 & female ==1
replace lc_bd = s215d_05 if num_kids == 5 & female ==1
replace lc_bd = s215d_04 if num_kids == 4 & female ==1 
replace lc_bd = s215d_03 if num_kids == 3 & female ==1
replace lc_bd = s215d_02 if num_kids == 2 & female ==1
replace lc_bd = s215d_01 if num_kids == 1 & female ==1
replace lc_bd = sm210am if female == 0


generate dk_lc_bd = 1 if lc_bd > 31 & lc_bd != .
replace dk_lc_bd = 0 if lc_bd <= 31





********************************* Table 2 **************************************



***** Regresion w/out controls *****


reg dk_lc_bd female


* mean of dependent variable in the control group
sum(dk_lc_bd) if female == 0



***** regression w controls *****
reg dk_lc_bd female total_kid large_city small_city town years_educ total_num_hh hh_sex age sons_home daughters_home radio




********************************* Table 3 **************************************




gen interaction = (radio * female)


* column 1

reg dk_lc_bd female radio interaction

* column 2
	
reg dk_lc_bd female radio total_kid large_city small_city town years_educ total_num_hh hh_sex age sons_home daughters_home interaction











