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

# Check if we're in the right directory
if(!file.exists("shiny_app/app.R")) {
  cat("ERROR: Please run this script from the easyblup root directory.\n")
  cat("Make sure you're in the directory containing the 'shiny_app' folder.\n")
  stop("Wrong directory")
}

# Launch the application
cat("Launching easyblup application...\n")
cat("The application will open in your default web browser.\n")
cat("If it doesn't open automatically, go to: http://localhost:3838\n\n")

# Run the app
shiny::runApp("shiny_app/app.R", launch.browser = TRUE)
