sheet_url <-
  "https://docs.google.com/spreadsheets/d/1ZFWhFOX3YrOWczSlu-OhHfVNG-ef2CIAuVGtqu8-1Og/edit?usp=sharing"

# load vocabulary df ------------------------------------------------------
get_gs4_dt <- 
  function(url = sheet_url){
    gs4_deauth()

    read_sheet(url,
               sheet = 1) %>%
      lazy_dt()
    
  }

# gs4_to_qs <- 
#   function(url = sheet_url){
#     
#     gs4_deauth()
#     
#     df <- 
#       read_sheet(url,
#                  sheet = 1)
#     
#     qs::qsave(df, "data/hydrowiki_df.qs")
#     
#   }
# 
# get_data <- 
#   function(){
#     
#     qs_date <- 
#       fs::file_info("data/hydrowiki_df.qs")$modification_time %>% 
#       as.Date()
#     
#     if (qs_date == Sys.Date() & !is.na(qs_date)) {
#       
#       message("Uploading existing version of the dataset…")
#       
#       db <- qs::qread("data/hydrowiki_df.qs") %>% 
#         lazy_dt()
#       
#     } else {
#       
#       message("Downloading a new version of the dataset…")
#       
#       # gs4_to_qs()
#       
#       
#       db <- qs::qread("data/hydrowiki_df.qs") %>% 
#         lazy_dt()
#     }
#   }

# custom functions --------------------------------------------------------
get_RU_term <- 
  function(.data, request){
    
    .data %>% 
      filter(en_term == request) %>% 
      as_tibble()
    
  }

get_EN_term <- 
  function(.data, request){
    
    .data %>% 
      filter(ru_term == request) %>% 
      as_tibble()
    
  }

create_html_enru <- 
  function(.data){
    
    HTML(
      paste0(
        '<b>',.data$ru_term,
        '</b><br><p>',.data$ru_def,
        '</p><p align = "right", style="font-size:80%"><i>',
        .data$ru_def_source,
        '</i><details><summary><u>Пример использования</u></summary><p style="font-size:100%">',
        .data$ru_example, '</p> <p align = "right", style="font-size:80%"><i>',
        .data$ru_example_source,
        '</i></p></details></p>',
        '<hr><b>', .data$en_term,
        '</b> <br><p>',.data$en_def,
        '</p><p align = "right", style="font-size:80%"><i>',
        .data$en_def_source,
        '</i><details><summary><u>Example</u></summary><p style="font-size:100%">',
        .data$en_example, '</p> <p align = "right", style="font-size:80%"><i>',
        .data$en_example_source,
        '</i></p></details></p>'
      )
    )
    
  }

create_html_ruen <- 
  function(.data){
    
    HTML(
      paste0(
        '<b>',.data$en_term,
        '</b><br><p>',.data$en_def,
        '</p><p align = "right", style="font-size:80%"><i>',
        .data$en_def_source,
        '</i><details><summary><u>Example</u></summary><p style="font-size:100%">',
        .data$en_example, '</p> <p align = "right", style="font-size:80%"><i>',
        .data$en_example_source,
        '</i></p></details></p>',
        '<hr><b>',
        .data$ru_term,'</b> <br><p>',.data$ru_def,
        '</p><p align = "right", style="font-size:80%"><i>',
        .data$ru_def_source,
        '</i><details><summary><u>Пример использования</u></summary><p style="font-size:100%">',
        .data$ru_example, '</p> <p align = "right", style="font-size:80%"><i>',
        .data$ru_example_source,
        '</i></p></details></p>'
      )
    )
    
  }
