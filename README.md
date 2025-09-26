# Environment setup in Sycamore

## Introduction

In Sycamore, there is three environments: dev, preprod and prod. 

The folder structure allows to have a structure like Compound / Study / Deliverable where for each Deliverable a pre-defined of subfolders is generated. 

Once analysts start working on their Deliverables, they write code that needs to run in each of the three environments, and in the two lower environments the code also needs to run within R Studio. 

There is a number of additional complexities involved:

* The mount point of the repository is different between R Studio and Sycamore 
* The dev environments folder name is also coded with the username, while for preprod only "preprod" is used and for prod there is no additional suffix.

Those complexities can be solved by observing that within Sycamore the execution environment contains an environment variable `SYCAMORE_TOKEN`.

A problem that remains to be solved is the automatic detection which environment the code runs. This needs to currently be set manually, but there surely must be a way to auto-detect this. If that was possible, a sample script could be written and automatically run before each code within the deliverable. 

## How to use

When a new deliverable is provisioned, the attached code `new.R` must be copied into the root folder of the same deliverable.

Every user upon first working on this delivery, must execute this code under R Studio, ensuring that the work direcory is set to the folder of the deliverable. This code will create a file called `_newenv.yml` that contains all the relevant metadata.

Every piece of R code the user writes, needs to contain the following lines

```{r}
library(envsetup)

# Load the configuration
envsetup_config <- config::get(file = "_envsetup.yml", config = "dev")

# Apply the configuration to your R session
rprofile(envsetup_config)
```

where `config` must be set to the respective environment, e.g. `dev`, `preprod` or `prod`. Note that the reference to "dev" will automatically resolve the `dev_$USERNAME` folders. 

If the user now wants to access some dataset (e.g. `my_adam_data.rds`) in the `adam` folder of the study, they would simply use `paste(adam,"my_adam_data.rds",sep="/")` and this would automatically resolve to the respective folder in each environment and also automatically reflect the change between running in R Studio and within Sycamore batch execution. 