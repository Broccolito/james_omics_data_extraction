library(dplyr)
library(readxl)
library(writexl)

d1 = read_excel(path = "CDP_Databases_TS _FV.xlsx", sheet = "Aug 2015")
d2 = read_excel(path = "CDP_Databases_TS _FV.xlsx", sheet = "Dec 2015")
d3 = read_excel(path = "CDP_Databases_TS _FV.xlsx", sheet = "Dec 2016 HVR TS")
d4 = read_excel(path = "CDP_Databases_TS _FV.xlsx", sheet = "Sequenced DNA")
d5 = read_excel(path = "CDP_Databases_TS _FV.xlsx", sheet = "dec2017_temp")
d6 = read_excel(path = "CDP_Databases_TS _FV.xlsx", sheet = "Mar-May 2019")
d7 = read_xlsx(path = "CDP_database_from_Francisco_PLF_23July2020_Database w-dates.xlsx")
pulm = read_xlsx(path = "Pulmonary Functions Tests CdP.xlsx")
sleep = read_xlsx("cdp sleep and hvr data_final_abbreviated.xlsx")
hvr = read.csv("2015_aug_dec_2016_dec.csv")

d1 = d1[,c(1,2,7,8,9)]
d2 = d2[,c(1,2,10,11,12)]
d3 = d3[,c(1,2,9,10,12)]
d4 = d4[,c(2,3,9,10,12)]
d5 = d5[,c(1)]
d6 = d6[,c(2,1,4,5,7)]
d7 = d7[,c(3,2,5,6)]
pulm = pulm[,c(3,2,4,5)]
sleep = sleep[,c(2,3,4)]
hvr = hvr[,c(6,5,15,16,17)]

names(d1) = c("initial", "id", "first_name", "last_name", "sex")
names(d2) = c("initial", "id", "first_name", "last_name", "sex")
names(d3) = c("initial", "id", "first_name", "last_name", "sex")
names(d4) = c("initial", "id", "first_name", "last_name", "sex")
names(d5) = c("initial")
d5 = d5 %>%
  mutate(id = NA) %>%
  mutate(first_name = NA) %>%
  mutate(last_name = NA) %>%
  mutate(sex = "M")
names(d6) = c("initial", "id", "first_name", "last_name", "sex")
names(d7) = c("initial", "id", "first_name", "last_name")
d7 = d7 %>%
  mutate(sex = "M")
names(pulm) = c("initial", "id", "first_name", "last_name")
pulm = pulm %>%
  mutate(sex = "M")
names(sleep) = c("initial", "id", "sex")
sleep = sleep %>%
  mutate(first_name = NA) %>%
  mutate(last_name = NA) %>%
  select(initial, id, first_name, last_name, sex)
names(hvr) = c("initial", "id", "first_name", "last_name", "sex")

d1 = d1 %>%
  mutate(study = "Aug 2015")
d2 = d2 %>%
  mutate(study = "Dec 2015")
d3 = d3 %>%
  mutate(study = "Dec 2016 HVR TS")
d4 = d4 %>%
  mutate(study = "Sequenced DNA")
d5 = d5 %>%
  mutate(study = "dec2017_temp")
d6 = d6 %>%
  mutate(study = "Mar-May 2019")
d7 = d7 %>%
  mutate(study = "23July2020_Database")
pulm = pulm %>%
  mutate(study = "pulm")
sleep = sleep %>%
  mutate(study = "sleep")
hvr = hvr %>%
  mutate(study = "hvr")

sample_names = rbind.data.frame(d1, d2, d3, d4, d5, d6, d7, pulm, sleep, hvr)

sample_names = sample_names %>%
  arrange(initial, id)

write_xlsx(sample_names, path = "sample_names.xlsx")






