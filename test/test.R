library(envsetup)

# Load the dev configuration
envsetup_config <- config::get(file = "_envsetup.yml")

# Apply the configuration to your R session
rprofile(envsetup_config)

macros
