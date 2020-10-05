library(tidyverse)
library(readxl)
rm(list=ls()); gc()

setwd("C:/Users/Gyu_H/Dropbox/analysis_ongoing/LAI_HIRA/drug_list")
file.list <- list.files(pattern = ".xlsx")
file.list2 <- list.files(pattern = ".xls")

for (i in 1:length(file.list)) {
  assign(file.list[i], read_xlsx(file.list[i]))
}

for (i in 1:length(file.list2)) {
  assign(file.list2[i], read_xls(file.list2[i]))
}

name_list <- paste0("drug_", str_sub(ls()[1:13], 3,4))

old <- ls()[1:13]

rm(file.list)
rm(file.list2)
rm(i)

for (i in 1:13){
  assign(name_list[i], get(old[i]))
}

rm(list=ls()[1:13])

################################