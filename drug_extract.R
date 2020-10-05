library(purrr)

######################################
setwd("C:/Users/Gyu_H/Dropbox/analysis_ongoing/LAI_HIRA")
AP_list <- read_xlsx("NP_drug_result.xlsx", sheet = 3)
AP_list <- AP_list$drug_name2
######################################
names_vec <- c("연번", "투여", "분류", "성분코드", "제품코드", "제품명")
names(drug_08)
names(drug_09)
names(drug_10)[1:7] <- c("연번", "투여", "분류", "성분코드", "제품코드", "구코드", "제품명")
names(drug_11)[1:6] <- names_vec
names(drug_12)[1:6] <- names_vec
names(drug_13)[1:6] <- names_vec
names(drug_14)[1:6] <- names_vec
names(drug_15)[1:6] <- names_vec
names(drug_16)[1:6] <- names_vec
names(drug_17)[1:6] <- names_vec
names(drug_18)[1:6] <- names_vec
names(drug_19)[1:6] <- names_vec
names(drug_20)[1:6] <- names_vec
#####################################
