library(tidyverse)
library(rvest)
library(magrittr)

base_url <- 
  "http://hydrowiki.org/w/index.php/%D0%97%D0%B0%D0%B3%D0%BB%D0%B0%D0%B2%D0%BD%D0%B0%D1%8F_%D1%81%D1%82%D1%80%D0%B0%D0%BD%D0%B8%D1%86%D0%B0"

inner_links <- 
  base_url |> 
  read_html() |> 
  html_nodes("ul.mw-allpages-chunk li a") |> 
  extract(13:242) %>% 
  extract(-222)

parse_hydrowiki <- 
  function(i){
    
    object <- 
      inner_links[i] %>%  
      html_attr("href") %>% 
      paste0("http://hydrowiki.org", .) %>% 
      read_html()
    
    # English term
    object_eng <- 
      inner_links[i] %>% 
      html_text()
    
    # Test
    res <- 
      try(
        object %>% 
          html_nodes("h2") %>% 
          extract(2),
        silent = T
      )
    
    if (class(res) == "try-error") {
      
      output <- 
        tibble(
          id = i,
          en_term = object_eng,
          ru_term = NA_character_,
          en_def = NA_character_,
          ru_def = NA_character_,
          en_def_source = NA_character_,
          ru_def_source = NA_character_
        )
    
    } else {
        
    
    # Russian term
    object_rus <- 
      object %>% 
      html_nodes("h2") %>% 
      extract(2) %>% 
      html_text()
    
    # Russian defenition
    object_rus_def <-
      object %>% 
      html_nodes("p") %>% 
      extract(1) %>% 
      html_text()
    
    # Russian definition reference
    ref_rus_def <- 
      object_rus_def %>% 
      str_extract("(\\[)\\d*(\\])") %>% 
      str_extract("[\\d*]") %>% 
      as.integer()
    
    # English definition
    object_eng_def <-
      object %>% 
      html_nodes("p") %>% 
      extract(2) %>% 
      html_text()
    
    # English definition reference
    ref_eng_def <- 
      object_eng_def %>% 
      str_extract("(\\[)\\d*(\\])") %>% 
      str_extract("[\\d*]") %>% 
      as.integer()
    
    # Russian definition reference
    # object_rus_ref <- 
    #   object %>% 
    #   html_nodes(paste0("ol.references li#cite_note-",
    #                     ref_rus_def)) %>% 
    #   html_text() %>% 
    #   str_remove("(\n)") %>% 
    #   str_remove("↑") %>% 
    #   str_remove("\\d*(\\.)") %>% 
    #   trimws()
    
    # References
    object_ref <- 
      object %>% 
      html_nodes("ol.references") %>% 
      html_text() %>% 
      str_split("↑") %>% 
      unlist() %>% 
      trimws() %>% 
      extract(-1)
    
    output <- 
      tibble(
        id = i,
        en_term = object_eng,
        ru_term = object_rus,
        en_def = object_eng_def,
        ru_def = object_rus_def,
        en_def_source = object_ref[ref_eng_def],
        ru_def_source = object_ref[ref_rus_def]
      )
      }
    
    cat(paste0(i, "..."))
    
    return(output)
  }

hydrowiki_df <- 
  seq_along(inner_links) %>% 
  map_dfr(~parse_hydrowiki(.x))

# writexl::write_xlsx(hydrowiki_df, "hydrowiki_df.xlsx")
