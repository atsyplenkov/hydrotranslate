# libraries ---------------------------------------------------------------
suppressPackageStartupMessages({
  library(googlesheets4)
  library(dtplyr)
  library(dplyr, warn.conflicts = FALSE)
  library(qs)
  library(fs)
  library(emo)
  library(fresh)
  library(shiny)
  library(bs4Dash)
  library(markdown)
  
})

# English -----------------------------------------------------------------
source("ui/english_tab.R")

# French ------------------------------------------------------------------
source("ui/french_tab.R")

# About -------------------------------------------------------------------
source("ui/about.R")

# Add words ---------------------------------------------------------------
source("ui/add_words.R")

# UI elements -------------------------------------------------------------
sidebar <-
  dashboardSidebar(
    collapsed = TRUE,
    minified = FALSE,
    fixed = TRUE,
    sidebarMenu(
      id = "sidebarmenu",
      sidebarHeader("Choose language"),
      menuItem(
        paste0(emo::flag("Russia"), " Russian"),
        tabName = "russian_tab",
        icon = NULL
      ),
      menuItem(
        paste0(emo::flag("France"), " French"),
        tabName = "french_tab",
        icon = NULL
      ),
      sidebarHeader(""),
      sidebarHeader(""),
      sidebarHeader(""),
      sidebarHeader(""),
      sidebarHeader(""),
      sidebarHeader(""),
      sidebarHeader(""),
      sidebarHeader(""),
      sidebarHeader(""),
      sidebarHeader(""),
      sidebarHeader(""),
      sidebarHeader(""),
      menuItem(
        "About",
        tabName = "about_tab",
        icon = icon("circle-info")
      ),
      menuItem(
        "Add words",
        tabName = "add_tab",
        icon = icon("file-import")
      )
    )
  )

header <- 
  dashboardHeader(
    title = dashboardBrand(
      title = "HydroTranslator",
      color = "primary",
      href = "http://hydrowiki.org",
      image = "img/profile.png"
    )
  )

body <- 
  dashboardBody(
    use_theme("theme.css"),
    tabItems(
      tabItem(
        tabName = "russian_tab",
        tabsetPanel(
          type = "tabs",
          tabPanel(
            title = "RUS-ENG",
            rus_box
          ),
          tabPanel(
            title = "ENG-RUS",
            eng_box
          )
        )
      ),
      tabItem(
        tabName = "french_tab",
        french_box
      ),
      tabItem(
        tabName = "about_tab",
        about_box
      ),
      tabItem(
        tabName = "add_tab",
        add_box
      )
    )
  )

footer <- 
  dashboardFooter(
    left = a(
      href = "https://sediment.ru/",
      target = "_blank",
      paste0("Made with ", emo::ji("heart"), " in Lomonosov Moscow State University")
    ),
    right = format(Sys.Date(), "%Y")
  )

# Shiny App ---------------------------------------------------------------
shinyApp(
  ui = dashboardPage(
    title = "Hydrotranslator app",
    header = header,
    sidebar = sidebar,
    footer = footer,
    body = body,
    dark = NULL, 
    scrollToTop = TRUE
    # preloader = preloader
  ),
  server = function(input, output) {
    
    # output$rus_output <- renderText(
    #   get_EN_term(db, input$rus_input)$en_term
    # )
    # 
    output$rus_output <- renderUI({
      
      term <- get_EN_term(db, input$rus_input)
      
      create_html_ruen(term)
      
    })
    
    output$eng_output <- renderUI({
      
      term <- get_RU_term(db, input$eng_input) 
      
      create_html_enru(term)
      
    })
    
  }
)
