library(fresh)

theme <- 
  create_theme(
    bs4dash_status(
      primary = "#5E81AC", danger = "#BF616A", light = "#272c30"
    )
  )

write(theme, "www/theme.css")
