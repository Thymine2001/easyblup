# Interactive Deployment Script for easyblup
# This script will guide you through the deployment process

cat("=== easyblup Deployment to shinyapps.io ===\n")
cat("This script will help you deploy your easyblup application.\n\n")

# Check if rsconnect is installed
if (!require(rsconnect, quietly = TRUE)) {
  cat("Installing rsconnect package...\n")
  install.packages("rsconnect", repos = "https://cran.rstudio.com/")
  library(rsconnect)
}

# Get account information from user
cat("Please provide your shinyapps.io account information:\n")
cat("(You can find this at https://www.shinyapps.io/admin/#/tokens)\n\n")

account_name <- readline("Enter your account name: ")
token <- readline("Enter your token: ")
secret <- readline("Enter your secret: ")

cat("\nConfiguring account...\n")

# Configure account
tryCatch({
  rsconnect::setAccountInfo(
    name = account_name,
    token = token,
    secret = secret
  )
  cat("✅ Account configured successfully!\n\n")
}, error = function(e) {
  cat("❌ Error configuring account:", e$message, "\n")
  cat("Please check your account information and try again.\n")
  stop("Account configuration failed")
})

# Deploy the application
cat("Deploying application...\n")
cat("This may take a few minutes...\n\n")

tryCatch({
  deployApp(
    appDir = ".",
    appName = "easyblup",
    appTitle = "easyblup: Parameter File Generator for BLUPF90",
    appFiles = c("app.R", "example_data.csv", "example_data.map", "example_data.ped"),
    forceUpdate = TRUE
  )
  
  cat("\n🎉 Deployment successful!\n")
  cat("Your application is now available at:\n")
  cat(paste0("https://", account_name, ".shinyapps.io/easyblup/\n"))
  
}, error = function(e) {
  cat("❌ Deployment failed:", e$message, "\n")
  cat("Please check the error message and try again.\n")
})

cat("\nDeployment process completed.\n")
