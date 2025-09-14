# easyblup: Minimal working version with drag and drop
# Focus on core functionality with drag interaction and resizable panels

library(shiny)
library(sortable)
library(shinyjqui)

# Define UI
ui <- fluidPage(
  title = "easyblup - Minimal Version",
  
  # Add custom CSS and JavaScript for dynamic resizing
  tags$head(
    tags$style(HTML("
      /* Purdue Black and Gold Color Scheme */
      :root {
        --purdue-black: #000000;
        --purdue-gold: #CFB991;
        --purdue-dark-gold: #B8860B;
        --purdue-light-gold: #F5E6A3;
        --purdue-gray: #6C757D;
        --purdue-light-gray: #F8F9FA;
        --purdue-dark-gray: #343A40;
        --purdue-accent: #1A1A1A;
      }
      
      /* Global body styling */
      body {
        background-color: #fafafa;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        color: var(--purdue-dark-gray);
      }
      
      .resizable-panel {
        position: relative;
        background-color: white;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      }
      
      .resizable-panel .ui-resizable-handle {
        background: var(--purdue-gold);
        border: 1px solid var(--purdue-dark-gold);
        border-radius: 3px;
      }
      
      .resizable-panel .ui-resizable-s {
        height: 8px;
        bottom: 0;
        cursor: ns-resize;
      }
      
      /* Compact variable tags */
      .variable-tag {
        display: inline-block;
        background-color: var(--purdue-light-gray);
        border: 1px solid var(--purdue-gray);
        border-radius: 20px;
        padding: 6px 14px;
        margin: 3px;
        font-size: 12px;
        font-weight: 500;
        cursor: move;
        transition: all 0.3s ease;
        color: var(--purdue-dark-gray);
      }
      
      .variable-tag:hover {
        background-color: var(--purdue-gold);
        color: var(--purdue-black);
        transform: scale(1.05);
        box-shadow: 0 2px 6px rgba(207, 185, 145, 0.3);
      }
      
      .variable-tag.selected {
        background-color: var(--purdue-dark-gold);
        color: white;
        box-shadow: 0 2px 6px rgba(184, 134, 11, 0.4);
      }
      
      /* Compact drop zone items */
      .drop-zone-item {
        display: inline-block;
        background-color: var(--purdue-light-gold);
        border: 1px solid var(--purdue-gold);
        border-radius: 20px;
        padding: 6px 14px;
        margin: 3px;
        font-size: 12px;
        font-weight: 500;
        cursor: move;
        transition: all 0.3s ease;
        color: var(--purdue-black);
      }
      
      .drop-zone-item:hover {
        background-color: var(--purdue-gold);
        transform: scale(1.05);
        box-shadow: 0 2px 6px rgba(207, 185, 145, 0.3);
      }
      
      /* Sortable lists styling */
      .sortable-list {
        min-height: 60px;
        padding: 5px;
        border: 2px dashed var(--purdue-gold);
        border-radius: 8px;
        background-color: var(--purdue-light-gray);
      }
      
      .sortable-list .sortable-item {
        display: inline-block;
        margin: 2px;
      }
      
      /* Style sortable items as compact rounded rectangles */
      .rank-list .rank-list-item {
        display: inline-block !important;
        background-color: var(--purdue-light-gold) !important;
        border: 1px solid var(--purdue-gold) !important;
        border-radius: 20px !important;
        padding: 6px 14px !important;
        margin: 3px !important;
        font-size: 12px !important;
        font-weight: 500 !important;
        cursor: move !important;
        transition: all 0.3s ease !important;
        white-space: nowrap !important;
        color: var(--purdue-black) !important;
      }
      
      .rank-list .rank-list-item:hover {
        background-color: var(--purdue-gold) !important;
        color: var(--purdue-black) !important;
        transform: scale(1.05) !important;
        box-shadow: 0 2px 6px rgba(207, 185, 145, 0.3) !important;
      }
      
      /* Style drop zone items differently */
      #traits_list_container .rank-list-item,
      #fixed_list_container .rank-list-item,
      #animal_list_container .rank-list-item,
      #random_list_container .rank-list-item {
        background-color: var(--purdue-light-gold) !important;
        border: 1px solid var(--purdue-gold) !important;
        border-radius: 20px !important;
        padding: 6px 14px !important;
        font-size: 12px !important;
        font-weight: 500 !important;
        position: relative !important;
        color: var(--purdue-black) !important;
      }
      
      #traits_list_container .rank-list-item:hover,
      #fixed_list_container .rank-list-item:hover,
      #animal_list_container .rank-list-item:hover,
      #random_list_container .rank-list-item:hover {
        background-color: var(--purdue-gold) !important;
        transform: scale(1.05) !important;
        box-shadow: 0 2px 6px rgba(207, 185, 145, 0.3) !important;
      }
      
      /* Add delete button styling */
      .rank-list-item .delete-btn {
        position: absolute !important;
        top: -5px !important;
        right: -5px !important;
        background-color: #dc3545 !important;
        color: white !important;
        border: none !important;
        border-radius: 50% !important;
        width: 16px !important;
        height: 16px !important;
        font-size: 10px !important;
        cursor: pointer !important;
        display: none !important;
        z-index: 10 !important;
      }
      
      .rank-list-item:hover .delete-btn {
        display: block !important;
      }
      
      /* Well panels styling */
      .well {
        background: linear-gradient(135deg, white 0%, #F8F9FA 100%);
        border: 2px solid #CFB991;
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 20px;
        box-shadow: 0 4px 12px rgba(207, 185, 145, 0.15);
      }
      
      /* Section headers */
      h3 {
        color: #000000;
        font-weight: 700;
        margin-bottom: 15px;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        text-transform: uppercase;
        letter-spacing: 1px;
        border-bottom: 2px solid #CFB991;
        padding-bottom: 8px;
        display: inline-block;
      }
      
      /* Drop zones */
      .drop-zone {
        min-height: 80px;
        border: 2px dashed #6C757D;
        border-radius: 12px;
        padding: 15px;
        margin: 8px 0;
        background-color: #F8F9FA;
        transition: all 0.3s ease;
        position: relative;
      }
      
      .drop-zone.drag-over {
        border-color: #CFB991;
        background-color: #F5E6A3;
        transform: scale(1.02);
        box-shadow: 0 4px 12px rgba(207, 185, 145, 0.2);
      }
      
      .drop-zone.traits {
        background: linear-gradient(135deg, #FFE4B3 0%, #FFD700 100%);
        border-color: #CFB991;
        box-shadow: 0 2px 8px rgba(255, 215, 0, 0.2);
      }
      
      .drop-zone.fixed {
        background: linear-gradient(135deg, #FFCCCC 0%, #FFB6C1 100%);
        border-color: #FF6B6B;
        box-shadow: 0 2px 8px rgba(255, 107, 107, 0.2);
      }
      
      .drop-zone.animal {
        background: linear-gradient(135deg, #D9EAD3 0%, #98FB98 100%);
        border-color: #28a745;
        box-shadow: 0 2px 8px rgba(40, 167, 69, 0.2);
      }
      
      .drop-zone.random {
        background: linear-gradient(135deg, #CCE5FF 0%, #87CEEB 100%);
        border-color: #007bff;
        box-shadow: 0 2px 8px rgba(0, 123, 255, 0.2);
      }
      
      /* Buttons */
      .btn {
        border-radius: 8px;
        font-weight: 600;
        transition: all 0.3s ease;
        text-transform: uppercase;
        letter-spacing: 0.5px;
      }
      
      .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(0,0,0,0.2);
      }
      
      .btn-success {
        background: linear-gradient(135deg, #CFB991 0%, #B8860B 100%);
        border: 2px solid #B8860B;
        color: #000000;
        font-weight: 700;
      }
      
      .btn-success:hover {
        background: linear-gradient(135deg, #B8860B 0%, #8B6914 100%);
        border-color: #8B6914;
        color: white;
      }
      
      .btn-primary {
        background: linear-gradient(135deg, #000000 0%, #1A1A1A 100%);
        border: 2px solid #000000;
        color: #CFB991;
      }
      
      .btn-primary:hover {
        background: linear-gradient(135deg, #1A1A1A 0%, #000000 100%);
        border-color: #1A1A1A;
        color: #F5E6A3;
      }
      
      /* File input styling */
      .form-control {
        border-radius: 8px;
        border: 2px solid #CFB991;
        transition: all 0.3s ease;
        background-color: white;
        font-weight: 500;
      }
      
      .form-control:focus {
        border-color: #B8860B;
        box-shadow: 0 0 0 0.3rem rgba(207, 185, 145, 0.25);
        background-color: #F5E6A3;
      }
      
      /* Parameter preview */
      .param-preview {
        font-family: 'Courier New', monospace;
        font-size: 11px;
        line-height: 1.4;
        background-color: #000000;
        color: #F5E6A3;
        border: 2px solid #CFB991;
        border-radius: 8px;
        padding: 20px;
        white-space: pre-wrap;
        max-height: 300px;
        overflow-y: auto;
        box-shadow: 0 4px 12px rgba(0,0,0,0.2);
      }
      
      /* Scrollable containers */
      .scrollable-container {
        max-height: 200px;
        overflow-y: auto;
        border: 1px solid #CFB991;
        border-radius: 8px;
        padding: 15px;
        background-color: white;
        box-shadow: inset 0 2px 4px rgba(0,0,0,0.1);
      }
      
      .scrollable-container::-webkit-scrollbar {
        width: 8px;
      }
      
      .scrollable-container::-webkit-scrollbar-track {
        background: #F8F9FA;
        border-radius: 4px;
      }
      
      .scrollable-container::-webkit-scrollbar-thumb {
        background: #CFB991;
        border-radius: 4px;
      }
      
      .scrollable-container::-webkit-scrollbar-thumb:hover {
        background: #B8860B;
      }
      
      /* Model formula styling */
      .model-formula {
        background: linear-gradient(135deg, #F8F9FA 0%, white 100%);
        border: 3px solid #CFB991;
        border-radius: 12px;
        padding: 25px;
        margin: 20px 0;
        text-align: center;
        font-family: 'Courier New', monospace;
        font-size: 20px;
        font-weight: bold;
        color: #000000;
        box-shadow: 0 4px 12px rgba(207, 185, 145, 0.2);
      }
      
      .model-explanation {
        background: linear-gradient(135deg, #F5E6A3 0%, #F8F9FA 100%);
        border: 2px solid #CFB991;
        border-radius: 8px;
        padding: 20px;
        margin: 15px 0;
        font-size: 14px;
        line-height: 1.6;
        color: #000000;
        box-shadow: 0 2px 8px rgba(207, 185, 145, 0.15);
      }
      
      .model-explanation strong {
        color: #000000;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
      }
      
      /* Modal styling */
      .modal-content {
        border: 3px solid #CFB991;
        border-radius: 12px;
        box-shadow: 0 8px 24px rgba(0,0,0,0.3);
      }
      
      .modal-header {
        background: linear-gradient(135deg, #000000 0%, #1A1A1A 100%);
        color: #CFB991;
        border-bottom: 2px solid #CFB991;
      }
      
      .modal-title {
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1px;
      }
      
      .modal-body {
        background-color: #F8F9FA;
        color: #000000;
        font-weight: 500;
      }
      
      .modal-footer {
        background-color: #F8F9FA;
        border-top: 2px solid #CFB991;
      }
    ")),
    tags$script(HTML("
      $(document).ready(function() {
        // Make sure content areas resize with their containers
        $('.resizable-panel').on('resize', function() {
          var container = $(this).find('[id$=\"_container\"]');
          if (container.length) {
            container.css('height', 'calc(100% - 60px)');
          }
        });
        
        // Add double-click to delete functionality
        $(document).on('dblclick', '.rank-list-item', function() {
          var itemText = $(this).text().trim();
          var container = $(this).closest('[id$=\"_container\"]');
          var containerId = container.attr('id');
          
          // Determine the type based on container ID
          var type = '';
          if (containerId.includes('traits')) type = 'traits';
          else if (containerId.includes('fixed')) type = 'fixed';
          else if (containerId.includes('animal')) type = 'animal';
          else if (containerId.includes('random')) type = 'random';
          
          if (type) {
            Shiny.setInputValue('remove_var', {
              var: itemText,
              type: type
            }, {priority: 'event'});
          }
        });
      });
      
      // Handle text download
      Shiny.addCustomMessageHandler('download_text', function(message) {
        // Create a blob with the text content
        var blob = new Blob([message.content], { type: 'text/plain' });
        var url = window.URL.createObjectURL(blob);
        
        // Create a temporary link element
        var a = document.createElement('a');
        a.href = url;
        a.download = message.filename;
        document.body.appendChild(a);
        a.click();
        
        // Clean up
        document.body.removeChild(a);
        window.URL.revokeObjectURL(url);
      });
    "))
  ),
  
  # Header
  h1("easyblup: Parameter File Generator for BLUPF90", 
     style = "text-align: center; color: #000000; margin-bottom: 30px; font-weight: 700; text-shadow: 2px 2px 4px rgba(0,0,0,0.1); background: linear-gradient(135deg, #000000 0%, #CFB991 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;"),
  
  # Main layout
  fluidRow(
    # Left sidebar - File upload and parameter options
    column(3,
      jqui_resizable(
      wellPanel(
        h3("📁 Data Upload"),
        fileInput("pheno_file", "Upload Phenotype File", accept = c(".txt", ".dat", ".csv")),
        fileInput("ped_file", "Upload Pedigree File (Optional)", 
                 accept = c(".txt", ".ped")),
        fileInput("geno_file", "Upload Genotype Files (Optional)", 
                 accept = c(".ped", ".map"), multiple = TRUE),
        actionButton("clear_all", "Clear All", class = "btn-danger")
      ),
        options = list(
          minHeight = 200,
          maxHeight = 500,
          handles = "s"
        )
      ),
      
      # Parameter Options Panel
      jqui_resizable(
      wellPanel(
        h3("⚙️ Parameter Options"),
        div(style = "max-height: 300px; overflow-y: auto;",
          # Basic Options
          h5("Basic Options", style = "color: #B8860B; font-weight: bold; margin-top: 15px;"),
          checkboxInput("opt_remove_all_missing", "remove_all_missing", value = TRUE),
          checkboxInput("opt_missing_in_weights", "missing_in_weights", value = FALSE),
          checkboxInput("opt_no_basic_statistics", "no_basic_statistics", value = FALSE),
          
          # Missing Value Options
          h5("Missing Value Options", style = "color: #B8860B; font-weight: bold; margin-top: 15px;"),
          div(style = "display: flex; align-items: center; gap: 10px;",
            checkboxInput("opt_missing_custom", "Custom missing value:", value = FALSE),
            numericInput("opt_missing_value", "", value = -999, min = -9999, max = 9999, step = 1, width = "80px")
          ),
          
          # File Reading Options
          h5("File Reading Options", style = "color: #B8860B; font-weight: bold; margin-top: 15px;"),
          div(style = "display: flex; align-items: center; gap: 10px;",
            checkboxInput("opt_alpha_size", "Alpha size:", value = FALSE),
            numericInput("opt_alpha_size_value", "", value = 20, min = 1, max = 100, step = 1, width = "80px")
          ),
          div(style = "display: flex; align-items: center; gap: 10px;",
            checkboxInput("opt_max_string_readline", "Max string readline:", value = FALSE),
            numericInput("opt_max_string_readline_value", "", value = 800, min = 100, max = 10000, step = 100, width = "80px")
          ),
          div(style = "display: flex; align-items: center; gap: 10px;",
            checkboxInput("opt_max_field_readline", "Max field readline:", value = FALSE),
            numericInput("opt_max_field_readline_value", "", value = 100, min = 10, max = 1000, step = 10, width = "80px")
          ),
          
          # Inbreeding Method Options
          h5("Inbreeding Method", style = "color: #B8860B; font-weight: bold; margin-top: 15px;"),
          div(style = "display: flex; align-items: center; gap: 10px;",
            checkboxInput("opt_inbreeding_method", "Inbreeding method:", value = FALSE),
            selectInput("opt_inbreeding_method_value", "", 
                       choices = list(
                         "1: Meuwissen and Luo (1992)" = 1,
                         "2: Modified Meuwissen & Luo" = 2,
                         "3: Modified Colleau" = 3,
                         "4: Recursive tabular method" = 4,
                         "5: Method of Tier (1990)" = 5,
                         "6: Hybrid parallel computing" = 6,
                         "7: Recursive tabular with self-breeding" = 7
                       ), selected = 1, width = "200px")
          ),
          
          # Pedigree Search Options
          h5("Pedigree Search Options", style = "color: #B8860B; font-weight: bold; margin-top: 15px;"),
          checkboxInput("opt_ped_search_complete", "ped_search complete", value = FALSE),
          
          # Analysis Method Options
          h5("Analysis Method Options", style = "color: #B8860B; font-weight: bold; margin-top: 15px;"),
          checkboxInput("opt_method_vce", "method VCE", value = TRUE),
          checkboxInput("opt_sol_se", "sol se", value = TRUE),
          checkboxInput("opt_conv_crit", "conv_crit 1d-12", value = TRUE),
          checkboxInput("opt_em_reml", "EM-REML 100", value = TRUE),
          checkboxInput("opt_use_yams", "use-yams", value = TRUE),
          checkboxInput("opt_tuned_g2", "tunedG2", value = TRUE),
          checkboxInput("opt_maxrounds", "maxrounds 1000000", value = TRUE)
        )
      ),
        options = list(
          minHeight = 300,
          maxHeight = 600,
          handles = "s"
        )
      )
    ),
    
    # Right side - Variables and Model Definition
    column(9,
      # Top row: Variables and Model Definition side by side
      fluidRow(
        # Left side: Variables and Parameter Preview stacked
        column(6,
          # Variables (top half) - Resizable
          jqui_resizable(
            wellPanel(
              class = "resizable-panel",
              h3("📋 Available Variables"),
              p("Drag variables to model components:", style = "color: #666; font-size: 12px; margin-bottom: 10px;"),
              div(id = "variables_container", style = "height: calc(100% - 60px); overflow-y: auto; border: 1px solid #ddd; padding: 10px; background-color: #f9f9f9;",
                uiOutput("variable_list")
              )
            ),
            options = list(
              minHeight = 150,
              maxHeight = 400,
              handles = "s"
            )
          ),
          
          # Parameter preview (bottom half) - Resizable
          jqui_resizable(
            wellPanel(
              class = "resizable-panel",
              h3("📄 Parameter File Preview"),
              div(style = "margin-bottom: 10px;",
                actionButton("download_param", "📥 Download Parameter File", 
                           class = "btn btn-success btn-sm")
              ),
              div(id = "param_container", style = "height: calc(100% - 100px); overflow-y: auto; border: 1px solid #ddd; padding: 10px; background-color: #f9f9f9;",
                verbatimTextOutput("param_output")
              )
            ),
            options = list(
              minHeight = 150,
              maxHeight = 400,
              handles = "s"
            )
          )
        ),
        
        # Model Definition (right half) - Resizable
        column(6,
          jqui_resizable(
            wellPanel(
              class = "resizable-panel",
              h3("📐 Model Definition"),
            p("💡 Double-click any variable to remove it", style = "color: #666; font-size: 11px; margin-bottom: 5px; font-style: italic;"),
            p("🔍 Effect types auto-detected: cov (>20 levels OR unique/n > 0.05), cross (≤20 levels OR character)", style = "color: #666; font-size: 10px; margin-bottom: 10px; font-style: italic;"),
              div(id = "model_container", style = "height: calc(100% - 60px); overflow-y: auto;",
                # Traits
                div(style = "border: 2px dashed #ffa500; padding: 10px; margin: 5px 0; background-color: #fff8e1; min-height: 80px;",
                  h5("🧬 Traits (y)", style = "margin: 0 0 5px 0; font-size: 14px;"),
                  uiOutput("traits_drop_zone")
                ),
                
                # Fixed Effects
                div(style = "border: 2px dashed #ff6b6b; padding: 10px; margin: 5px 0; background-color: #ffebee; min-height: 80px;",
                  h5("📊 Fixed Effects (b)", style = "margin: 0 0 5px 0; font-size: 14px;"),
                  uiOutput("fixed_drop_zone")
                ),
                
                # Animal ID
                div(style = "border: 2px dashed #28a745; padding: 10px; margin: 5px 0; background-color: #e8f5e8; min-height: 80px;",
                  h5("🐄 Animal ID (a)", style = "margin: 0 0 5px 0; font-size: 14px;"),
                  uiOutput("animal_drop_zone")
                ),
                
                # Random Effects
                div(style = "border: 2px dashed #007bff; padding: 10px; margin: 5px 0; background-color: #e3f2fd; min-height: 80px;",
                  h5("🎲 Random Effects (r)", style = "margin: 0 0 5px 0; font-size: 14px;"),
                  uiOutput("random_drop_zone")
                )
              )
            ),
            options = list(
              minHeight = 300,
              maxHeight = 600,
              handles = "s"
            )
          )
        )
      )
    )
  )
)

# Define server
server <- function(input, output, session) {
  
  # Set file size limit
  options(shiny.maxRequestSize = 10 * 1024^3)
  
  # Reactive values for selected variables
  values <- reactiveValues(
    traits = c(),
    fixed = c(),
    animal = c(),
    random = c()
  )
  
  # Read data
  data <- reactive({
    req(input$pheno_file)
    # Try to detect file type and read accordingly
    file_ext <- tolower(tools::file_ext(input$pheno_file$name))
    if (file_ext == "csv") {
      read.csv(input$pheno_file$datapath, stringsAsFactors = FALSE)
    } else {
      # For .txt and .dat files, use space as separator
      read.table(input$pheno_file$datapath, header = TRUE, sep = "", stringsAsFactors = FALSE)
    }
  })
  
  # Display variables as draggable items
  output$variable_list <- renderUI({
    if (is.null(data())) {
      return(p("Upload a phenotype file to see variables"))
    }
    
    vars <- colnames(data())
    
    # Create draggable list with custom styling
    sortable::rank_list(
      text = "Available Variables",
      labels = vars,
      input_id = "available_vars",
      options = sortable::sortable_options(
        group = list(
          name = "shared_group",
          pull = "clone",
          put = FALSE
        )
      ),
      css_id = "available_vars_list"
    )
  })
  
  # Handle variable clicks
  observeEvent(input$var_clicked, {
    var <- input$var_clicked
    
    showModal(
      modalDialog(
        title = paste("Add", var, "to:"),
        easyClose = TRUE,
        footer = tagList(
          modalButton("Cancel"),
          actionButton("to_traits", "Traits", class = "btn-warning"),
          actionButton("to_fixed", "Fixed Effects", class = "btn-danger"),
          actionButton("to_animal", "Animal ID", class = "btn-success"),
          actionButton("to_random", "Random Effects", class = "btn-info")
        )
      )
    )
    
    session$userData$current_var <- var
  })
  
  # Add to traits
  observeEvent(input$to_traits, {
    var <- session$userData$current_var
    if (!var %in% values$traits) {
      values$traits <- c(values$traits, var)
    }
    removeModal()
  })
  
  # Add to fixed
  observeEvent(input$to_fixed, {
    var <- session$userData$current_var
    if (!var %in% values$fixed) {
      values$fixed <- c(values$fixed, var)
    }
    removeModal()
  })
  
  # Add to animal
  observeEvent(input$to_animal, {
    var <- session$userData$current_var
    if (!var %in% values$animal) {
      values$animal <- c(values$animal, var)
    }
    removeModal()
  })
  
  # Add to random
  observeEvent(input$to_random, {
    var <- session$userData$current_var
    if (!var %in% values$random) {
      values$random <- c(values$random, var)
    }
    removeModal()
  })
  
  # Create drop zones for each model component
  output$traits_drop_zone <- renderUI({
    sortable::rank_list(
      text = "Drag traits here",
      labels = values$traits,
      input_id = "traits_list",
      options = sortable::sortable_options(
        group = list(
          name = "shared_group",
          pull = TRUE,
          put = TRUE
        )
      ),
      css_id = "traits_list_container"
    )
  })
  
  output$fixed_drop_zone <- renderUI({
    sortable::rank_list(
      text = "Drag fixed effects here",
      labels = values$fixed,
      input_id = "fixed_list",
      options = sortable::sortable_options(
        group = list(
          name = "shared_group",
          pull = TRUE,
          put = TRUE
        )
      ),
      css_id = "fixed_list_container"
    )
  })
  
  output$animal_drop_zone <- renderUI({
    sortable::rank_list(
      text = "Drag animal ID here",
      labels = values$animal,
      input_id = "animal_list",
      options = sortable::sortable_options(
        group = list(
          name = "shared_group",
          pull = TRUE,
          put = TRUE
        )
      ),
      css_id = "animal_list_container"
    )
  })
  
  output$random_drop_zone <- renderUI({
    sortable::rank_list(
      text = "Drag random effects here",
      labels = values$random,
      input_id = "random_list",
      options = sortable::sortable_options(
        group = list(
          name = "shared_group",
          pull = TRUE,
          put = TRUE
        )
      ),
      css_id = "random_list_container"
    )
  })
  
  # Handle drag and drop events
  observeEvent(input$traits_list, {
    values$traits <- input$traits_list
  })
  
  observeEvent(input$fixed_list, {
    values$fixed <- input$fixed_list
  })
  
  observeEvent(input$animal_list, {
    values$animal <- input$animal_list
  })
  
  observeEvent(input$random_list, {
    values$random <- input$random_list
  })
  
  # Handle removal (keep for backward compatibility)
  observeEvent(input$remove_var, {
    var <- input$remove_var$var
    type <- input$remove_var$type
    
    if (type == "traits") {
      values$traits <- values$traits[values$traits != var]
    } else if (type == "fixed") {
      values$fixed <- values$fixed[values$fixed != var]
    } else if (type == "animal") {
      values$animal <- values$animal[values$animal != var]
    } else if (type == "random") {
      values$random <- values$random[values$random != var]
    }
  })
  
  # Clear all
  observeEvent(input$clear_all, {
    values$traits <- c()
    values$fixed <- c()
    values$animal <- c()
    values$random <- c()
  })
  
  # Helper function to generate covariance matrix
  generate_covariance_matrix <- function(n_traits) {
    if (n_traits <= 0) {
      return("0.1")
    }
    
    # Generate matrix values
    # For single trait: 0.1
    # For two traits: 0.1 0.1\n0.1 0.1 (2x2 matrix)
    # For three traits: 0.1 0.1 0.1\n0.1 0.1 0.1\n0.1 0.1 0.1 (3x3 matrix)
    
    if (n_traits == 1) {
      return("0.1")
    } else {
      # Generate matrix rows
      matrix_rows <- c()
      for (i in 1:n_traits) {
        row_values <- rep("0.1", n_traits)
        matrix_rows <- c(matrix_rows, paste(row_values, collapse = " "))
      }
      return(paste(matrix_rows, collapse = "\n"))
    }
  }
  
  # Helper function to generate heritability and genetic correlation functions
  generate_heritability_function <- function(traits, animal, random, fixed) {
    if (length(traits) == 0) {
      return("")
    }
    
    # Calculate effect numbers
    n_traits <- length(traits)
    n_fixed <- length(fixed)
    n_random <- length(random)
    n_animal <- length(animal)
    
    # Effect numbering starts from 1
    # Fixed effects: 1 to n_fixed
    # Random effects: n_fixed + 1 to n_fixed + n_random  
    # Animal effect: n_fixed + n_random + 1
    
    animal_effect_num <- n_fixed + n_random + 1
    
    # Generate heritability functions for each trait
    h2_functions <- c()
    
    for (i in 1:n_traits) {
      # Genetic variance: G_effect_effect_trait_trait
      genetic_var <- paste0("G_", animal_effect_num, "_", animal_effect_num, "_", i, "_", i)
      
      # Residual variance: R_trait_trait
      residual_var <- paste0("R_", i, "_", i)
      
      # Heritability formula: h2 = genetic_var / (genetic_var + residual_var)
      h2_formula <- paste0("h2_", i, " ", genetic_var, "/(", genetic_var, "+", residual_var, ")")
      
      h2_functions <- c(h2_functions, paste0("OPTION se_covar_function ", h2_formula))
    }
    
    # Generate genetic correlation functions for all trait pairs
    if (n_traits > 1) {
      for (i in 1:(n_traits-1)) {
        for (j in (i+1):n_traits) {
          # Genetic covariance between traits i and j
          genetic_cov <- paste0("G_", animal_effect_num, "_", animal_effect_num, "_", i, "_", j)
          
          # Residual covariance between traits i and j
          residual_cov <- paste0("R_", i, "_", j)
          
          # Genetic variances
          genetic_var_i <- paste0("G_", animal_effect_num, "_", animal_effect_num, "_", i, "_", i)
          genetic_var_j <- paste0("G_", animal_effect_num, "_", animal_effect_num, "_", j, "_", j)
          
          # Residual variances
          residual_var_i <- paste0("R_", i, "_", i)
          residual_var_j <- paste0("R_", j, "_", j)
          
          # Genetic correlation formula: rp_ij = (G_ij + R_ij) / sqrt((G_ii + R_ii) * (G_jj + R_jj))
          rp_formula <- paste0("rp_", i, j, " (", genetic_cov, "+", residual_cov, ")/((", 
                              genetic_var_i, "+", residual_var_i, ")*(", 
                              genetic_var_j, "+", residual_var_j, "))**0.5")
          
          h2_functions <- c(h2_functions, paste0("OPTION se_covar_function ", rp_formula))
        }
      }
    }
    
    return(paste(h2_functions, collapse = "\n"))
  }
  
  # Generate parameter file
  output$param_output <- renderText({
    if (is.null(data())) {
      return("Please upload a phenotype file first")
    }
    
    # Get column numbers
    get_col_num <- function(vars) {
      if (length(vars) == 0) return("")
      cols <- which(colnames(data()) %in% vars)
      return(paste(cols, collapse = " "))
    }
    
    # Check pedigree and genotype files
    has_ped <- !is.null(input$ped_file) && nrow(input$ped_file) > 0
    has_geno <- !is.null(input$geno_file) && nrow(input$geno_file) > 0
    
    # Build parameter file
    param <- paste0(
      "# PARAMETER FILE for renumf90\n",
      "# \n",
      "DATAFILE\n",
      basename(input$pheno_file$name), "\n",
      "SKIP_HEADER\n",
      "1\n",
      "\n",
      
      "TRAITS # Specify trait columns\n",
      if (length(values$traits) > 0) get_col_num(values$traits) else "# Add trait column numbers here",
      "\n\n",
      
      "FIELDS_PASSED TO OUTPUT\n",
      "\n",
      "WEIGHT(S)\n",
      "\n",
      "RESIDUAL_COVARIANCE\n",
      generate_covariance_matrix(length(values$traits)), "\n",
      "\n"
    )
    
    # Fixed effects
    if (length(values$fixed) > 0) {
      for (eff in values$fixed) {
        # Determine effect type based on data characteristics
        col_data <- data()[[eff]]
        n_unique <- length(unique(col_data))
        n_total <- length(col_data)
        unique_ratio <- n_unique / n_total
        
        # Apply new criteria:
        # >20 levels OR unique/n > 0.05 → cov
        # ≤20 levels → cross
        # character → cross
        if (is.character(col_data)) {
          effect_type <- "cross"
        } else if (n_unique > 20 || unique_ratio > 0.05) {
          effect_type <- "cov"
        } else {
          effect_type <- "cross"
        }
        
        param <- paste0(param, 
          "EFFECT\n", 
          get_col_num(eff), 
          " ", effect_type, " alpha # ", eff, " fixed effect (", effect_type, ")\n"
        )
      }
      param <- paste0(param, "\n")
    } else {
      param <- paste0(param, "# Add fixed effects here\n\n")
    }
    
    # Random effects
    if (length(values$random) > 0) {
      # First add all EFFECT lines
      for (eff in values$random) {
        param <- paste0(param, 
          "EFFECT\n", 
          get_col_num(eff), 
          " cross alpha # ", eff, " random effect\n"
        )
      }
      # Then add RANDOM diagonal
      param <- paste0(param, 
        "RANDOM\n",
        "diagonal # Random effects section\n\n"
      )
    } else {
      param <- paste0(param, "# Add other random effects here\n\n")
    }
    
    # Animal effect
    if (length(values$animal) > 0) {
      param <- paste0(param,
        "EFFECT\n",
        get_col_num(values$animal), " cross alpha # Animal ID effect\n",
        "RANDOM\n",
        "animal # Animal random effect\n"
      )
      
      # Add pedigree file information if available
      if (has_ped) {
        param <- paste0(param,
          "FILE\n",
          basename(input$ped_file$name), "\n",
          "FILE_POS\n",
          "1 2 3 # Progeny Sire Dam\n\n"
        )
      } else {
        param <- paste0(param,
          "FILE\n",
          "pedigree.txt\n",
          "FILE_POS\n",
          "1 2 3 # Progeny Sire Dam\n\n"
        )
      }
    } else {
      param <- paste0(param, "# Add animal random effect here\n\n")
    }
    
    # Genotype
    if (has_geno) {
      param <- paste0(param,
        "PLINK_FILE\n",
        "genotype.txt # Genotype file name\n",
        "PED_DEPTH\n",
        "0\n\n"
      )
    }
    
    # Options
    param <- paste0(
      param,
      "(CO)VARIANCES\n",
      generate_covariance_matrix(length(values$traits)), "\n",
      "\n"
    )
    
    # Add user-selected OPTION parameters
    options <- c()
    
    # Basic options
    if (input$opt_remove_all_missing) options <- c(options, "OPTION remove_all_missing")
    if (input$opt_missing_in_weights) options <- c(options, "OPTION missing_in_weights")
    if (input$opt_no_basic_statistics) options <- c(options, "OPTION no_basic_statistics")
    
    # Missing value options
    if (input$opt_missing_custom) {
      options <- c(options, paste0("OPTION missing ", input$opt_missing_value))
    } else {
      options <- c(options, "OPTION missing -999")
    }
    
    # File reading options
    if (input$opt_alpha_size) {
      options <- c(options, paste0("OPTION alpha_size ", input$opt_alpha_size_value))
    }
    if (input$opt_max_string_readline) {
      options <- c(options, paste0("OPTION max_string_readline ", input$opt_max_string_readline_value))
    }
    if (input$opt_max_field_readline) {
      options <- c(options, paste0("OPTION max_field_readline ", input$opt_max_field_readline_value))
    }
    
    # Inbreeding method
    if (input$opt_inbreeding_method) {
      options <- c(options, paste0("OPTION inbreeding_method ", input$opt_inbreeding_method_value))
    }
    
    # Pedigree search
    if (input$opt_ped_search_complete) {
      options <- c(options, "OPTION ped_search complete")
    }
    
    # Analysis method options
    if (input$opt_method_vce) options <- c(options, "OPTION method VCE")
    if (input$opt_sol_se) options <- c(options, "OPTION sol se")
    if (input$opt_conv_crit) options <- c(options, "OPTION conv_crit 1d-12")
    if (input$opt_em_reml) options <- c(options, "OPTION EM-REML 100")
    if (input$opt_use_yams) options <- c(options, "OPTION use-yams")
    if (input$opt_tuned_g2) options <- c(options, "OPTION tunedG2")
    if (input$opt_maxrounds) options <- c(options, "OPTION maxrounds 1000000")
    
    # Genotype-specific options
    if (has_geno) {
      options <- c(options, "OPTION AlphaBeta 0.95 0.05")
    }
    
    # Add heritability functions
    heritability_options <- generate_heritability_function(values$traits, values$animal, values$random, values$fixed)
    if (heritability_options != "") {
      options <- c(options, heritability_options)
    }
    
    # Combine all options
    param <- paste0(param, paste(options, collapse = "\n"))
    
    return(param)
  })
  
  # Handle download button click
  observeEvent(input$download_param, {
    # Show confirmation dialog
    showModal(
      modalDialog(
        title = "Download Confirmation",
        p("Please carefully review the parameter file before using it."),
        p("Make sure all variables are correctly assigned to their respective model components."),
        p("Double-check the effect types (cov/cross) and column numbers."),
        p("Verify that the pedigree and genotype file names are correct if applicable."),
        p("This parameter file will be used for BLUPF90 analysis."),
        footer = tagList(
          modalButton("Cancel"),
          actionButton("confirm_download", "Confirm Download", class = "btn btn-success")
        )
      )
    )
  })
  
  # Handle download confirmation
  observeEvent(input$confirm_download, {
    removeModal()
    
    # Generate parameter content
    param_content <- generate_parameter_content()
    
    # Create and trigger download using JavaScript
    session$sendCustomMessage("download_text", list(
      content = param_content,
      filename = "easyblup.par"
    ))
  })
  
  # Helper function to generate parameter content
  generate_parameter_content <- function() {
    if (is.null(data())) {
      return("Please upload a phenotype file first")
    }
    
    # Get column numbers
    get_col_num <- function(vars) {
      if (length(vars) == 0) return("")
      cols <- which(colnames(data()) %in% vars)
      return(paste(cols, collapse = " "))
    }
    
    # Check pedigree and genotype files
    has_ped <- !is.null(input$ped_file) && nrow(input$ped_file) > 0
    has_geno <- !is.null(input$geno_file) && nrow(input$geno_file) > 0
    
    # Build parameter file
    param <- paste0(
      "# PARAMETER FILE for renumf90\n",
      "# \n",
      "DATAFILE\n",
      basename(input$pheno_file$name), "\n",
      "SKIP_HEADER\n",
      "1\n",
      "\n",
      
      "TRAITS # Specify trait columns\n",
      if (length(values$traits) > 0) get_col_num(values$traits) else "# Add trait column numbers here",
      "\n\n",
      
      "FIELDS_PASSED TO OUTPUT\n",
      "\n",
      "WEIGHT(S)\n",
      "\n",
      "RESIDUAL_COVARIANCE\n",
      generate_covariance_matrix(length(values$traits)), "\n",
      "\n"
    )
    
    # Fixed effects
    if (length(values$fixed) > 0) {
      for (eff in values$fixed) {
        # Determine effect type based on data characteristics
        col_data <- data()[[eff]]
        n_unique <- length(unique(col_data))
        n_total <- length(col_data)
        unique_ratio <- n_unique / n_total
        
        # Apply new criteria:
        # >20 levels OR unique/n > 0.05 → cov
        # ≤20 levels → cross
        # character → cross
        if (is.character(col_data)) {
          effect_type <- "cross"
        } else if (n_unique > 20 || unique_ratio > 0.05) {
          effect_type <- "cov"
        } else {
          effect_type <- "cross"
        }
        
        param <- paste0(param, 
          "EFFECT\n", 
          get_col_num(eff), 
          " ", effect_type, " alpha # ", eff, " fixed effect (", effect_type, ")\n"
        )
      }
      param <- paste0(param, "\n")
    } else {
      param <- paste0(param, "# Add fixed effects here\n\n")
    }
    
    # Random effects
    if (length(values$random) > 0) {
      # First add all EFFECT lines
      for (eff in values$random) {
        param <- paste0(param, 
          "EFFECT\n", 
          get_col_num(eff), 
          " cross alpha # ", eff, " random effect\n"
        )
      }
      # Then add RANDOM diagonal
      param <- paste0(param, 
        "RANDOM\n",
        "diagonal # Random effects section\n\n"
      )
    } else {
      param <- paste0(param, "# Add other random effects here\n\n")
    }
    
    # Animal effect
    if (length(values$animal) > 0) {
      param <- paste0(param,
        "EFFECT\n",
        get_col_num(values$animal), " cross alpha # Animal ID effect\n",
        "RANDOM\n",
        "animal # Animal random effect\n"
      )
      
      # Add pedigree file information if available
      if (has_ped) {
        param <- paste0(param,
          "FILE\n",
          basename(input$ped_file$name), "\n",
          "FILE_POS\n",
          "1 2 3 # Progeny Sire Dam\n\n"
        )
      } else {
        param <- paste0(param,
          "FILE\n",
          "pedigree.txt\n",
          "FILE_POS\n",
          "1 2 3 # Progeny Sire Dam\n\n"
        )
      }
    } else {
      param <- paste0(param, "# Add animal random effect here\n\n")
    }
    
    # Genotype
    if (has_geno) {
      param <- paste0(param,
        "PLINK_FILE\n",
        "genotype.txt # Genotype file name\n",
        "PED_DEPTH\n",
        "0\n\n"
      )
    }
    
    # Options
    param <- paste0(
      param,
      "(CO)VARIANCES\n",
      generate_covariance_matrix(length(values$traits)), "\n",
      "\n"
    )
    
    # Add user-selected OPTION parameters
    options <- c()
    
    # Basic options
    if (input$opt_remove_all_missing) options <- c(options, "OPTION remove_all_missing")
    if (input$opt_missing_in_weights) options <- c(options, "OPTION missing_in_weights")
    if (input$opt_no_basic_statistics) options <- c(options, "OPTION no_basic_statistics")
    
    # Missing value options
    if (input$opt_missing_custom) {
      options <- c(options, paste0("OPTION missing ", input$opt_missing_value))
    } else {
      options <- c(options, "OPTION missing -999")
    }
    
    # File reading options
    if (input$opt_alpha_size) {
      options <- c(options, paste0("OPTION alpha_size ", input$opt_alpha_size_value))
    }
    if (input$opt_max_string_readline) {
      options <- c(options, paste0("OPTION max_string_readline ", input$opt_max_string_readline_value))
    }
    if (input$opt_max_field_readline) {
      options <- c(options, paste0("OPTION max_field_readline ", input$opt_max_field_readline_value))
    }
    
    # Inbreeding method
    if (input$opt_inbreeding_method) {
      options <- c(options, paste0("OPTION inbreeding_method ", input$opt_inbreeding_method_value))
    }
    
    # Pedigree search
    if (input$opt_ped_search_complete) {
      options <- c(options, "OPTION ped_search complete")
    }
    
    # Analysis method options
    if (input$opt_method_vce) options <- c(options, "OPTION method VCE")
    if (input$opt_sol_se) options <- c(options, "OPTION sol se")
    if (input$opt_conv_crit) options <- c(options, "OPTION conv_crit 1d-12")
    if (input$opt_em_reml) options <- c(options, "OPTION EM-REML 100")
    if (input$opt_use_yams) options <- c(options, "OPTION use-yams")
    if (input$opt_tuned_g2) options <- c(options, "OPTION tunedG2")
    if (input$opt_maxrounds) options <- c(options, "OPTION maxrounds 1000000")
    
    # Genotype-specific options
    if (has_geno) {
      options <- c(options, "OPTION AlphaBeta 0.95 0.05")
    }
    
    # Add heritability functions
    heritability_options <- generate_heritability_function(values$traits, values$animal, values$random, values$fixed)
    if (heritability_options != "") {
      options <- c(options, heritability_options)
    }
    
    # Combine all options
    param <- paste0(param, paste(options, collapse = "\n"))
    
    return(param)
  }
}

# Run app
shinyApp(ui = ui, server = server)
