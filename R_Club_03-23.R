install.packages("tidyverse")

library(tidyverse)
tidyverse_update()

setwd("/Users/marinacostarillo/Dropbox/Postdoc/projects/rdata_book")
list.files()

data <- structure(list(sample = structure(1:5, .Label = c("A", "B", "C", 
                                                          "D", "E"), class = "factor"), n_cells = c(10L, 20L, 30L, 40L, 
                                                                                                    50L)), class = "data.frame", row.names = c(NA, -5L))

