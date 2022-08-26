library(dplyr)
library(data.table)
library(qs)
library(arrow)

# read original panlex dataset --------------------------------------------
db <- fread("data/expr.csv")


# select only rus (620) and eng (620) words -------------------------------
panlex_rus <- db[langvar == 620]$txt
panlex_eng <- db[langvar == 187]$txt

# write -------------------------------------------------------------------
library(qs)
qs::qsave(panlex_eng, "data/panlex_eng.qs")
qs::qsave(panlex_rus, "data/panlex_rus.qs")

# save as arrow -----------------------------------------------------------
en_panlex <- qs::qread("data/panlex_eng.qs") %>% 
  data.frame(en = .)

arrow::write_parquet(en_panlex,
                     sink = "data/en_panlex.parquet")

# load and test arrow -----------------------------------------------------
ds <- open_dataset(sources = "data/en_panlex.parquet")

ds %>% 
  filter(en == "discharge") %>%
  collect()
