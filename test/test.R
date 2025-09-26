
library(envsetup)

# Load the configuration
envsetup_config <- config::get(file = "_envsetup2.yml",config = "preprod")

# Apply the configuration to your R session
rprofile(envsetup_config)


paste(adam,"test.rds",sep="/")
