library(dplyr)
library(data.table)
library(readxl)
library(writexl)

sample_names = read_excel(path = "sample_names_annotated_Jane.xlsx")
variable_names = read_excel(path = "variable_names_Yu_20230214.xlsx")

variable_names = variable_names %>%
  filter(!is.na(variable_accession)) %>%
  select(variable_name:variable_description)

sample_names = sample_names %>%
  mutate(iid = paste0("CDP", sprintf("%06d", iid))) %>%
  select(initial:iid)

# write_xlsx(sample_names, path = "sample_names_test.xlsx")

cdp_database1 = read_excel("CDP_Databases_TS _FV.xlsx", sheet = "Aug 2015")
cdp_database2 = read_excel("CDP_Databases_TS _FV.xlsx", sheet = "Dec 2015")
cdp_database3 = read_excel("CDP_Databases_TS _FV.xlsx", sheet = "Dec 2016 HVR TS")
cdp_database4 = read_excel("CDP_Databases_TS _FV.xlsx", sheet = "Sequenced DNA")
cdp_database5 = read_excel("CDP_Databases_TS _FV.xlsx", sheet = "dec2017_temp")
cdp_database6 = read_excel("CDP_Databases_TS _FV.xlsx", sheet = "Mar-May 2019")
cdp_database7 = read_excel("CDP_database_from_Francisco_PLF_23July2020_Database w-dates.xlsx")
pulm = read_xlsx(path = "Pulmonary Functions Tests CdP.xlsx")
sleep = read_xlsx("cdp sleep and hvr data_final_abbreviated.xlsx")
hvr = read.csv("2015_aug_dec_2016_dec.csv")
genotype = read.csv("genotype_master_jane.csv")
epas1_genotype = read.csv("epas1_genotype.csv")

change_phenotype_names = function(database){
  database = database[,names(database) %in% variable_names$variable_name]
  names_db = tibble(
    variable_name = names(database)
  ) %>% left_join(variable_names, by = "variable_name")
  names(database) = names_db[["variable_accession"]]
  return(database)
}

cdp_database1 = change_phenotype_names(cdp_database1)
cdp_database2 = change_phenotype_names(cdp_database2)
cdp_database3 = change_phenotype_names(cdp_database3)
cdp_database4 = change_phenotype_names(cdp_database4)
cdp_database5 = change_phenotype_names(cdp_database5)
cdp_database6 = change_phenotype_names(cdp_database6)
cdp_database7 = change_phenotype_names(cdp_database7)
pulm = change_phenotype_names(pulm)
sleep = change_phenotype_names(sleep)
hvr = change_phenotype_names(hvr)
genotype = change_phenotype_names(genotype)
epas1_genotype = change_phenotype_names(epas1_genotype)

change_sample_names = function(database){
  if("phv00002" %in% names(database)){
    names_db = tibble(
      initial = database[["phv00001"]],
      first_name = database[["phv00002"]],
      last_name = database[["phv00003"]]
    ) %>%
      mutate(unique_id = paste(initial, first_name, last_name, sep = "_"))
    
    sample_names = sample_names %>%
      mutate(unique_id = paste(initial, first_name, last_name, sep = "_")) %>%
      select(unique_id, iid) %>%
      distinct(unique_id, .keep_all = TRUE)
    
    iid = left_join(names_db, sample_names, by = "unique_id") %>%
      select(iid)
    database = cbind.data.frame(iid, database)
    
  }else{
    sample_names = sample_names %>%
      distinct(initial, .keep_all = TRUE)
    names_db = tibble(
      initial = database[["phv00001"]]
    ) %>%
      left_join(sample_names, by = "initial") %>%
      select(iid)
    database = cbind.data.frame(names_db, database)
  }
  
  return(database)
}

cdp_database1 = change_sample_names(cdp_database1)
cdp_database2 = change_sample_names(cdp_database2)
cdp_database3 = change_sample_names(cdp_database3)
cdp_database4 = change_sample_names(cdp_database4)
cdp_database5 = change_sample_names(cdp_database5)
cdp_database6 = change_sample_names(cdp_database6)
cdp_database7 = change_sample_names(cdp_database7)
pulm = change_sample_names(pulm)
sleep = change_sample_names(sleep)
hvr = change_sample_names(hvr)
genotype = change_sample_names(genotype)
epas1_genotype = change_sample_names(epas1_genotype)

# Fill in HVR missing
hvr_missing = hvr[is.na(hvr$iid),]
names(hvr_missing)[4] = "first_name"
names(hvr_missing)[5] = "last_name"
hvr_missing = hvr_missing[,-1]
hvr_missing = change_sample_names(hvr_missing)
names(hvr_missing)[4] = "phv00002"
names(hvr_missing)[5] = "phv00003"
names(hvr)[184] = "phv00186.1"

