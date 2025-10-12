# easyblup: Minimal working version with drag and drop
# Focus on core functionality with drag interaction and resizable panels

library(shiny)
library(sortable)

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
      
      // Handle getting textarea content
      Shiny.addCustomMessageHandler('get_textarea_content', function(message) {
        var content = document.getElementById('param_editor').value;
        Shiny.setInputValue('textarea_content', content);
      });
      
      // Handle updating textarea content
      Shiny.addCustomMessageHandler('update_textarea', function(message) {
        document.getElementById('param_editor').value = message.content;
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
      wellPanel(
        class = "resizable-panel",
        h3("📁 Data Upload"),
        fileInput("pheno_file", "Upload Phenotype File", accept = c(".txt", ".dat", ".csv")),
        fileInput("ped_file", "Upload Pedigree File (Optional)", 
                 accept = c(".txt", ".ped")),
        fileInput("geno_file", "Upload Genotype Files (Optional) - PLINK .ped/.map format only", 
                 accept = c(".ped", ".map"), multiple = TRUE),
        actionButton("clear_all", "Clear All", class = "btn-danger")
      ),
      
      # Parameter Options Panel
      wellPanel(
        class = "resizable-panel",
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
          checkboxInput("opt_maxrounds", "maxrounds 1000000", value = TRUE),
          
          # Solution Output Options
          h5("Solution Output Options", style = "color: #B8860B; font-weight: bold; margin-top: 15px;"),
          checkboxInput("opt_origID", "origID - Store solutions with original ID", value = FALSE),
          
          # Accuracy and Reliability Options
          h5("Accuracy & Reliability Options", style = "color: #B8860B; font-weight: bold; margin-top: 15px;"),
          div(style = "display: flex; align-items: center; gap: 10px;",
            checkboxInput("opt_store_accuracy", "store_accuracy:", value = FALSE),
            numericInput("opt_store_accuracy_eff", "Effect # (Auto-calculates for animal)", value = 1, min = 1, max = 20, step = 1, width = "120px")
          ),
          p("💡 Effect number auto-updates based on model structure (Fixed + Random + 1)", 
            style = "color: #666; font-size: 11px; margin: 5px 0; font-style: italic;"),
          checkboxInput("opt_store_accuracy_orig", "store_accuracy with original ID", value = FALSE),
          div(style = "display: flex; align-items: center; gap: 10px;",
            checkboxInput("opt_acctype", "acctype:", value = FALSE),
            selectInput("opt_acctype_value", "", 
                       choices = list(
                         "1.0 (Dairy cattle - Reliability)" = "1.0",
                         "0.5 (Beef cattle - BIF accuracy)" = "0.5"
                       ), selected = "1.0", width = "200px")
          ),
          div(style = "display: flex; align-items: center; gap: 10px;",
            checkboxInput("opt_correct_accuracy_by_inbreeding", "correct_accuracy_by_inbreeding:", value = FALSE),
            textInput("opt_inbreeding_filename", "Filename", value = "renf90.inb", width = "120px")
          ),
          checkboxInput("opt_correct_accuracy_by_inbreeding_direct", "correct_accuracy_by_inbreeding_direct 0", value = FALSE),
          
          # REML Specific Options
          h5("REML Specific Options", style = "color: #B8860B; font-weight: bold; margin-top: 15px;"),
          div(style = "display: flex; align-items: center; gap: 10px;",
            checkboxInput("opt_conv_crit_custom", "Custom conv_crit:", value = FALSE),
            textInput("opt_conv_crit_value", "", value = "1d-12", width = "80px")
          ),
          div(style = "display: flex; align-items: center; gap: 10px;",
          checkboxInput("opt_maxrounds_custom", "Custom maxrounds:", value = FALSE),
          numericInput("opt_maxrounds_value", "", value = 1000, min = 0, max = 100000, step = 100, width = "100px")
        ),
        checkboxInput("opt_no_accelerate_EM", "no_accelerate_EM - Disable EM acceleration", value = FALSE)
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
          wellPanel(
            class = "resizable-panel",
            h3("📋 Available Variables"),
            p("Drag variables to model components:", style = "color: #666; font-size: 12px; margin-bottom: 10px;"),
            div(id = "variables_container", style = "height: calc(100% - 60px); overflow-y: auto; border: 1px solid #ddd; padding: 10px; background-color: #f9f9f9;",
              uiOutput("variable_list")
            )
          ),
          
          # Parameter preview (bottom half) - Resizable
          wellPanel(
            class = "resizable-panel",
            h3("📄 Parameter File Preview"),
            div(style = "margin-bottom: 10px; display: flex; gap: 10px;",
              actionButton("reset_param", "🔄 Reset to Default", 
                         class = "btn btn-success btn-sm",
                         style = "margin-right: 5px;"),
              actionButton("download_param", "📥 Download Parameter File", 
                         class = "btn btn-success btn-sm")
            ),
            p("✏️ You can directly edit the parameter file below", 
              style = "color: #666; font-size: 11px; margin: 5px 0; font-style: italic;"),
            div(id = "param_container", style = "height: calc(100% - 120px); overflow-y: auto;",
              tags$textarea(
                id = "param_editor",
                style = "width: 100%; height: 300px; font-family: 'Courier New', monospace; font-size: 12px; border: 1px solid #ddd; padding: 10px; background-color: #f9f9f9; resize: vertical;",
                placeholder = "Parameter file will appear here..."
              )
            )
          )
        ),
        
        # Model Definition (right half) - Resizable
        column(6,
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
              ),
              
              # Additional Effects Options
              div(style = "border: 2px dashed #9c27b0; padding: 10px; margin: 5px 0; background-color: #f3e5f5; min-height: 100px;",
                h5("➕ Additional Effects (Optional)", style = "margin: 0 0 10px 0; font-size: 14px; color: #9c27b0; font-weight: bold;"),
                div(style = "display: flex; flex-wrap: wrap; gap: 15px;",
                  div(
                    checkboxInput("opt_pe", "PE", value = FALSE),
                    p("Permanent Environmental", style = "font-size: 10px; margin: 0; color: #666;")
                  ),
                  div(
                    checkboxInput("opt_mat", "MAT", value = FALSE),
                    p("Maternal Effect", style = "font-size: 10px; margin: 0; color: #666;")
                  ),
                  div(
                    checkboxInput("opt_mpe", "MPE", value = FALSE),
                    p("Maternal Permanent Env.", style = "font-size: 10px; margin: 0; color: #666;")
                  )
                ),
                p("💡 These will add OPTIONAL effects to the animal model", style = "color: #666; font-size: 10px; margin: 5px 0 0 0; font-style: italic;")
              )
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
    random = c(),
    default_param = "",  # Store default generated parameter
    current_param = ""   # Store current (possibly edited) parameter
  )
  
  # Calculate animal effect number reactively
  animal_effect_number <- reactive({
    # Effect numbering in BLUPF90:
    # 1. Fixed effects (each fixed effect gets 1 number)
    # 2. Other random effects (each random effect gets 1 number) 
    # 3. Animal effect (gets 1 number)
    
    n_fixed <- length(values$fixed)
    n_random <- length(values$random)
    
    # Animal effect number = total fixed effects + total random effects + 1
    animal_effect_num <- n_fixed + n_random + 1
    
    return(animal_effect_num)
  })
  
  # Update animal effect number in store_accuracy input
  observe({
    animal_num <- animal_effect_number()
    updateNumericInput(session, "opt_store_accuracy_eff", 
                      value = animal_num,
                      label = paste0("Effect # (Animal effect: ", animal_num, ")"))
  })
  
  # Read data
  data <- reactive({
    req(input$pheno_file)
    
    # Try to detect file type and read accordingly
    file_ext <- tolower(tools::file_ext(input$pheno_file$name))
    
    # Validate file extension
    if (!file_ext %in% c("csv", "txt", "dat", "")) {
      showNotification(
        paste0("不支持的文件格式: .", file_ext, 
               "\n请上传 CSV、TXT 或 DAT 格式的表型数据文件"),
        type = "error",
        duration = 10
      )
      return(NULL)
    }
    
    # Try to read the file with error handling
    tryCatch({
      if (file_ext == "csv") {
        read.csv(input$pheno_file$datapath, stringsAsFactors = FALSE)
      } else {
        # For .txt and .dat files, use space as separator
        read.table(input$pheno_file$datapath, header = TRUE, sep = "", stringsAsFactors = FALSE)
      }
    }, error = function(e) {
      showNotification(
        paste0("读取文件失败: ", e$message, 
               "\n请确保文件格式正确且包含列名"),
        type = "error",
        duration = 10
      )
      return(NULL)
    })
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
    # For two traits: 1 0.01\n0.01 1 (2x2 matrix)
    # For three traits: 1 0.01 0.01\n0.01 1 0.01\n0.01 0.01 1 (3x3 matrix)
    
    if (n_traits == 1) {
      return("0.1")
    } else {
      # Generate matrix rows with diagonal = 1, off-diagonal = 0.01
      matrix_rows <- c()
      for (i in 1:n_traits) {
        row_values <- c()
        for (j in 1:n_traits) {
          if (i == j) {
            row_values <- c(row_values, "1")
          } else {
            row_values <- c(row_values, "0.01")
          }
        }
        matrix_rows <- c(matrix_rows, paste(row_values, collapse = " "))
      }
      return(paste(matrix_rows, collapse = "\n"))
    }
  }
  
  # Helpers to map selected variables to column indices
  get_col_num_int <- function(vars) {
    if (length(vars) == 0 || is.null(data())) return(integer(0))
    which(colnames(data()) %in% vars)
  }
  
  get_col_num <- function(vars) {
    cols <- get_col_num_int(vars)
    if (length(cols) == 0) return("")
    paste(cols, collapse = " ")
  }
  
  format_effect_cols <- function(vars, n_traits) {
    cols <- get_col_num_int(vars)
    if (length(cols) == 0 || n_traits == 0) return("")
    if (length(cols) == 1) {
      cols <- rep(cols, n_traits)
    } else if (length(cols) != n_traits) {
      cols <- rep(cols, length.out = n_traits)
    }
    paste(cols, collapse = " ")
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
    
    # Add comment for heritabilities
    if (n_traits > 0) {
      h2_functions <- c(h2_functions, "# Heritabilities (h²)")
    }
    
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
      h2_functions <- c(h2_functions, "", "# Genetic correlations (rg)")
      
      for (i in 1:(n_traits-1)) {
        for (j in (i+1):n_traits) {
          # Genetic covariance between traits i and j
          genetic_cov <- paste0("G_", animal_effect_num, "_", animal_effect_num, "_", i, "_", j)
          
          # Genetic variances
          genetic_var_i <- paste0("G_", animal_effect_num, "_", animal_effect_num, "_", i, "_", i)
          genetic_var_j <- paste0("G_", animal_effect_num, "_", animal_effect_num, "_", j, "_", j)
          
          # Genetic correlation formula: rg_ij = G_ij / sqrt(G_ii * G_jj)
          rg_formula <- paste0("rg_", i, j, " ", genetic_cov, "/((", genetic_var_i, "*", genetic_var_j, ")**0.5)")
          
          h2_functions <- c(h2_functions, paste0("OPTION se_covar_function ", rg_formula))
        }
      }
    }
    
    # Generate phenotypic correlation functions for all trait pairs
    if (n_traits > 1) {
      h2_functions <- c(h2_functions, "", "# Phenotypic correlations (rp)")
      
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
          
          # Phenotypic correlation formula: rp_ij = (G_ij + R_ij) / sqrt((G_ii + R_ii) * (G_jj + R_jj))
          rp_formula <- paste0("rp_", i, j, " (", genetic_cov, "+", residual_cov, ")/((", 
                              genetic_var_i, "+", residual_var_i, ")*(", 
                              genetic_var_j, "+", residual_var_j, "))**0.5")
          
          h2_functions <- c(h2_functions, paste0("OPTION se_covar_function ", rp_formula))
        }
      }
    }
    
    return(paste(h2_functions, collapse = "\n"))
  }
  
  # Generate and update parameter file in textarea
  observe({
    if (is.null(data())) {
      param_text <- "Please upload a phenotype file first"
    } else {
      # Check pedigree and genotype files
      has_ped <- !is.null(input$ped_file) && nrow(input$ped_file) > 0
      has_geno <- !is.null(input$geno_file) && nrow(input$geno_file) > 0
    
    
    # Build parameter file
    param_text <- paste0(
      "# PARAMETER FILE for renumf90\n",
      "# \n",
      "DATAFILE\n",
      basename(input$pheno_file$name), "\n",
      "SKIP_HEADER\n",
      "1\n",
      "TRAITS # Specify trait columns\n",
      if (length(values$traits) > 0) get_col_num(values$traits) else "# Add trait column numbers here",
      "\n",
      
      "FIELDS_PASSED TO OUTPUT\n",
      "\n",
      "WEIGHT(S)\n",
      "\n",
      "RESIDUAL_VARIANCE\n",
      generate_covariance_matrix(length(values$traits)), "\n"
    )
    
    # Fixed effects
    if (length(values$fixed) > 0) {
      for (eff in values$fixed) {
        # Determine effect type based on data characteristics
        col_data <- data()[[eff]]
        if (is.null(col_data) || length(col_data) == 0) {
          effect_type <- "cross"
        } else {
          n_unique <- length(unique(col_data))
          n_total <- length(col_data)
          unique_ratio <- if (n_total > 0) n_unique / n_total else 0
        
        # Apply new criteria:
        # >20 levels OR unique/n > 0.05 → cov
        # ≤20 levels → cross
        # character → cross
        if (is.character(col_data)) {
          effect_type <- "cross"
        } else if ((!is.na(n_unique) && n_unique > 20) || (!is.na(unique_ratio) && unique_ratio > 0.05)) {
          effect_type <- "cov"
        } else {
          effect_type <- "cross"
        }
        }
        
        # Repeat effect for each trait
        n_traits <- length(values$traits)
        effect_cols <- format_effect_cols(eff, n_traits)
        if (nzchar(effect_cols)) {
          param_text <- paste0(param_text,
            "EFFECT\n",
            effect_cols, " ", effect_type, " alpha # ", eff, " fixed effect (", effect_type, ") (trait order: 1, 2, ...)\n"
          )
        } else {
          param_text <- paste0(param_text,
            "EFFECT\n",
            "# Add column numbers for ", eff, " (one per trait)\n"
          )
        }
      }
    } else {
      param_text <- paste0(param_text, "# Add fixed effects here\n")
    }
    
    # Random effects
    if (length(values$random) > 0) {
      # First add all EFFECT lines
      for (eff in values$random) {
        # Repeat effect for each trait
        n_traits <- length(values$traits)
        effect_cols <- format_effect_cols(eff, n_traits)
        if (nzchar(effect_cols)) {
          param_text <- paste0(param_text,
            "EFFECT\n",
            effect_cols, " cross alpha # ", eff, " random effect (trait order: 1, 2, ...)\n"
          )
        } else {
          param_text <- paste0(param_text,
            "EFFECT\n",
            "# Add column numbers for ", eff, " random effect (one per trait)\n"
          )
        }
      }
      # Then add RANDOM diagonal
      param_text <- paste0(param_text, 
        "RANDOM\n",
        "diagonal # Random effects section\n"
      )
    } else {
      param_text <- paste0(param_text, "# Add other random effects here\n")
    }
    
    # Animal effect
    if (length(values$animal) > 0) {
      # Repeat animal effect for each trait
      n_traits <- length(values$traits)
      effect_cols <- format_effect_cols(values$animal, n_traits)
      if (nzchar(effect_cols)) {
        param_text <- paste0(param_text,
          "EFFECT\n",
          effect_cols, " cross alpha # Animal ID effect (trait order: 1, 2, ...)\n"
        )
      } else {
        param_text <- paste0(param_text,
          "EFFECT\n",
          "# Add column numbers for animal ID (one per trait)\n"
        )
      }
      param_text <- paste0(param_text,
        "RANDOM\n",
        "animal # Animal random effect\n"
      )
      
      # Add OPTIONAL effects if any are selected
      optional_effects <- c()
      if (input$opt_pe) optional_effects <- c(optional_effects, "pe")
      if (input$opt_mat) optional_effects <- c(optional_effects, "mat")
      if (input$opt_mpe) optional_effects <- c(optional_effects, "mpe")
      
      if (length(optional_effects) > 0) {
        param_text <- paste0(param_text,
          "OPTIONAL\n",
          paste(optional_effects, collapse = " "), " # ", 
          paste(c(
            if ("pe" %in% optional_effects) "Permanent environmental effect",
            if ("mat" %in% optional_effects) "maternal effect", 
            if ("mpe" %in% optional_effects) "maternal permanent environmental effect"
          ), collapse = ", "), "\n"
        )
      }
      
      # Add pedigree file information (always present)
      pedigree_filename <- if (has_ped) {
        basename(input$ped_file$name)
      } else {
        "pedigree.txt"
      }
      
      param_text <- paste0(param_text,
        "FILE\n",
        pedigree_filename, "\n",
        "FILE_POS\n",
        "1 2 3 # Progeny Sire Dam\n"
      )
    } else {
      param_text <- paste0(param_text, "# Add animal random effect here\n")
    }
    
    # Genotype (only if uploaded)
    if (has_geno) {
      # Get genotype file name without extension
      # Look for either .ped or .map files
      ped_files <- input$geno_file$name[grepl("\\.ped$", input$geno_file$name)]
      map_files <- input$geno_file$name[grepl("\\.map$", input$geno_file$name)]
      
      geno_filename <- if (length(ped_files) > 0) {
        tools::file_path_sans_ext(ped_files[1])
      } else if (length(map_files) > 0) {
        tools::file_path_sans_ext(map_files[1])
      } else {
        "genotype"
      }
      
      param_text <- paste0(param_text,
        "PLINK_FILE\n",
        geno_filename, " # Genotype file name\n",
        "PED_DEPTH\n",
        "0\n"
      )
    }
    
    # Options
    param_text <- paste0(
      param_text,
      "(CO)VARIANCES\n"
    )
    
    # Handle covariance matrix based on additional effects
    if (input$opt_mat) {
      # If maternal effect is selected, use 2x2 matrix
      param_text <- paste0(param_text, "1 0.01\n0.01 1\n")
    } else {
      # Without maternal effect, use single variance value
      param_text <- paste0(param_text, "1\n")
    }
    
    # Add PE covariance if selected
    if (input$opt_pe) {
      param_text <- paste0(param_text, 
        "(CO)VARIANCES_PE\n",
        "0.001\n"
      )
    }
    
    # Add MPE covariance if selected  
    if (input$opt_mpe) {
      param_text <- paste0(param_text,
        "(CO)VARIANCES_MPE\n", 
        "0.003\n"
      )
    }
    
    param_text <- paste0(param_text, "\n")
    
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
    
    # Solution output options
    if (input$opt_origID) options <- c(options, "OPTION origID")
    
    # Accuracy and reliability options
    if (input$opt_store_accuracy) {
      options <- c(options, paste0("OPTION store_accuracy ", input$opt_store_accuracy_eff))
    }
    if (input$opt_store_accuracy_orig) {
      if (input$opt_store_accuracy) {
        # Replace the previous store_accuracy option with the orig version
        options <- options[!grepl("^OPTION store_accuracy [0-9]+$", options)]
        options <- c(options, paste0("OPTION store_accuracy ", input$opt_store_accuracy_eff, " orig"))
      } else {
        options <- c(options, paste0("OPTION store_accuracy ", input$opt_store_accuracy_eff, " orig"))
      }
    }
    if (input$opt_acctype) {
      options <- c(options, paste0("OPTION acctype ", input$opt_acctype_value))
    }
    if (input$opt_correct_accuracy_by_inbreeding) {
      options <- c(options, paste0("OPTION correct_accuracy_by_inbreeding ", input$opt_inbreeding_filename))
    }
    if (input$opt_correct_accuracy_by_inbreeding_direct) {
      options <- c(options, "OPTION correct_accuracy_by_inbreeding_direct 0")
    }
    
    # REML specific options
    if (input$opt_conv_crit_custom) {
      # Remove default conv_crit if custom is selected
      options <- options[!grepl("^OPTION conv_crit 1d-12$", options)]
      options <- c(options, paste0("OPTION conv_crit ", input$opt_conv_crit_value))
    }
    if (input$opt_maxrounds_custom) {
      # Remove default maxrounds if custom is selected
      options <- options[!grepl("^OPTION maxrounds 1000000$", options)]
      options <- c(options, paste0("OPTION maxrounds ", input$opt_maxrounds_value))
    }
    if (input$opt_no_accelerate_EM) {
      options <- c(options, "OPTION no_accelerate_EM")
    }
    
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
    param_text <- paste0(param_text, paste(options, collapse = "\n"))
    
      # Store as default and current parameter
      values$default_param <- param_text
      values$current_param <- param_text
    }
    
    # Update textarea with generated parameter using JavaScript
    session$sendCustomMessage("update_textarea", list(content = values$current_param))
  })
  
  # Reset button - restore default parameter
  observeEvent(input$reset_param, {
    values$current_param <- values$default_param
    session$sendCustomMessage("update_textarea", list(content = values$current_param))
    showNotification("Parameter file reset to default", type = "message", duration = 2)
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
    
    # Get edited content from textarea using JavaScript
    session$sendCustomMessage("get_textarea_content", list())
  })
  
  # Listen for textarea content from JavaScript
  observeEvent(input$textarea_content, {
    if (!is.null(input$textarea_content) && nchar(input$textarea_content) > 0) {
      # Create and trigger download using JavaScript
      session$sendCustomMessage("download_text", list(
        content = input$textarea_content,
        filename = "easyblup.par"
      ))
    }
  })
}

# Run app
shinyApp(ui = ui, server = server)
