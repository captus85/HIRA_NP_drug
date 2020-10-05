grouping_df <- hira_df %>%
  mutate(grouping = str_extract(내용, "[a-z]+")) %>%
  select(주성분코드, grouping)

grouping_res <- left_join(complete_df, grouping_df)


grouping_res <- grouping_res %>%
  unite(grouping, c("grouping", "투여경로"), remove = FALSE)

grouping_res$grouping_index <- NULL

grouping_index <-grouping_res %>%
  group_by(grouping) %>%
  summarise(n=n()) %>%
  select(grouping) %>% 
  mutate(number = 1:27)

grouping_res <- left_join(grouping_res, grouping_index) %>%
  select(투여경로, 약효분류, 제품코드, 제품명, 업체명, 규격, 단위,
             상한금액, 전일, 주성분코드, grouping_index = number)


write.csv(grouping_index, "grouping_index.csv")
write.csv(grouping_res, "grouping_res.csv")
