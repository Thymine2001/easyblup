# Deploy easyblup to shinyapps.io
# Run this script to deploy the application

# Install required packages if not already installed
if (!require(rsconnect)) {
  install.packages("rsconnect", repos = "https://cran.rstudio.com/")
}

# Load rsconnect
library(rsconnect)

# Configure your shinyapps.io account
# You need to get your token and secret from https://www.shinyapps.io/admin/#/tokens
# Then run: rsconnect::setAccountInfo(name="your-account-name", token="your-token", secret="your-secret")

# Deploy the application
deployApp(
  appDir = ".",
  appName = "easyblup",
  appTitle = "easyblup: Parameter File Generator for BLUPF90",
  appFiles = c("app.R", "example_data.csv", "example_data.map", "example_data.ped"),
  forceUpdate = TRUE
)

cat("Deployment completed! Check your shinyapps.io dashboard.\n")
