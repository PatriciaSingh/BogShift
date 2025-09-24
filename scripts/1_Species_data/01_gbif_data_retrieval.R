#' ---
#' title: "Species data"
#' author: "Patrícia Singh"
#' date: "`r Sys.Date()`"
#' output: 
#'   html_document:
#'     toc: true
#'     toc_float: true
#'     code_folding: show
#' ---

#' # Tutorial 1: Retrieving Species Data from GBIF
#' 
#' ### Learning Objectives
#' By the end of this tutorial, you will be able to:
#' - Distinguish between GBIF occurrences and observations
#' - Search and download species data from GBIF
#' - Create basic distribution maps
#' - Set up GBIF credentials for bulk downloads
#' - Understand data quality considerations for SDM
#' 
#' ## 1.1 Setup and Configuration
#' 
#' We will use the package `rgbif` to search and retrieve data from GBIF. 
#' Remember that we can install new packages with the function `install.packages()`.

#+ load-required-packages, message=FALSE, warning=FALSE
library(rgbif)
library(dplyr)

#+ configure-environment-settings, include=FALSE
# Run online calls only when you say so
ONLINE <- interactive() || identical(tolower(Sys.getenv("GBIF_ONLINE")), "true")

# safer defaults for long requests (affects base download.file etc.)
options(timeout = 600)

# knitr defaults
if (requireNamespace("knitr", quietly = TRUE)) {
  knitr::opts_chunk$set(cache = TRUE, error = TRUE)  # don't abort the knit
}

#' ## 1.2 Understanding GBIF Data Types
#' 
#' ### Occurrences vs. Observations
#' 
#' It is important to know the difference between occurrences and observations.
#' 
#' **Occurrences** include all types of biodiversity records:
#' - Museum specimens
#' - Fossil records  
#' - Human or machine observations
#' - Environmental DNA records
#' 
#' Total number of all occurrences in GBIF:

#+ total-gbif-occurrences
occ_count()

#' **Observations** are specifically recorded in the field by person, sensor or camera trap:
#' - iNaturalist photo records
#' - Birdwatchers' checklists  
#' - Vegetation plot surveys
#' 
#' Total number of observations in GBIF:

#+ total-gbif-observations
occ_count(basisOfRecord='OBSERVATION')

#' > **💡 Tip**: For Species Distribution Modeling, observations are used
#' > because they represent recent, verified sightings rather than historical museum records.
#' 
#' ### Country-level Data Exploration
#' 
#' Number of occurrences by country (check https://countrycode.org/ for country codes):

#+ occurrences-by-country
occ_count(country='CZ') # Czech Republic
occ_count(country='SK') # Slovakia

#' Number of observations by country:

#+ observations-by-country
occ_count(country='CZ',basisOfRecord='OBSERVATION')
occ_count(country='SK',basisOfRecord='OBSERVATION')

#' ### 🧪 Try It Yourself
#' Change the country codes to compare data availability for your study region. 
#' Try 'US', 'CA', 'GB', or any other countries relevant to your research.
#' 
#' ## 1.3 Species Selection and Validation
#' 
#' For this example, I picked the **Rusty Bog-moss** (*Sphagnum fuscum*), 
#' a typical bog bryophyte species. Its conservation status is Least Concern 
#' ([IUCN Red List](https://www.iucnredlist.org/species/87567639/87841272)).
#' 
#' ### Check for Synonyms
#' 
#' Always verify the accepted scientific name and check for synonyms:

#+ check-species-synonyms
name_suggest(q='Sphagnum fuscum', rank='species')

#' > **⚠️ Important**: Always check for synonyms before downloading data to ensure 
#' > you're getting all relevant records for your species.
#' 
#' ## 1.4 Small-scale Data Retrieval
#' 
#' ### Understanding occ_search Parameters

#+ help-occ-search-parameters, eval=FALSE
?occ_search

#' ### Search for Human Observations
#' 
#' For SDM studies, we typically want human observations with coordinates:

#+ search-human-observations
occ_search(scientificName = "Sphagnum fuscum", 
           hasCoordinate = TRUE, 
           basisOfRecord = 'HUMAN_OBSERVATION', 
           limit = 10)

#' > **⚠️ Important**: The `occ_search()` function has a 100,000 record limit. 
#' > For larger datasets, use `occ_download()` as shown below.
#' 
#' One of the most interesting items from the output is "Records found" at the very top. 
#' If GBIF contains more than 100,000 records for your search, you'll need to either:
#' - Set additional filters (time period, geographic extent)
#' - Split the area into spatial tiles
#' - Use the `occ_download()` function
#' 
#' ## 1.5 Large-scale Data Downloads
#' 
#' ### Get Species Taxon Key

#+ get-taxon-key
key <- name_backbone(name = "Sphagnum fuscum")$usageKey
key

#' ### Setting Up GBIF Credentials
#' 
#' To download more than 10,000 records, you need GBIF credentials.
#' 
#' **Step 1: Find your home directory**

#+ find-home-directory
path.expand("~")

#' **Step 2: Create .Renviron file**
#' 
#' In your home directory, create a plain text file called `.Renviron` (notice the leading dot) containing:
#' 
#' ```
#' GBIF_USER=your_gbif_username
#' GBIF_PWD=your_gbif_password  
#' GBIF_EMAIL=your_email@domain.com
#' ```
#' 
#' > **🔧 Technical Note**: No quotes, no commas, one variable per line. 
#' > Restart R/RStudio after creating this file.
#' 
#' **Step 3: Verify credentials**

#+ check-gbif-credentials
Sys.getenv("GBIF_USER")
Sys.getenv("GBIF_EMAIL")

