library(dplyr)
library(data.table)

variable_table = fread("data/variables.csv")
fn = list.files(path = "data")
for(f in fn){
  assign(gsub(".csv", "", f), fread(file.path("data", f)))
}

extract_data = function(variable_accession_number){

  variable_name = filter(variable_table, variable_accession == variable_accession_number)$variable_name[1]
  datafile_name = paste0(variable_accession_number, "_", variable_name, "_extracted.csv")
  
  var_d_total = data.frame(
    iid = NA,
    variable = NA
  )
  for(dataset_name in c(paste0("phs0000", 1:9), "phs00010", "phs00011", "phs00012")){
    d = get(dataset_name)
    
    if(!is.null(d[[variable_accession_number]])){
      var_d = data.frame(
        iid = d$iid,
        variable = d[[variable_accession_number]]
      )
      var_d_total = full_join(var_d_total, var_d, by = "iid", suffix = c("", paste0("_", dataset_name)))
    }
    
  }
  
  var_d_total = var_d_total |>
    filter(!is.na(iid)) |>
    select(-variable)
  
  names(var_d_total) = gsub(pattern = "variable_", 
                            replacement = paste0(variable_name, "_"), 
                            names(var_d_total))
  
  fwrite(var_d_total, file = file.path("extracted_data", datafile_name))
}

variables_to_extract = unlist(fread("phv_list.txt", header = FALSE))
sapply(variables_to_extract, extract_data)
