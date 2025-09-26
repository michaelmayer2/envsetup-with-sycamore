# base folder during Sycamore execution
base_folder_sycamore <- "/data/dss/genmabdev"

# base folder in R Studio
base_folder_rstudio <- "/cdrdata"

# Compound Name
compound <- "compound_1"

# Study name
study <- "study_1"

# Deliverable 
deliverable <- "deliverable_1"

# Base folder of deliverable 
base_folder <- paste("Programming",compound,study,deliverable,sep="/") 

# There is three envs, dev, preprod and production (empty string)
envs <- c("dev","preprod","")

# Each deliverable has its own folder names
deliverable_folder_names <-c("adam","adadata","docs","external","macros","output","programs","rand","sdtm","srcdata")

# Finally, let's put everything together
final_folder_names <- lapply(envs, function(env) {
  paste(base_folder, if(env == "dev") { paste(env,Sys.getenv("USER"),sep="_") } else { env }, deliverable_folder_names, sep="/")
})

# Create temporary directory for demonstration
dir <- "."
config_path <- file.path(dir, "_envsetup.yml")

yaml_content <- lapply(1:3, function(env_idx) {
    env_name <- if(envs[env_idx] == "") "prod" else envs[env_idx]
    
    # Create the paths section
    paths_section <- sapply(1:length(deliverable_folder_names), function(i) {
        paste0("    ", deliverable_folder_names[i], ": !expr dir <- \"", final_folder_names[[env_idx]][i], "\"; if (Sys.getenv(\"SYCAMORE_TOKEN\")!=\"\") { file.path(\"",base_folder_sycamore,"\", dir) } else { file.path(\"",base_folder_rstudio,"\", dir) }")
    })
    
    # Combine environment header with paths
    c(paste0(env_name, ":"),
      "  paths:",
      paths_section)
})

# Write a basic config file
file_conn <- file(config_path)

# Print the result
writeLines(
    c(
        "default:",
        "  paths:",
    unlist(yaml_content)
    ),
    file_conn
)

# Close the file connection
close(file_conn)