#' > **⚠️ Troubleshooting**: If these show empty results (""), your file might be named 
#' > `.Renviron.txt`. Follow the instructions in the troubleshooting section below.
#' 
#' ### Download Large Dataset

#+ download-gbif-data, eval=FALSE, cache=TRUE
# Create download request
req <- occ_download(
  pred("taxonKey", key),
  pred("hasCoordinate", TRUE),
  pred("basisOfRecord", "HUMAN_OBSERVATION"),
  format = "SIMPLE_CSV"
)

# Wait for download to complete
occ_download_wait(req, status_ping = 10)

# Download the file
zip_path <- occ_download_get(req, overwrite = TRUE,
                             curlopts = list(timeout = 600, connecttimeout = 120))

# Save a copy for future use
dir.create("data", showWarnings = FALSE)
file.copy(zip_path, "data/gbif_download.zip", overwrite = TRUE)

#' > **💡 Tip**: Large downloads can take several minutes to hours depending on the 
#' > dataset size. The download runs on GBIF servers, so you can close R and check back later.
#' 
#' ## 1.6 Data Processing
#' 
#' ### Import Downloaded Data

#+ import-downloaded-data
# Import downloaded data
if (file.exists("data/gbif_download.zip")) {
  # Extract and read the CSV file from zip
  temp_dir <- tempdir()
  unzip("data/gbif_download.zip", exdir = temp_dir)
  csv_files <- list.files(temp_dir, pattern = "\\.csv$", full.names = TRUE)
  dat <- read.delim(csv_files[1], sep = "\t", quote = "")
} else {
  # If no downloaded file exists, use occ_search for demonstration
  message("No download file found, please run the download section first")
  search_result <- occ_search(scientificName = "Sphagnum fuscum", 
                              hasCoordinate = TRUE, 
                              basisOfRecord = 'HUMAN_OBSERVATION', 
                              limit = 300)
  dat <- search_result$data
}

#' ### Check Data Quality

#+ check-record-count
# Check number of records
nrow(dat)

# Preview data structure
str(dat)

# Check coordinate completeness
sum(is.na(dat$decimalLatitude))
sum(is.na(dat$decimalLongitude))

#+ extract-data-frame
# Extract the main data
gbif_Sphfuscum <- dat
head(gbif_Sphfuscum)

#' ### ❓ Quick Check
#' - How many records did you download?
#' - Are there any missing coordinates?
#' - What time period do the observations cover?
#' 
#' ## 1.7 Basic Mapping
#' 
#' ### Load Mapping Libraries

#+ load-mapping-library
library(maps)

#' ### Create World Map

#+ create-world-map
map("world")
title("Global Distribution of Sphagnum fuscum")

#' ### Create Regional Map (Europe)

#+ create-europe-map
maps::map('world', xlim = c(-25, 45), ylim = c(34, 72))
title("European Distribution of Sphagnum fuscum")

#' ### Add Species Points

#+ add-species-points
points(gbif_Sphfuscum$decimalLongitude, 
       gbif_Sphfuscum$decimalLatitude, 
       col = 'red', 
       pch = 19, 
       cex = 0.5)

#' > **💡 Tip**: The small red dots represent occurrence locations. Notice the 
#' > distribution pattern - does it match what you know about bog moss ecology?
#' 
#' ## Common Issues and Solutions
#' 
#' ### .Renviron File Problems
#' If `Sys.getenv()` shows empty results:
#' 
#' 1. **Show file extensions in Windows:**
#'    - File Explorer → View → Show → File name extensions
#'    
#' 2. **Rename the file:**
#'    - Right-click `.Renviron.txt` → Rename → Remove `.txt`
#'    - Confirm when Windows warns about changing extensions
#' 
#' 3. **Restart R/RStudio** after making changes
#' 
#' ### Download Issues
#' - **Timeout errors**: Increase `timeout` values in `options()`
#' - **Too many records**: Add geographic filters using `pred("country", "US")` or coordinate bounds
#' - **Server busy**: Try downloading during off-peak hours
#' 
#' ### Data Quality Issues
#' - **Suspicious coordinates**: Check for points at 0,0 or on country centroids
#' - **Old records**: Filter by year if you need recent data only
#' - **Duplicate records**: Remove duplicates based on coordinates and date
#' 
#' ## Next Steps
#' 
#' Now that you have successfully downloaded and mapped species occurrence data, you're ready for:
#' 
#' **Tutorial 2: Data Cleaning and Quality Assessment**
#' - Removing duplicate records
#' - Identifying spatial outliers
#' - Temporal filtering
#' - Coordinate validation
#' 
#' **Tutorial 3: Environmental Data Acquisition** 
#' - Downloading WorldClim data
#' - Extracting environmental variables
#' - Handling multi-temporal data
#' 
#' **Tutorial 4: Species Distribution Modeling**
#' - Model selection (MaxEnt, Random Forest, etc.)
#' - Cross-validation strategies
#' - Model evaluation metrics
#' 
#' ### 🧪 Final Challenge
#' Try downloading data for a different species in your region of interest. Consider:
#' - A species with fewer records (< 1000)
#' - A species with global distribution
#' - An invasive species with recent spread
#' 
#' How do the patterns differ? What challenges might arise for SDM with each type?
#' 
#' ---
#' 
#' > **📚 Additional Resources:**
#' > - [GBIF Data Quality Requirements](https://www.gbif.org/data-quality-requirements)
#' > - [rgbif Package Documentation](https://docs.ropensci.org/rgbif/)
#' > - [Species Distribution Modeling Best Practices](https://onlinelibrary.wiley.com/doi/abs/10.1111/ecog.01132)