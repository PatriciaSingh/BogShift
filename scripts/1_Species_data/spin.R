
knitr::spin("01_gbif_data_retrieval.R", format = "Rmd", knit = FALSE)

getwd()
setwd("scripts/1_Species_data")
library("markdown")

system("quarto render Occurance_data_from_GBIF.Rmd --to html")

install.packages("xfun")
install.packages(c("knitr", "rmarkdown"))
packageVersion("xfun")   # should be ≥ "0.52"
