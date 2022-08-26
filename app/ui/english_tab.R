# load gs4 data -----------------------------------------------------------
source("functions/gs4.R")

db <- get_data()

en_list <- pull(db, en_term)

ru_list <- pull(db, ru_term)

# English -----------------------------------------------------------------
# Text input footer box
ru_en_footer = fluidRow(
  column(
    width = 6,
    descriptionBlock(
      number = as.character(length(en_list)), 
      numberColor = "secondary", 
      numberIcon = NULL,
      header = NULL, 
      text = "English words", 
      rightBorder = TRUE,
      marginBottom = FALSE
    )
  ),
  column(
    width = 6,
    descriptionBlock(
      number = as.character(length(ru_list)), 
      numberColor = "secondary", 
      # numberIcon = icon("caret-down"),
      header = NULL, 
      text = "Русских слов", 
      rightBorder = FALSE,
      marginBottom = FALSE
    )
  )
)

# Text input box
input_html_style <- 
  HTML(
    HTML("<p class='repo-name', style='font-size:12px'>{{name}}</p>")
    # HTML("<p class='repo-name'>{{name}}</p>")
  )

# RUS-ENG box
rus_box <- 
  fluidRow(
    
    # tags$head(
    #   tags$link(rel = "stylesheet", type = "text/css", href = "shiny.css"),
    #   tags$style("input {font-family: Courier; font-size:12px; width:100%;}"),
    # ),
    # 
    box(
      solidHeader = FALSE,
      title = "Ввод",
      selectizeInput("rus_input",
                     label = NULL,
                     choices = sort(ru_list),
                     selected = NULL, multiple = FALSE,
                     options = list(maxItems = 1,
                                    placeholder = 'Начните писать слово…',
                                    # maxOptions = 5,
                                    onInitialize = I('function() { this.setValue(""); }'))),
      width = 12,
      collapsible = FALSE,
      maximizable = FALSE,
      footer = ru_en_footer
    ),
    
    box(
      solidHeader = FALSE,
      title = "Перевод",
      label = HTML("<a style='font-size:80%'; href='https://docs.google.com/spreadsheets/d/1ZFWhFOX3YrOWczSlu-OhHfVNG-ef2CIAuVGtqu8-1Og/edit?usp=sharing'; target='_blank'> Edit </a>"),
      htmlOutput("rus_output"),
      width = 12,
      collapsible = FALSE,
      maximizable = FALSE
    )
    
  )

# ENG-RUS box
eng_box <- 
  fluidRow(
    # Input
    box(
      solidHeader = FALSE,
      title = "Input",
      selectizeInput("eng_input",
                     label = NULL,
                     choices = sort(en_list),
                     selected = NULL, multiple = FALSE,
                     options = list(maxItems = 1,
                                    placeholder = 'Enter text…',
                                    # maxOptions = 5,
                                    onInitialize = I('function() { this.setValue(""); }'))),
      width = 12,
      collapsible = FALSE,
      maximizable = FALSE,
      footer = ru_en_footer
    ),
    # Output
    box(
      solidHeader = FALSE,
      title = "Translation",
      label = HTML("<a style='font-size:80%'; href='https://docs.google.com/spreadsheets/d/1ZFWhFOX3YrOWczSlu-OhHfVNG-ef2CIAuVGtqu8-1Og/edit?usp=sharing'; target='_blank'> Edit </a>"),
      htmlOutput("eng_output"),
      width = 12,
      collapsible = FALSE,
      maximizable = FALSE
    )
    
  )
