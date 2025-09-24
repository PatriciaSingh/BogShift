library(rgbif)
library(dplyr)

# number of GBIF occurrences including:
# Museum specimen, 
# Fossil record, 
# Human or machine observation, 
# Environmental DNA record

occ_count()
# 3507561056

# number of GBIF observations:
# recorded in the field by person, sensor, camera trap
# iNaturalist photo records, 
# birdwatchers’ checklists,
# vegetation plot surveys

occ_count(basisOfRecord='OBSERVATION')
# 16762618

# number of occurrences reported for country. Check https://countrycode.org/ for country codes
occ_count(country='CZ') # Czech Republic
# 5506352
occ_count(country='SK') # Slovakia
# 2117087

# number of observations reported for country:
occ_count(country='CZ',basisOfRecord='OBSERVATION')
# 50
occ_count(country='SK',basisOfRecord='OBSERVATION')
# 10

# As example, I picked the Rusty Bog-moss (Sphagnum fuscum) for today, a typical bog species in Europe. Its conservation status is least concerned (https://www.iucnredlist.org/species/87567639/87841272).
# Check for synonyms
name_suggest(q='Sphagnum fuscum', rank='species')
# Records returned [1] 
# No. unique hierarchies [0] 
# Args [q=Sphagnum fuscum, limit=100, rank=species, fields1=key,
#       fields2=canonicalName, fields3=rank] 
# # A tibble: 1 × 3
# key canonicalName   rank   
# <int> <chr>           <chr>  
#   1 2669215 Sphagnum fuscum SPECIES

# Check number of records - here filtered to those with coordinate information
occ_search(scientificName = "Sphagnum fuscum", hasCoordinate=T, limit = 10)
# Records found [22157] 
# Records returned [10] 
# No. unique hierarchies [1] 
# No. media records [10] 
# No. facets [0] 
# Args [hasCoordinate=TRUE, occurrenceStatus=PRESENT, limit=10, offset=0,
#       scientificName=Sphagnum fuscum, fields=all] 
# # A tibble: 10 × 112
# key       scientificName decimalLatitude decimalLongitude issues datasetKey
# <chr>     <chr>                    <dbl>            <dbl> <chr>  <chr>     
#   1 50636356… Sphagnum fusc…            44.2           -68.2  "cdc,… 50c9509d-…
#  2 50709663… Sphagnum fusc…            60.8            24.4  "cdc"  df12ca07-…
#  3 50840401… Sphagnum fusc…            59.7            10.8  "cdc,… b124e1e0-…
# 4 50989832… Sphagnum fusc…            59.8            16.0  ""     38b4c89f-…
# 5 51046472… Sphagnum fusc…            47.7           -91.4  "cdc,… 50c9509d-…
#  6 51074778… Sphagnum fusc…            59.7            10.8  "cdc,… b124e1e0-…
# 7 51075087… Sphagnum fusc…            59.7            10.8  "cdc,… b124e1e0-…
#  8 51081990… Sphagnum fusc…            46.8            12.1  "cdc,… 50c9509d-…
# 9 51086158… Sphagnum fusc…            56.0             9.44 "cdc,… 963a6b96-…
# 10 51086176… Sphagnum fusc…            56.0             9.44 "cdc,… 963a6b96-…
# # ℹ 106 more variables: publishingOrgKey <chr>, installationKey <chr>,
# #   hostingOrganizationKey <chr>, publishingCountry <chr>, protocol <chr>,
# #   lastCrawled <chr>, lastParsed <chr>, crawlId <int>, projectId <chr>,
# #   basisOfRecord <chr>, occurrenceStatus <chr>, taxonKey <int>,
# #   kingdomKey <int>, phylumKey <int>, classKey <int>, orderKey <int>,
# #   familyKey <int>, genusKey <int>, speciesKey <int>,
# #   acceptedTaxonKey <int>, acceptedScientificName <chr>, kingdom <chr>, …
# # ℹ Use `colnames()` to see all variable names


# One of the most interesting items from the outputs is the “Records found” 
# at the very top of the output. Please be aware that occ_search() will not 
# allow to download more than 100’000 records. If the GBIF data contain more,
# then you can set additional filters (e.g. set time period with argument 
# year or geographic extent with arguments decimalLatitude and 
# decimalLongitude) or split the area into spatial tiles 
# (by setting geographic extent) and download the tiles separately.

?occ_search

occ_search(scientificName = "Sphagnum fuscum", hasCoordinate=T, basisOfRecord='HUMAN_OBSERVATION', limit = 10)

