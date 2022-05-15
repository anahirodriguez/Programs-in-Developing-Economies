**********************
* cleaning data final
* 11-08-2021
**********************



****** open master data
use "\\Client\C$\Users\anahi\Desktop\NC_1998_DHS_10202021_013_168689\NCIR31DT - women\NCIR31FL.DTA"



generate female = 1


** fix womens variables


foreach x in bidx_ bord_ b0_ b1_ b2_ b3_ b4_ b5_ b6_ b7_ b8_ b9_ b10_ b11_ b12_ b13_ b14_ b15_ {
    local i = 10
	while `i' < 21 {
	    rename `x'`i' `x'0`i'
		local i = `i' + 1
	}
}



egen i = group(v001 v002 v003)


reshape long bidx_0 bord_0 b0_0 b1_0 b2_0 b3_0 b4_0 b5_0 b6_0 b7_0 b8_0 b9_0 b10_0 b11_0 b12_0 b13_0 b14_0 b15_0, i(i) j(kidnum)




*bidx_0 is birth column number
*bord_0 is birth order month
*b0_0 is child is twin 
	*should I drop all twins and triplets?
*b1_0 is month of birth
*b2_0 is year of birthday
*.....


drop if b0_0 == .
bys v001 v002 v003: gen num_kids=_N
gen lastkid=1 if bord==num_kids
drop if lastkid != 1







**** need to save data as a new file and then use this as the new master file
****** use newly saved data since laptop takes forever to do all above steps later
use  "\\Client\C$\Users\anahi\Desktop\temp - women reshape 11-3.dta"





***** merge this new data with mens


**** open mens data


use "\\Client\C$\Users\anahi\Desktop\NC_1998_DHS_10202021_013_168689\NCMR31DT - men\NCMR31FL.DTA"


*** create merging variable with same name as in womens

* mv034_1 is line number of wives
*mv003 is respondents line number
generate v003 = mv003

generate v001 = mv001
generate v002 = mv002
generate caseid = mcaseid


**** drop men who do not have wives, those whose wives live elsewhere, and those who have a number of wives different from 1
**v003 is line number of wives
**mv035 is number of wives 
*mv034_1 is line number of wives with 0 == wife not in household
drop if mv035 != 1
drop if mv034_1 == 0



** save data and use it as master data for next merge
use "\\Client\C$\Users\anahi\Desktop\NCMR31FL - w v variables generated _ wiveless dropped 11-3.dta"




***merge men and women data

append using "\\Client\C$\Users\anahi\Desktop\temp - women reshape 11-3.dta"




replace female = 0 if female == .
egen t = min(female), by(v001 v002)
drop if t!= 0

***** save data and use as new data set for analysis