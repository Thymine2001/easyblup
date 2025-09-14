# easyblup: Parameter File Generator for BLUPF90

A visual Shiny application for generating parameter files for BLUPF90 software using drag-and-drop interface.

## Features

- **Visual Parameter Generation**: Drag-and-drop interface for defining linear mixed models
- **Purdue Black & Gold Theme**: Professional UI with Purdue University color scheme
- **Multiple File Formats**: Support for phenotype files (.txt, .dat, .csv) with space-separated data
- **Comprehensive Options**: Full range of BLUPF90 OPTION parameters
- **Real-time Preview**: Live parameter file preview with instant updates
- **Resizable Panels**: Customizable interface with resizable windows
- **Download Functionality**: Export generated parameter files

## Deployment to shinyapps.io

### Prerequisites

1. Create a free account at [shinyapps.io](https://www.shinyapps.io/)
2. Get your account token and secret from the dashboard

### Deploy Steps

1. **Configure your account** (run once):
   ```r
   library(rsconnect)
   rsconnect::setAccountInfo(
     name="your-account-name", 
     token="your-token", 
     secret="your-secret"
   )
   ```

2. **Deploy the application**:
   ```r
   source("deploy.R")
   ```

   Or manually:
   ```r
   library(rsconnect)
   deployApp(appDir = ".", appName = "easyblup")
   ```

### Files Included

- `app.R` - Main application file
- `example_data.csv` - Sample phenotype data
- `example_data.ped` - Sample pedigree data  
- `example_data.map` - Sample genotype map data
- `deploy.R` - Deployment script

## Usage

1. Upload your phenotype file (space-separated text file)
2. Optionally upload pedigree and genotype files
3. Drag variables to appropriate model components:
   - **Traits (y)**: Response variables
   - **Fixed Effects (b)**: Fixed effects
   - **Animal ID (a)**: Animal random effect
   - **Other Random Effects (r)**: Additional random effects
4. Configure parameter options in the left panel
5. Preview and download the generated parameter file

## Model Formula

The application generates parameter files for the linear mixed model:

**y = Xb + Za + Wr + e**

Where:
- y: Traits (response variables)
- b: Fixed effects
- a: Animal additive genetic effect
- r: Other random effects
- e: Residual

## Requirements

- R packages: shiny, sortable, shinyjqui
- Modern web browser with JavaScript enabled