# Records found [14084] 
# Records returned [10] 
# No. unique hierarchies [1] 
# No. media records [10] 
# No. facets [0] 
# Args [hasCoordinate=TRUE, occurrenceStatus=PRESENT, limit=10, offset=0,
#       scientificName=Sphagnum fuscum, basisOfRecord=HUMAN_OBSERVATION,
#       fields=all] 
# # A tibble: 10 × 112
# key       scientificName decimalLatitude decimalLongitude issues datasetKey
# <chr>     <chr>                    <dbl>            <dbl> <chr>  <chr>     
#   1 50636356… Sphagnum fusc…            44.2           -68.2  "cdc,… 50c9509d-…
#  2 50709663… Sphagnum fusc…            60.8            24.4  "cdc"  df12ca07-…
#  3 50840401… Sphagnum fusc…            59.7            10.8  "cdc,… b124e1e0-…
# 4 50989832… Sphagnum fusc…            59.8            16.0  ""     38b4c89f-…
# 5 51046472… Sphagnum fusc…            47.7           -91.4  "cdc,… 50c9509d-…
#  6 51074778… Sphagnum fusc…            59.7            10.8  "cdc,… b124e1e0-…
# 7 51075087… Sphagnum fusc…            59.7            10.8  "cdc,… b124e1e0-…
#  8 51081990… Sphagnum fusc…            46.8            12.1  "cdc,… 50c9509d-…
# 9 51086158… Sphagnum fusc…            56.0             9.44 "cdc,… 963a6b96-…
# 10 51086176… Sphagnum fusc…            56.0             9.44 "cdc,… 963a6b96-…
# # ℹ 106 more variables: publishingOrgKey <chr>, installationKey <chr>,
# #   hostingOrganizationKey <chr>, publishingCountry <chr>, protocol <chr>,
# #   lastCrawled <chr>, lastParsed <chr>, crawlId <int>, projectId <chr>,
# #   basisOfRecord <chr>, occurrenceStatus <chr>, taxonKey <int>,
# #   kingdomKey <int>, phylumKey <int>, classKey <int>, orderKey <int>,
# #   familyKey <int>, genusKey <int>, speciesKey <int>,
# #   acceptedTaxonKey <int>, acceptedScientificName <chr>, kingdom <chr>, …
# # ℹ Use `colnames()` to see all variable names

# occ_search has limit 10K records for download
gbif_Sphfuscum <- occ_search(scientificName = "Sphagnum fuscum", hasCoordinate=T, basisOfRecord='HUMAN_OBSERVATION', limit = 10000) 

# another way how to download more than 10K records but you need to use credentials
# 1) Get the GBIF taxonKey
key <- name_backbone(name = "Sphagnum fuscum")$usageKey

# 1. Find or create .Renviron
# In R, you can ask where your home directory is with:
path.expand("~")
# "C:/Users/patricia/Documents"
# In that folder, create a plain text file called .Renviron (notice the leading dot).

# 2. Put your GBIF credentials inside
# The file should contain exactly these three lines (replace placeholders with your real details):
# GBIF_USER=your_gbif_username
# GBIF_PWD=your_gbif_password
# GBIF_EMAIL=your_email@domain.com
# ⚠️ No quotes, no commas, one variable per line.

# 3. Restart R / RStudio
# When R starts up, it reads .Renviron and makes those values available with Sys.getenv().

#Check that it worked:
Sys.getenv("GBIF_USER")
Sys.getenv("GBIF_EMAIL")

#They should show your username and email.
# if it show "" empty results it means your .Renviron file have actually name .Renviron.txt
# Step 1: Show file name extensions
# Open File Explorer.
# In the top menu, click View → Show → File name extensions.
# (Now you will see the .txt on every text file.)
# Step 2: Rename the file
# Right-click .Renviron.txt in C:/Users/patricia/Documents.
# Choose Rename.
# Delete the .txt part, so the name is exactly:
#  .Renviron
# Press Enter.
# Windows will warn you: “If you change a file name extension, the file might become unusable”. Click Yes.



# 2) Submit a download request (runs on GBIF servers)
req <- occ_download(
  pred("taxonKey", key),
  pred("hasCoordinate", TRUE),
  pred("basisOfRecord", "HUMAN_OBSERVATION"),
  format = "SIMPLE_CSV"   # tidy CSV
)

# 3) Wait until it’s ready, then fetch and import
occ_download_wait(req)
# status: preparing
# status: running
# status: succeeded
# download is done, status: succeeded
# <<gbif download metadata>>
# Status: SUCCEEDED
# DOI: 10.15468/dl.teau3p
# Format: SIMPLE_CSV
# Download key: 0011176-250920141307145
# Created: 2025-09-24T07:33:29.583+00:00
# Modified: 2025-09-24T07:35:32.031+00:00
# Download link: https://api.gbif.org/v1/occurrence/download/request/0011176-250920141307145.zip
# Total records: 14100

# re-download (set overwrite = TRUE if needed)
zip_path <- occ_download_get(req, overwrite = TRUE)

# zip_path is now just a character string
zip_path
# "C:/Users/patricia/Documents/gbif/0001234-240506142123456.zip"  (example)

# import the data
dat <- occ_download_import(zip_path)

nrow(dat)  # check number of records

# Optional: basic check
nrow(dat)
dplyr::count(dat, basisOfRecord)


# We are just interested in the data frame containing the records
gbif_Sphfuscum <- gbif_Sphfuscum$data

library(maps)
map("world") # world map
maps::map('world',xlim = c(-25, 45), ylim = c(34, 72)) # Europe
points(gbif_Sphfuscum$decimalLongitude, gbif_Sphfuscum$decimalLatitude, col='red',  pch=19)


