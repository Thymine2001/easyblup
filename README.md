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

### Install from GitHub

```r
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}
remotes::install_github("Thymine2001/easyblup")
```

### Launch the Application

```r
easyblup::run_easyblup()
```

The app opens in your default browser (or RStudio viewer if preferred).

## Installation

For detailed installation instructions, see [INSTALLATION.md](INSTALLATION.md)

## Usage

1. Launch the application:
   ```r
   easyblup::run_easyblup()
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
├── DESCRIPTION               # Package metadata
├── NAMESPACE                 # Exported functions
├── R/
│   └── run_easyblup.R        # Helper to launch the Shiny app
├── inst/
│   └── shiny_app/            # Packaged Shiny application assets
│       ├── app.R             # Main Shiny application
│       ├── minimal_app.R     # Simplified app variant
│       └── example_data.*    # Example input files
├── man/                      # Function documentation
├── quick_start.R             # Local helper script
└── README.md                 # Project overview (this file)
```

## Requirements

- R >= 3.6.0
- shiny >= 1.7.0
- sortable >= 0.4.2

## License

MIT License
