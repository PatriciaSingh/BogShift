# Load required libraries
library(rgbif)
library(dplyr)
library(CoordinateCleaner)

# Unzip and save as CSV
species_name <- "gbif_Sphagnum_fuscum"
unzip(paste0(species_name, ".zip"))
csv_file <- list.files(pattern = "\\.csv$")
file.rename(csv_file[1], paste0(species_name, ".csv"))

gbif_occu <- read.delim("gbif_Sphagnum_fuscum.csv")

# Fix column names for easy saving
gbif_occu <- gbif_occu %>%
  rename(
    decimallongitude = decimalLongitude,  # lowercase for CoordinateCleaner
    decimallatitude = decimalLatitude,    # lowercase for CoordinateCleaner
    countrycode = countryCode             # lowercase for CoordinateCleaner
  )

# Now clean coordinates
gbif_occu_cleaned_coord <- clean_coordinates(
  x = gbif_occu,
  lon = "decimallongitude",      # lowercase
  lat = "decimallatitude",       # lowercase  
  countries = "countrycode",     # lowercase
  tests = c("centroids", "outliers", "duplicates", "institutions"), 
  inst_rad = 1000
)

# Store the cleaned point locations in a new object
gbif_occu_cleaned <- gbif_occu[gbif_occu_cleaned_coord$.summary,]
# Save cleaned data
write.csv(gbif_occu_cleaned, "gbif_Sphagnum_fuscum_cleaned.csv", row.names = FALSE)

# Save the map as PNG file
png("gbif_Sphagnum_fuscum_cleaning_map.png", width = 800, height = 600)

# Plot world map
maps::map('world')
# Plot all gbif points downloaded
points(gbif_occu$decimallongitude, gbif_occu$decimallatitude, col='red',  pch=19)
# Plot all remaining points after cleaning
points(gbif_occu_cleaned_coord$decimallongitude[gbif_occu_cleaned_coord$.summary], gbif_occu_cleaned_coord$decimallatitude[gbif_occu_cleaned_coord$.summary], col='blue',  pch=18)

# Close and save the file
dev.off()

# Load leaflet library
library(leaflet)

# Create interactive map
map <- leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap tiles
  addCircleMarkers(
    lng = gbif_occu$decimallongitude, 
    lat = gbif_occu$decimallatitude,
    color = "red", 
    radius = 3,
    popup = "Original data",
    group = "Original"
  ) %>%
  addCircleMarkers(
    lng = gbif_occu_cleaned_coord$decimallongitude[gbif_occu_cleaned_coord$.summary], 
    lat = gbif_occu_cleaned_coord$decimallatitude[gbif_occu_cleaned_coord$.summary],
    color = "blue", 
    radius = 3,
    popup = "Cleaned data",
    group = "Cleaned"
  ) %>%
  addLayersControl(
    overlayGroups = c("Original", "Cleaned"),
    options = layersControlOptions(collapsed = FALSE)
  )
# Create popup info for flagged points
flagged_points <- gbif_occu_cleaned_coord[!gbif_occu_cleaned_coord$.summary, ]
flagged_reasons <- apply(gbif_occu_cleaned_coord[!gbif_occu_cleaned_coord$.summary, 
                                                 c(".val", ".cen", ".otl", ".inst", ".dpl")], 1, function(x) {
                                                   reasons <- c()
                                                   if(!x[1]) reasons <- c(reasons, "Invalid coordinates")
                                                   if(!x[2]) reasons <- c(reasons, "Country centroid")
                                                   if(!x[3]) reasons <- c(reasons, "Geographic outlier")
                                                   if(!x[4]) reasons <- c(reasons, "Near institution")
                                                   if(!x[5]) reasons <- c(reasons, "Duplicate")
                                                   paste(reasons, collapse = ", ")
                                                 })

# Add flagged points to your existing map
map <- map %>%
  addCircleMarkers(
    lng = flagged_points$decimallongitude,
    lat = flagged_points$decimallatitude,
    color = "orange",
    radius = 4,
    popup = paste("Flagged:", flagged_reasons),
    group = "Flagged"
  ) %>%
  addLayersControl(
    overlayGroups = c("Original", "Cleaned", "Flagged"),
    options = layersControlOptions(collapsed = FALSE)
  )

# Save as HTML file
library(htmlwidgets)
saveWidget(map, "Sphagnum_fuscum_interactive_map.html")





