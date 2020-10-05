##
drug_08 <- drug_08 %>%
  select(투여경로=투여, 약효분류=분류, 주성분코드=성분코드, 제품코드, 제품명,
             업체명=업소명, 규격, 단위, 상한금액, 전일)

drug_09 <- drug_09 %>%
  select(투여경로=투여, 약효분류=분류, 주성분코드=성분코드, 제품코드, 제품명,
             업체명=업소명, 규격, 단위, 상한금액, 전일)

drug_10 <- drug_10 %>%
  select(투여경로=투여, 약효분류=분류, 주성분코드, 제품코드=신코드, 제품명,
             업체명, 규격, 단위, 상한금액, 전일)


drug_11 <- drug_11 %>%
  select(투여경로=투여, 약효분류=분류, 주성분코드, 제품코드, 제품명,
             업체명, 규격, 단위, 상한금액, 전일)

drug_12 <- drug_12 %>%
  select(투여경로=투여, 약효분류=분류, 주성분코드, 제품코드, 제품명,
             업체명, 규격, 단위, 상한금액, 전일)


drug_13 <- drug_13 %>%
  select(투여경로=투여, 약효분류=분류, 주성분코드, 제품코드, 제품명,
             업체명, 규격, 단위, 상한금액, 전일)

drug_14 <- drug_14 %>%
  select(투여경로=투여, 약효분류=분류, 주성분코드, 제품코드, 제품명,
             업체명, 규격, 단위, 상한금액, 전일)

drug_15 <- drug_15 %>%
  select(투여경로=투여, 약효분류=분류, 주성분코드, 제품코드=신코드, 제품명,
             업체명, 규격, 단위, 상한금액, 전일)

drug_16 <- drug_16 %>%
  select(투여경로=투여, 약효분류=분류, 주성분코드, 제품코드, 제품명,
             업체명, 규격, 단위, 상한금액, 전일)

drug_17 <- drug_17 %>%
  select(투여경로=투여, 약효분류=분류, 주성분코드, 제품코드, 제품명,
             업체명, 규격, 단위, 상한금액, 전일)

drug_18 <- drug_18 %>%
  select(투여경로=투여, 약효분류=분류, 주성분코드, 제품코드, 제품명,
             업체명, 규격, 단위, 상한금액, 전일)

drug_19 <- drug_19 %>%
  select(투여경로=투여, 약효분류=분류, 주성분코드, 제품코드, 제품명,
             업체명, 규격, 단위, 상한금액, 전일)

drug_20 <- drug_20 %>%
  select(투여경로=투여, 약효분류=식약분류, 주성분코드, 제품코드, 제품명,
             업체명, 규격, 단위, 상한금액, 전일)


drug_08$규격 <- as.character(drug_08$규격)
drug_09$규격 <- as.character(drug_09$규격)
drug_10$규격 <- as.character(drug_10$규격)
drug_11$규격 <- as.character(drug_11$규격)
drug_12$규격 <- as.character(drug_12$규격)
drug_13$규격 <- as.character(drug_13$규격)
drug_14$규격 <- as.character(drug_14$규격)

drug_df <- bind_rows(drug_10, drug_11, drug_12, drug_13, 
                     drug_14, drug_15, drug_16, drug_17,
                     drug_18, drug_19, drug_20, drug_08, drug_09)
# drug_name_vec <- c("oral", "efficacy", "ingredient", "code", "name", "factory", "dose", "unit",
#   "money", "junil")
# names(drug_08) <- drug_name_vec
# names(drug_09) <- drug_name_vec
# names(drug_10) <- drug_name_vec
# names(drug_11) <- drug_name_vec
# names(drug_12) <- drug_name_vec
# names(drug_13) <- drug_name_vec
# names(drug_15) <- drug_name_vec
# names(drug_16) <- drug_name_vec
# names(drug_17) <- drug_name_vec
# names(drug_18) <- drug_name_vec
# names(drug_19) <- drug_name_vec
# names(drug_20) <- drug_name_vec

drug_df <- drug_df %>% 
  group_by(주성분코드) %>%
  nest()

setwd("C:/Users/Gyu_H/Dropbox/analysis_ongoing/LAI_HIRA/data")
AP_list <- read.csv("drug_complete.csv")
AP_list <- AP_list$x
AP_list <- AP_list[!AP_list=="183501ATB"]

drug_df <- drug_df %>%
  filter(주성분코드 %in% AP_list)

filter_fx <- function(x){
  df1 <- x[-which(is.na(x$업체명)),]
  df1 <- df1 %>% group_by(제품코드, 상한금액) %>%
    slice(1)
  return(df1)
}



filter_df <- map(drug_df$data, ~filter_fx(.x))

for(i in 1:nrow(drug_df)) {
  filter_df[[i]]$주성분코드 <- drug_df$주성분코드[i]
}



index_df <- map(drug_df$data, ~.x[which(is.na(.x$업체명)),][1,])

for(i in 1:nrow(drug_df)) {
  index_df[[i]]$주성분코드 <- drug_df$주성분코드[i]
}


complete_df <- map2(index_df, filter_df, ~bind_rows(.x, .y))

complete_df <- do.call(rbind.data.frame, complete_df)



write.csv(complete_df, "hira_list_df.csv")

hira_df <- complete_df %>%
  nest(-주성분코드)


hira_df <- hira_df %>%
  mutate(내용 = map_chr(data, ~.$`제품코드`[1])) %>%
  mutate(투여경로 = map_chr(data, ~.$`투여경로`[1])) %>%
  mutate(약효분류 = map_dbl(data, ~.$`약효분류`[1])) %>%
  mutate(제품수 = map_int(data, ~nrow(.))-1)
            
hira_df <- hira_df %>%
  select(투여경로, 약효분류, 주성분코드, 내용, 제품수)

write.csv(hira_df, "hira_df.csv")
