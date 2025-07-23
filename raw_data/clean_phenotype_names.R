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

variable_names = tibble(
  variable_name = c(
    names(d1),
    names(d2),
    names(d3),
    names(d4),
    names(d5),
    names(d6),
    names(d7),
    names(pulm),
    names(sleep),
    names(hvr)
  ),
  variable_from = c(
    rep("Aug 2015", length(names(d1))),
    rep("Dec 2015", length(names(d2))),
    rep("Dec 2016 HVR TS", length(names(d3))),
    rep("Sequenced DNA", length(names(d4))),
    rep("dec2017_temp", length(names(d5))),
    rep("Mar-May 2019", length(names(d6))),
    rep("23July2020_Database", length(names(d7))),
    rep("Pulmonary", length(names(pulm))),
    rep("sleep", length(names(sleep))),
    rep("hvr", length(names(hvr)))
  )
) %>%
  distinct(variable_name, .keep_all = TRUE)

write_xlsx(variable_names, path = "variable_names.xlsx")






