# base folder during Sycamore execution
base_folder_sycamore <- "/data/dss/genmabdev"
base_folder_sycamore <- "data"

# base folder in R Studio
base_folder_rstudio <- "/cdrdata"
base_folder_rstudio <- "data"

# Compound Name
compound <- "compound_1"

# Study name
study <- "study_1"

# Deliverable 
deliverable <- "deliverable_1"

# Base folder of deliverable 
base_folder <- paste("Programming",compound,study,deliverable,sep="/") 

# Each deliverable has its own folder names
deliverable_folder_names <-c("adam","adadata","docs","external","macros","output","programs","programs/qc","rand","sdtm","srcdata")

# Create _envsetup.yml file in current directory
dir <- "."
config_path <- file.path(dir, "_envsetup.yml")

yaml_content <- {
    env_name <- "default"
    
    # Create the paths section
    paths_section <- c(sapply(1:length(deliverable_folder_names), function(i) {
        paste0("    ", gsub("/", "_", deliverable_folder_names[i]), ": !expr env_test<-paste0(\"dev_\",Sys.getenv(\"USER\"),\"/\"); if (grepl(env_test,getwd())) {env=paste0(\"_\",env_test)} else if (grepl(\"preprod/\",getwd())) {env=\"_preprod/\"} else { env=\"\" }; if (env != \"\") { dir <- paste0(\"", base_folder, "\",env,\"/",deliverable_folder_names[i],"\") } else { dir <- paste0(\"", base_folder, "\",env,\"/",deliverable_folder_names[i],"\") }; if (Sys.getenv(\"SYCAMORE_TOKEN\")!=\"\") { file.path(\"",base_folder_sycamore,"\", dir) } else { file.path(\"",base_folder_rstudio,"\", dir) }")
    }))

    
    # Combine environment header with paths
    c(paste0(env_name, ":"),
      "  paths:",
      paths_section)
}

# Write a basic config file
file_conn <- file(config_path)

# Print the result
writeLines(
    unlist(yaml_content),file_conn
)

# Close the file connection
close(file_conn)


env_test<-paste0("dev_",Sys.getenv("USER"),"/"); if (grepl(env_test,getwd())) {env=env_test} else if (grepl("preprod/",getwd())) {env="preprod/"} else { env="" }