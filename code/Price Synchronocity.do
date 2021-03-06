cls
clear
import delimited "G:\Economics\Finance(Prof.Heidari-Aghajanzadeh)\Data\Price Synchronocity\priceSynchronocity.csv", encoding(UTF-8) 


cd "D:\Dropbox\Finance(Prof.Heidari-Aghajanzadeh)\Project\Price-Synchronocity\report"

drop if year == 1399


gen SYNCH = log(rsquared / (1-rsquared))

label variable SYNCH "SYNCH"

replace size = log(size)
label variable size "Size"
replace liquidity = log(liquidity)
label variable liquidity "Liquidity"

gen Excess = (cr - cfr)/cr
gen ExcessDiff = cr - cfr

gen ExcessDummy = 0
replace ExcessDummy = 1 if ExcessDiff>0

egen med = median(Excess)

gen ExcessHigh = 0 
replace ExcessHigh = 1 if Excess>med

drop med

eststo v0 : quietly regress SYNCH cfr volatility liquidity size i.group_id i.yea ,cluster(name)
estadd loc IndustryDummy "Yes" , replace
estadd loc YearDummy "Yes" , replace

eststo v1 : quietly regress SYNCH Excess cfr size i.group_id i.year ,cluster(name)
estadd loc IndustryDummy "Yes" , replace
estadd loc YearDummy "Yes" , replace

eststo v2 : quietly regress SYNCH Excess cfr volatility liquidity size i.group_id i.year ,cluster(name)
estadd loc IndustryDummy "Yes" , replace
estadd loc YearDummy "Yes" , replace

eststo v3 : quietly regress SYNCH ExcessDiff cfr volatility liquidity size i.group_id i.year ,cluster(name)
estadd loc IndustryDummy "Yes" , replace
estadd loc YearDummy "Yes" , replace

eststo v4 : quietly regress SYNCH ExcessDummy cfr volatility liquidity size i.group_id i.year ,cluster(name)
estadd loc IndustryDummy "Yes" , replace
estadd loc YearDummy "Yes" , replace


eststo v5 : quietly regress SYNCH ExcessHigh cfr volatility liquidity size i.group_id i.year ,cluster(name)
estadd loc IndustryDummy "Yes" , replace
estadd loc YearDummy "Yes" , replace


esttab v0 v1 v2 v3 v4 v5, s(IndustryDummy YearDummy N  r2 ,  lab("Industry Dummy" "Year Dummy" "Observations""$ R^2 $")) brackets order(Excess  ExcessDiff ExcessDummy ExcessHigh cfr) keep(ExcessDummy  ExcessHigh ExcessDiff Excess cfr volatility liquidity size) nomtitle mgroups("Synchronicity"   , pattern(1 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}) ) ,using synchronicityt4.tex ,replace
 
 
xtset id year
  
 eststo v0 : quietly xi: asreg SYNCH volatility liquidity size i.group_id   , fmb newey(4)
estadd loc IndustryDummy "Yes" , replace
estadd loc YearDummy "No" , replace

 eststo v1 : quietly xi: asreg SYNCH Excess cfr  size i.group_id  , fmb newey(4)
estadd loc IndustryDummy "Yes" , replace
estadd loc YearDummy "No" , replace

  eststo v2 : quietly xi: asreg SYNCH Excess cfr volatility liquidity size i.group_id  , fmb newey(4)
estadd loc IndustryDummy "Yes" , replace
estadd loc YearDummy "No" , replace

eststo v3 : quietly xi: asreg SYNCH ExcessDiff cfr volatility liquidity size i.group_id , fmb newey(4)
estadd loc IndustryDummy "Yes" , replace
estadd loc YearDummy "No" , replace

eststo v4 : quietly xi: asreg SYNCH ExcessDummy cfr volatility liquidity size i.group_id  , fmb newey(4)
estadd loc IndustryDummy "Yes" , replace
estadd loc YearDummy "No" , replace


eststo v5 : quietly xi: asreg SYNCH ExcessHigh cfr volatility liquidity size i.group_id  , fmb newey(4)
estadd loc IndustryDummy "Yes" , replace
estadd loc YearDummy "No" , replace


esttab v0 v1 v2 v3 v4 v5, brackets s(IndustryDummy YearDummy N  r2 ,  lab("Industry Dummy" "Year Dummy" "Observations""$ R^2 $")) order(Excess  ExcessDiff ExcessDummy ExcessHigh cfr) keep(ExcessDummy  ExcessHigh ExcessDiff Excess cfr volatility liquidity size)  nomtitle mgroups("Synchronicity"   , pattern(1 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}) ) ,using synchronicityt5.tex ,replace

help esttab
 