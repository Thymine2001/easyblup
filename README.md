# easyblup

A visual parameter file generator for BLUPF90 using R Shiny.

## Description

easyblup is an interactive Shiny application that allows users to generate BLUPF90 parameter files through a user-friendly drag-and-drop interface. Users can upload their phenotypic data, define their linear mixed model by dragging variables into appropriate categories, and automatically generate the corresponding renumf90 parameter file.

## Features

- **Interactive Data Upload**: Upload CSV files containing phenotypic data and PLINK format genotype data
- **Large File Support**: Support for files up to 10GB in size
- **PLINK Format Support**: Native support for PED and MAP files for genomic analysis
- **Visual Model Definition**: Drag and drop variables to define your linear mixed model components
- **Real-time Parameter Preview**: See the generated renumf90 parameter file update in real-time
- **User-friendly Interface**: Clean, intuitive design with color-coded model components
- **Genomic Analysis**: Automatic generation of genomic analysis parameters when genotype data is provided

## 🌐 Online Demo

**Try the application online**: https://vb6clt-huangyi-tang.shinyapps.io/easyblup/

## Quick Start

### 1. Download the Project
```bash
git clone https://github.com/Thymine2001/easyblup.git
cd easyblup
```

### 2. Install Required Packages
```r
install.packages(c("shiny", "sortable", "shinyjqui"), 
                 repos = "https://cran.rstudio.com/")
```

### 3. Run the Application
```bash
cd shiny_app
Rscript app.R
```

Then open your browser and go to `http://localhost:3838`

## Installation

For detailed installation instructions, see [INSTALLATION.md](INSTALLATION.md)

## Usage

1. Run the application:
   ```r
   shiny::runApp()
   ```

2. Upload your phenotypic data CSV file using the "Upload Phenotypic Data" button (max 10GB)

3. Optionally upload PLINK format genotype data using the "Upload Genotype Data" button:
   - Upload both PED and MAP files
   - Maximum combined size: 10GB

4. Drag variables from the "Available Variables" section into the appropriate model component boxes:
   - **Traits (y)**: Drag your trait variables here
   - **Fixed Effects (b)**: Drag your fixed effect variables here  
   - **Animal ID (a)**: Drag your animal ID variable here
   - **Other Random Effects (r)**: Drag other random effect variables here

5. View the generated renumf90 parameter file in the preview section at the bottom

## Model Components

The application supports the standard linear mixed model:

**y = Xb + Za + Wr + e**

Where:
- **y**: Traits (性状)
- **b**: Fixed Effects (固定效应)  
- **a**: Animal Additive Genetic Effect (动物加性遗传效应)
- **r**: Other Random Effects (其他随机效应)
- **e**: Residual (残差)

## File Structure

```
easyblup/
├── app.R                    # Main Shiny application
├── DESCRIPTION              # Package dependencies
├── easyblup.Rproj           # RStudio project file
├── example_data.csv         # Example phenotypic data
├── example_data.ped         # Example genotype data (PED format)
├── example_data.map         # Example genotype data (MAP format)
├── run_app.R                # Application launcher script
├── test_app.R               # Test script
├── USAGE.md                 # Detailed usage instructions
├── PROJECT_SUMMARY.md       # Project summary
└── README.md                # This file
```

## Requirements

- R >= 3.6.0
- shiny >= 1.7.0
- sortable >= 0.4.2

## License

MIT License
