# easyblup: A visual parameter file generator for BLUPF90
# Shiny Application

# Load required libraries
library(shiny)
library(sortable)
library(shinyjqui)
library(shinyjs)

# Define UI
ui <- fluidPage(
  title = "easyblup",
  useShinyjs(),
  
  # Custom CSS for better drag and drop experience
  tags$head(
    tags$style(HTML("
      /* Custom styles for drag and drop */
      .default-sortable .rank-list-item {
        background-color: #007bff !important;
        color: white !important;
        border: none !important;
        border-radius: 20px !important;
        padding: 8px 16px !important;
        margin: 4px !important;
        display: inline-block !important;
        cursor: move !important;
        font-size: 14px !important;
        font-weight: 500 !important;
        box-shadow: 0 2px 4px rgba(0,123,255,0.3) !important;
        transition: all 0.2s ease !important;
      }
      
      .default-sortable .rank-list-item:hover {
        background-color: #0056b3 !important;
        transform: translateY(-1px) !important;
        box-shadow: 0 4px 8px rgba(0,123,255,0.4) !important;
      }
      
      .default-sortable .rank-list-item:active {
        transform: scale(0.95) !important;
      }
      
      /* Drop zone styles */
      .default-sortable .rank-list-container {
        border: 2px dashed #ccc !important;
        border-radius: 8px !important;
        padding: 15px !important;
        min-height: 120px !important;
        background-color: #f8f9fa !important;
        transition: all 0.2s ease !important;
      }
      
      .default-sortable .rank-list-container:hover {
        border-color: #007bff !important;
        background-color: #e3f2fd !important;
      }
      
      .default-sortable .rank-list-container.drag-over {
        border-color: #28a745 !important;
        background-color: #d4edda !important;
        transform: scale(1.02) !important;
      }
      
      /* Empty state styling */
      .default-sortable .rank-list-container:empty::after {
        content: 'Drop variables here';
        color: #6c757d;
        font-style: italic;
        display: flex;
        align-items: center;
        justify-content: center;
        height: 100%;
        font-size: 14px;
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        pointer-events: none;
      }
      
      .default-sortable .rank-list-container {
        position: relative;
      }
      
      /* Header styles */
      .default-sortable .rank-list-header {
        font-weight: bold !important;
        color: #2c3e50 !important;
        margin-bottom: 10px !important;
        font-size: 16px !important;
      }
      
      /* Responsive design */
      @media (max-width: 768px) {
        .default-sortable .rank-list-container {
          min-height: 100px !important;
        }
      }
    "))
  ),
  
  # Main title
  titlePanel("easyblup: A visual parameter file generator for BLUPF90"),
  
  # Main layout - Full width for better drag and drop experience
  fluidRow(
    # Left sidebar panel - File upload
    column(
      width = 3,
      style = "background-color: #f8f9fa; padding: 20px; min-height: 100vh;",
      
      # File upload section
      h4("📁 Data Upload", style = "color: #2c3e50; margin-bottom: 20px;"),
      
      # File size limit notice
      div(
        style = "background-color: #e8f4fd; padding: 12px; border-radius: 8px; margin-bottom: 20px; border-left: 4px solid #007bff;",
        p("📊 Maximum file size: 10GB", style = "margin: 0; font-size: 13px; color: #666; font-weight: 500;")
      ),
      
      # Phenotypic data upload
      fileInput(
        inputId = "pheno_file",
        label = "1. Upload Phenotypic Data (.csv)",
        accept = c(".csv"),
        placeholder = "Select CSV file",
        multiple = FALSE,
        buttonLabel = "Browse CSV",
        width = "100%"
      ),
      
      # Genotype data upload
      fileInput(
        inputId = "geno_file", 
        label = "2. Upload Genotype Data (Optional)",
        accept = c(".ped", ".map"),
        placeholder = "Select PED/MAP files",
        multiple = TRUE,
        buttonLabel = "Browse PED/MAP",
        width = "100%"
      ),
      
      # Genotype format help
      div(
        style = "background-color: #fff3cd; padding: 12px; border-radius: 8px; margin-top: 15px; border-left: 4px solid #ffc107;",
        h6("🧬 PLINK Format Requirements:", style = "margin: 0 0 8px 0; font-weight: bold; color: #856404;"),
        p("• PED file: Contains genotype data", style = "margin: 2px 0; font-size: 12px; color: #856404;"),
        p("• MAP file: Contains marker information", style = "margin: 2px 0; font-size: 12px; color: #856404;"),
        p("• Both files are required for genomic analysis", style = "margin: 2px 0; font-size: 12px; color: #856404;")
      )
    ),
    
    # Main content area
    column(
      width = 9,
      style = "padding: 20px;",
      
      # Variables section
      div(
        style = "background-color: white; padding: 20px; border-radius: 10px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);",
        h4("📋 Available Variables", style = "color: #2c3e50; margin-bottom: 15px;"),
        uiOutput("column_tags_ui")
      ),
      
      # Model definition section
      div(
        style = "background-color: white; padding: 20px; border-radius: 10px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);",
        
        # Model formula display
        div(
          style = "background-color: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #e9ecef;",
          h4("📐 Linear Mixed Model Formula:", style = "color: #2c3e50; margin-bottom: 10px;"),
          h3("y = Xb + Za + Wr + e", style = "text-align: center; color: #007bff; font-weight: bold; margin: 15px 0;"),
          div(
            style = "display: flex; justify-content: space-around; flex-wrap: wrap;",
            div(style = "text-align: center; margin: 5px;", strong("y"), br(), "Traits (性状)"),
            div(style = "text-align: center; margin: 5px;", strong("b"), br(), "Fixed Effects (固定效应)"),
            div(style = "text-align: center; margin: 5px;", strong("a"), br(), "Animal ID (动物ID)"),
            div(style = "text-align: center; margin: 5px;", strong("r"), br(), "Random Effects (随机效应)"),
            div(style = "text-align: center; margin: 5px;", strong("e"), br(), "Residual (残差)")
          )
        ),
        
        # Drag and drop mapping area
        h4("🎯 Drag Variables to Define Your Model:", style = "color: #2c3e50; margin-bottom: 20px;"),
        
        # Horizontal drop zones layout
        div(
          style = "display: flex; justify-content: space-between; flex-wrap: wrap; gap: 15px;",
          
          # Traits drop zone
          div(
            style = "flex: 1; min-width: 200px;",
            div(
              style = "background-color: #ffe4b3; border: 2px dashed #ffa500; min-height: 120px; border-radius: 8px; padding: 15px;",
              h5("🧬 Traits (y)", style = "margin-top: 0; margin-bottom: 10px; color: #d2691e;"),
              sortable::rank_list(
                text = "Drag variables here",
                labels = NULL,
                input_id = "traits_list",
                options = sortable::sortable_options(
                  group = list(
                    name = "shared_group",
                    pull = TRUE,
                    put = TRUE
                  )
                ),
                class = "default-sortable"
              ),
              br(),
              uiOutput("traits_display")
            )
          ),
          
          # Fixed effects drop zone
          div(
            style = "flex: 1; min-width: 200px;",
            div(
              style = "background-color: #ffcccc; border: 2px dashed #ff6b6b; min-height: 120px; border-radius: 8px; padding: 15px;",
              h5("📊 Fixed Effects (b)", style = "margin-top: 0; margin-bottom: 10px; color: #d63031;"),
              sortable::rank_list(
                text = "Drag variables here",
                labels = NULL,
                input_id = "fixed_effects_list",
                options = sortable::sortable_options(
                  group = list(
                    name = "shared_group",
                    pull = TRUE,
                    put = TRUE
                  )
                ),
                class = "default-sortable"
              ),
              br(),
              uiOutput("fixed_effects_display")
            )
          ),
          
          # Animal ID drop zone
          div(
            style = "flex: 1; min-width: 200px;",
            div(
              style = "background-color: #d9ead3; border: 2px dashed #28a745; min-height: 120px; border-radius: 8px; padding: 15px;",
              h5("🐄 Animal ID (a)", style = "margin-top: 0; margin-bottom: 10px; color: #389e0d;"),
              sortable::rank_list(
                text = "Drag variables here",
                labels = NULL,
                input_id = "animal_list",
                options = sortable::sortable_options(
                  group = list(
                    name = "shared_group",
                    pull = TRUE,
                    put = TRUE
                  )
                ),
                class = "default-sortable"
              ),
              br(),
              uiOutput("animal_display")
            )
          ),
          
          # Other random effects drop zone
          div(
            style = "flex: 1; min-width: 200px;",
            div(
              style = "background-color: #cce5ff; border: 2px dashed #007bff; min-height: 120px; border-radius: 8px; padding: 15px;",
              h5("🎲 Random Effects (r)", style = "margin-top: 0; margin-bottom: 10px; color: #096dd9;"),
              sortable::rank_list(
                text = "Drag variables here",
                labels = NULL,
                input_id = "random_effects_list",
                options = sortable::sortable_options(
                  group = list(
                    name = "shared_group",
                    pull = TRUE,
                    put = TRUE
                  )
                ),
                class = "default-sortable"
              ),
              br(),
              uiOutput("random_effects_display")
            )
          )
        )
      ),
      
      # Parameter file preview
      div(
        style = "background-color: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);",
        h4("📄 renumf90 Parameter File Preview", style = "color: #2c3e50; margin-bottom: 15px;"),
        verbatimTextOutput("param_preview")
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Set file size limit to 10GB
  options(shiny.maxRequestSize = 10 * 1024^3)  # 10GB in bytes
  
  # Reactive values to track variables in each category
  traits_vars <- reactiveVal(character(0))
  fixed_effects_vars <- reactiveVal(character(0))
  animal_vars <- reactiveVal(character(0))
  random_effects_vars <- reactiveVal(character(0))
  
  # Function to create variable tag with delete button
  create_variable_tag <- function(var_name, category) {
    div(
      style = "display: inline-block; background-color: #f0f0f0; border: 1px solid #ccc; border-radius: 10px; padding: 5px 10px; margin: 2px; position: relative;",
      span(var_name, style = "margin-right: 5px;"),
      actionButton(
        inputId = paste0("remove_", category, "_", gsub("[^A-Za-z0-9]", "_", var_name)),
        label = "×",
        style = "background-color: #ff6b6b; color: white; border: none; padding: 2px 6px; border-radius: 50%; font-size: 12px; font-weight: bold; margin-left: 5px;",
        onclick = paste0("Shiny.setInputValue('remove_var', {var: '", var_name, "', category: '", category, "'}, {priority: 'event'});")
      )
    )
  }
  
  # Display functions for each category
  output$traits_display <- renderUI({
    vars <- traits_vars()
    if (length(vars) == 0) {
      return(NULL)
    }
    lapply(vars, function(var) create_variable_tag(var, "traits"))
  })
  
  output$fixed_effects_display <- renderUI({
    vars <- fixed_effects_vars()
    if (length(vars) == 0) {
      return(NULL)
    }
    lapply(vars, function(var) create_variable_tag(var, "fixed_effects"))
  })
  
  output$animal_display <- renderUI({
    vars <- animal_vars()
    if (length(vars) == 0) {
      return(NULL)
    }
    lapply(vars, function(var) create_variable_tag(var, "animal"))
  })
  
  output$random_effects_display <- renderUI({
    vars <- random_effects_vars()
    if (length(vars) == 0) {
      return(NULL)
    }
    lapply(vars, function(var) create_variable_tag(var, "random_effects"))
  })
  
  # Handle variable removal
  observeEvent(input$remove_var, {
    var_name <- input$remove_var$var
    category <- input$remove_var$category
    
    if (category == "traits") {
      current_vars <- traits_vars()
      new_vars <- current_vars[current_vars != var_name]
      traits_vars(new_vars)
    } else if (category == "fixed_effects") {
      current_vars <- fixed_effects_vars()
      new_vars <- current_vars[current_vars != var_name]
      fixed_effects_vars(new_vars)
    } else if (category == "animal") {
      current_vars <- animal_vars()
      new_vars <- current_vars[current_vars != var_name]
      animal_vars(new_vars)
    } else if (category == "random_effects") {
      current_vars <- random_effects_vars()
      new_vars <- current_vars[current_vars != var_name]
      random_effects_vars(new_vars)
    }
  })
  
  # Sync rank_list inputs with reactive values
  observeEvent(input$traits_list, {
    traits_vars(input$traits_list)
  })
  
  observeEvent(input$fixed_effects_list, {
    fixed_effects_vars(input$fixed_effects_list)
  })
  
  observeEvent(input$animal_list, {
    animal_vars(input$animal_list)
  })
  
  observeEvent(input$random_effects_list, {
    random_effects_vars(input$random_effects_list)
  })
  
  # Read phenotypic data
  pheno_data <- reactive({
    req(input$pheno_file)
    
    # Check file size
    file_size_mb <- input$pheno_file$size / (1024^2)
    if (file_size_mb > 10240) {  # 10GB in MB
      showNotification("File size exceeds 10GB limit", type = "error")
      return(NULL)
    }
    
    tryCatch({
      read.csv(input$pheno_file$datapath, stringsAsFactors = FALSE)
    }, error = function(e) {
      showNotification(paste("Error reading CSV file:", e$message), type = "error")
      return(NULL)
    })
  })
  
  # Read genotype data
  geno_data <- reactive({
    req(input$geno_file)
    
    # Check if both PED and MAP files are provided
    if (is.null(input$geno_file) || nrow(input$geno_file) == 0) {
      return(NULL)
    }
    
    # Check file sizes
    total_size_mb <- sum(input$geno_file$size) / (1024^2)
    if (total_size_mb > 10240) {  # 10GB in MB
      showNotification("Genotype files size exceeds 10GB limit", type = "error")
      return(NULL)
    }
    
    # Validate file types
    file_extensions <- tools::file_ext(input$geno_file$name)
    if (!all(file_extensions %in% c("ped", "map"))) {
      showNotification("Genotype files must be in PED/MAP format", type = "error")
      return(NULL)
    }
    
    # Check if both PED and MAP files are present
    has_ped <- any(file_extensions == "ped")
    has_map <- any(file_extensions == "map")
    
    if (!has_ped || !has_map) {
      showNotification("Both PED and MAP files are required for genotype data", type = "warning")
      return(NULL)
    }
    
    tryCatch({
      # Read PED file
      ped_file <- input$geno_file[input$geno_file$name == input$geno_file$name[file_extensions == "ped"], ]
      map_file <- input$geno_file[input$geno_file$name == input$geno_file$name[file_extensions == "map"], ]
      
      list(
        ped = read.table(ped_file$datapath, stringsAsFactors = FALSE),
        map = read.table(map_file$datapath, stringsAsFactors = FALSE),
        ped_name = ped_file$name,
        map_name = map_file$name
      )
    }, error = function(e) {
      showNotification(paste("Error reading genotype files:", e$message), type = "error")
      return(NULL)
    })
  })
  
  # Render column tags
  output$column_tags_ui <- renderUI({
    if (is.null(pheno_data())) {
      return(
        div(
          style = "text-align: center; padding: 40px; color: #6c757d;",
          div(style = "font-size: 48px; margin-bottom: 15px;", "📊"),
          h5("No data uploaded", style = "color: #6c757d; margin-bottom: 10px;"),
          p("Please upload a CSV file to see available variables", style = "margin: 0;")
        )
      )
    }
    
    column_names <- colnames(pheno_data())
    
    # Create draggable column tags using rank_list
    tagList(
      div(
        style = "display: flex; align-items: center; margin-bottom: 15px;",
        div(
          style = "width: 12px; height: 12px; background-color: #28a745; border-radius: 50%; margin-right: 10px;"
        ),
        p("Drag variables to model boxes below", style = "margin: 0; color: #6c757d; font-size: 14px;")
      ),
      div(
        style = "min-height: 60px; background-color: #f8f9fa; border: 1px solid #e9ecef; border-radius: 8px; padding: 10px;",
        sortable::rank_list(
          text = "Available Variables",
          labels = column_names,
          input_id = "available_vars",
          options = sortable::sortable_options(
            group = list(
              name = "shared_group",
              pull = "clone",
              put = FALSE
            )
          ),
          class = "default-sortable"
        )
      )
    )
  })
  
  # Generate parameter file preview - using reactive values
  output$param_preview <- renderText({
    cat("=== Parameter Preview Debug ===\n")
    
    if (is.null(pheno_data())) {
      cat("No phenotypic data available\n")
      return("Please upload a CSV file to generate parameter preview")
    }
    
    cat("Phenotypic data loaded successfully\n")
    
    # Get data file name
    data_file <- if (!is.null(input$pheno_file)) {
      basename(input$pheno_file$name)
    } else {
      "data.csv"
    }
    
    cat("Data file:", data_file, "\n")
    
    # Get column names from the data
    column_names <- colnames(pheno_data())
    cat("Column names:", paste(column_names, collapse = ", "), "\n")
    
    # Helper function to get column numbers
    get_column_numbers <- function(var_names) {
      if (is.null(var_names) || length(var_names) == 0) {
        return("")
      }
      col_indices <- which(column_names %in% var_names)
      return(paste(col_indices, collapse = " "))
    }
    
    # Create a simple parameter file template first
    param_content <- paste0(
      "DATAFILE\n",
      data_file, "\n\n",
      "TRAITS\n",
      "# Add trait column numbers here\n",
      "FIELDS_PASSED_TO_OUTPUT\n", 
      "# Add field numbers to output\n",
      "WEIGHT(S)\n",
      "# Add weight column if applicable\n\n",
      "EFFECTS\n",
      "# Add fixed effect column numbers here\n",
      "# Add animal ID column number here\n",
      "# Add other random effect column numbers here\n",
      "\nRANDOM\n",
      "# Add random effects here (e.g., animal)\n",
      "\nOPTION solv_method FSPAK\n",
      "OPTION missing -999\n",
      "OPTION maxrounds 500\n",
      "OPTION conv_crit 1e-6\n"
    )
    
    cat("Basic template created\n")
    
    # Get variables from reactive values
    traits <- traits_vars()
    fixed_effects <- fixed_effects_vars()
    animal_id <- animal_vars()
    random_effects <- random_effects_vars()
    
    # Debug: print current variables
    cat("Current variables:\n")
    cat("traits:", paste(traits, collapse = ", "), "\n")
    cat("fixed_effects:", paste(fixed_effects, collapse = ", "), "\n")
    cat("animal_id:", paste(animal_id, collapse = ", "), "\n")
    cat("random_effects:", paste(random_effects, collapse = ", "), "\n")
    
    # Check if genotype data is available
    has_genotype <- !is.null(geno_data())
    
    # Build parameter content with dynamic variables
    param_content <- paste0(
      "# PARAMETER FILE for renumf90\n",
      "# \n",
      "DATAFILE\n",
      data_file, "\n",
      "SKIP_HEADER\n",
      "1\n",
      "\n",
      
      "TRAITS # 这里指定traits的列\n",
      if (length(traits) > 0) {
        paste(get_column_numbers(traits), "\n")
      } else {
        "# Add trait column numbers here\n"
      },
      "\n",
      
      "FIELDS_PASSED TO OUTPUT\n",
      "\n",
      "WEIGHT(S)\n",
      "\n",
      "RESIDUAL_COVARIANCE\n",
      "1\n",
      "\n"
    )
    
    # Add fixed effects
    if (length(fixed_effects) > 0) {
      for (eff in fixed_effects) {
        param_content <- paste0(param_content, 
          "EFFECT\n", 
          get_column_numbers(eff), 
          " cross alpha # 这里指定", eff, "固定效应\n"
        )
      }
      param_content <- paste0(param_content, "\n")
    } else {
      param_content <- paste0(param_content, "# Add fixed effects here\n\n")
    }
    
    # Add random effects (other than animal)
    if (length(random_effects) > 0) {
      param_content <- paste0(param_content, 
        "RANDOM\n",
        "diagonal # 这里之前到固定效应之后是用来指定随机1效应的\n"
      )
      for (eff in random_effects) {
        param_content <- paste0(param_content, 
          "EFFECT\n", 
          get_column_numbers(eff), 
          " cross alpha\n"
        )
      }
      param_content <- paste0(param_content, "\n")
    } else {
      param_content <- paste0(param_content, "# Add other random effects here\n\n")
    }
    
    # Add animal random effect
    if (length(animal_id) > 0) {
      param_content <- paste0(param_content,
        "RANDOM\n",
        "animal # 这里是指定动物本身为随机效应\n",
        "FILE\n",
        "pedigree.txt\n",
        "FILE_POS\n",
        get_column_numbers(animal_id), " # 这里指定系谱文件\n\n"
      )
    } else {
      param_content <- paste0(param_content, "# Add animal random effect here\n\n")
    }
    
    # Add genotype file if available
    if (has_genotype) {
      param_content <- paste0(param_content,
        "PLINK_FILE\n",
        "genotype.txt # 这里指定基因型文件名\n",
        "PED_DEPTH\n",
        "0\n\n"
      )
    }
    
    # Add final options
    param_content <- paste0(
      param_content,
      "(CO)VARIANCES\n",
      "1\n",
      "\n",
      
      "OPTION remove_all_missing\n",
      "OPTION method VCE\n",
      "OPTION AlphaBeta 0.95 0.05\n",
      "OPTION maxrounds 1000000\n",
      "OPTION missing -999\n",
      "OPTION sol se\n",
      "OPTION conv_crit 1d-12\n",
      "OPTION EM-REML 100\n",
      if (has_genotype) "OPTION use-yams\n" else "",
      "OPTION tunedG2\n",
      "OPTION se_covar_function h2 G_4_4_1_1/(G_4_4_1_1+R_1_1)\n"
    )
    
    cat("Parameter content generated successfully\n")
    return(param_content)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
