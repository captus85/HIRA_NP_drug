drug_to_test <- function(x) {
x1 <- x %>%
  nest(data = -성분코드)
x1 <- x1 %>%
  mutate(drug_name = map_chr(data, ~.$`제품코드`[1]))

x1$drug_name2 <- str_squish(x1$drug_name)
x1$drug_name2 <- str_remove(x1$drug_name2, "\\(.*\\)")
x1$drug_name2 <- if_else(grepl("[0-9]", x1$drug_name2), 
                              str_sub(x1$drug_name2, 1, 
                                      str_locate(x1$drug_name2, "\\d")[,1] - 1),
                              x1$drug_name2)

x1$drug_name2 <- str_trim(x1$drug_name2, side = "right")
x1$drug_name <- tolower(x1$drug_name)
x1$drug_name2 <- tolower(x1$drug_name2)

x1$drug_dose <- str_extract(x1$drug_name, "\\d+\\.*\\d*")
x1$drug_dose2 <- gsub("[^0-9.]", "",  x1$drug_name) # "[^[:digit:].]"


for(i in 1:length(AP_list)) {
  x1 <- x1 %>%
    mutate(!!AP_list[i] := grepl(AP_list[i], drug_name2))
}

x1 <- x1 %>%
  mutate(sum = rowSums(.[,7:(6+length(AP_list))]))

x2 <- x1 %>%
  filter(sum != 0) %>%
  select(성분코드, drug_name, drug_name2, drug_dose, drug_dose2)

return(x2)
}

drug_vec <- c("drug_08", "drug_09", "drug_10", "drug_11", "drug_12", 
  "drug_13", "drug_14", "drug_15", "drug_16", "drug_17", "drug_18", 
  "drug_19", "drug_20")

for (i in 1:13) {
  assign(paste0("result_", i+7), drug_to_test(get(drug_vec[i])))
}



result_df <- rbind(result_8, result_9, result_10,result_11,result_12,result_13,result_14,
      result_15,result_16,result_17,result_18,result_19,result_20)


##Create "drug_complete.csv"
# drug_complete2 <- result_df %>% select(성분코드) %>% unique
# write.csv(drug_complete2, "drug_complete2.csv")
