# easyblup Quick Start Script
# Run this script to quickly set up and launch the easyblup application

cat("=== easyblup Quick Start ===\n")
cat("Setting up easyblup application...\n\n")

# Check if required packages are installed
required_packages <- c("shiny", "sortable", "shinyjqui")
missing_packages <- required_packages[!required_packages %in% installed.packages()[,"Package"]]

if(length(missing_packages) > 0) {
  cat("Installing missing packages:", paste(missing_packages, collapse = ", "), "\n")
  install.packages(missing_packages, repos = "https://cran.rstudio.com/")
  cat("Packages installed successfully!\n\n")
} else {
  cat("All required packages are already installed!\n\n")
}

# Load required libraries
cat("Loading libraries...\n")
library(shiny)
library(sortable)
library(shinyjqui)

# Resolve the app path. Prefer the packaged location under inst/ for development.
app_path <- NULL
if (file.exists("inst/shiny_app/app.R")) {
  app_path <- "inst/shiny_app/app.R"
} else if (file.exists("shiny_app/app.R")) {
  app_path <- "shiny_app/app.R"
}

if (is.null(app_path)) {
  cat("ERROR: Please run this script from the easyblup project root directory.\n")
  cat("Expected to find the Shiny application under 'inst/shiny_app/'.\n")
  stop("Application directory not found")
}

# Launch the application
cat("Launching easyblup application...\n")
cat("The application will open in your default web browser.\n")
cat("If it doesn't open automatically, go to: http://localhost:3838\n\n")

# Run the app
shiny::runApp(app_path, launch.browser = TRUE)