hvr = rbind.data.frame(
  hvr[!is.na(hvr$iid),],
  hvr_missing
) %>%
  select(-phv00186) %>%
  rename("phv00186" = "phv00186.1")

# Fill in genotype missing
genotype_missing = genotype %>%
  filter(is.na(iid)) %>%
  left_join(mutate(read.csv("genotype_master.csv"), phv00001 = genotyping_initials), by = "phv00001") %>%
  select(-iid, -genotyping_initials)

suppressWarnings({
  sample_names_byid = filter(sample_names, !is.na(id)) %>%
    mutate(id = sapply(id, function(x){
      x = gsub(pattern = "CDP", replacement = "", x)
      x = gsub(pattern = "_", replacement = "", x)
      x = gsub(pattern = " ", replacement = "", x)
      x = as.numeric(x)
      x
    })) %>%
    filter(!is.na(id)) %>%
    distinct(id, .keep_all = TRUE) %>%
    select(id, iid)
})

genotype_missing = left_join(genotype_missing, sample_names_byid, by = "id") %>%
  select(-id) %>%
  select(iid, everything()) %>%
  filter(iid != "CDP    NA") %>%
  select(iid, phv00001, phg00001:phg00013)

genotype = genotype %>%
  filter(!is.na(iid)) %>%
  rbind.data.frame(genotype_missing) %>%
  filter(iid != "CDP    NA")

# Fill in EPAS1 genotype missing
epas1_genotype_missing = epas1_genotype %>%
  filter(is.na(iid)) %>%
  left_join(mutate(read.csv("epas1_genotype.csv"), phv00001 = initials),
            by = "phv00001", relationship = "many-to-many") %>%
  select(-iid, -initials)

epas1_genotype_missing = left_join(epas1_genotype_missing, sample_names_byid, 
                                   by = "id", relationship = "many-to-many") %>%
  select(-id) %>%
  select(iid, everything()) %>%
  filter(iid != "CDP    NA") %>%
  select(iid, phv00001, phv00002, phv00003, phg00014) %>%
  distinct(iid, .keep_all = TRUE)

epas1_genotype = epas1_genotype %>%
  filter(!is.na(iid)) %>%
  rbind.data.frame(epas1_genotype_missing) %>%
  filter(iid != "CDP    NA")


phs00001 = cdp_database1
phs00002 = cdp_database2
phs00003 = cdp_database3
phs00004 = cdp_database4
phs00005 = cdp_database5
phs00006 = cdp_database6
phs00007 = cdp_database7
phs00008 = pulm
phs00009 = sleep
phs00010 = hvr
phs00011 = genotype
phs00012 = epas1_genotype

studies = tibble(
  study_accession = c("phs00001", "phs00002", "phs00003", "phs00004", "phs00005", "phs00006",
                      "phs00007","phs00008", "phs00009", "phs00010", "phs00011", "phs00012"),
  study_name = c("Trip Aug 2015", "Trip Dec 2015", "Trip Dec 2016", "Sequenced DNA", 
                 "Trip Dec 2017", "Trip Mar May 2019", "Villafuerte in-house",
                 "Pulmonary Function", "Sleep", "HVR", "SNP Genotypes 2022", "EPAS1 Genotype 2021")
)

write.csv(phs00001, file = "../data/phs00001.csv", quote = TRUE, row.names = FALSE)
write.csv(phs00002, file = "../data/phs00002.csv", quote = TRUE, row.names = FALSE)
write.csv(phs00003, file = "../data/phs00003.csv", quote = TRUE, row.names = FALSE)
write.csv(phs00004, file = "../data/phs00004.csv", quote = TRUE, row.names = FALSE)
write.csv(phs00005, file = "../data/phs00005.csv", quote = TRUE, row.names = FALSE)
write.csv(phs00006, file = "../data/phs00006.csv", quote = TRUE, row.names = FALSE)
write.csv(phs00007, file = "../data/phs00007.csv", quote = TRUE, row.names = FALSE)
write.csv(phs00008, file = "../data/phs00008.csv", quote = TRUE, row.names = FALSE)
write.csv(phs00009, file = "../data/phs00009.csv", quote = TRUE, row.names = FALSE)
write.csv(phs00010, file = "../data/phs00010.csv", quote = TRUE, row.names = FALSE)
write.csv(phs00011, file = "../data/phs00011.csv", quote = TRUE, row.names = FALSE)
write.csv(phs00012, file = "../data/phs00012.csv", quote = TRUE, row.names = FALSE)
write.csv(variable_names, file = "../data/variables.csv", quote = TRUE, row.names = FALSE)
write.csv(studies, file = "../data/studies.csv", quote = TRUE, row.names = FALSE)


