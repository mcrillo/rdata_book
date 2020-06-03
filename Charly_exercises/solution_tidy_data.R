
### R Club 03/June/2020

library(tidyverse)

# manual import of data 
## decimal mark? separator?

Cell_counts_Phyto_S3_journalclub <- read_delim("rdata_book/Charly_exercises/Cell_counts_Phyto_S3_journalclub.csv", 
                                               delim = ";", escape_double = FALSE, 
                                               locale = locale(decimal_mark = ","), 
                                               trim_ws = TRUE)
View(Cell_counts_Phyto_S3_journalclub)    

# check your import                                                                           
str(Cell_counts_Phyto_S3_journalclub)

# make your data tidy
tidy_data <- Cell_counts_Phyto_S3_journalclub  %>% #create new df
  drop_na(spezies) %>%    #remove NA entries in my species column
  fill(sample, .direction = c("down")) %>% #Fill in missing values with previous value
  filter(!spezies == 'spezies') %>% #remove unnecessary rows in df 
  rename('Cells_ml' = 'Cells/ml')

#check our output
str(tidy_data)

## what's next?
# change column types to numeric to apply pivot_longer (needs the same variable format)
tidy_data$'1' = as.numeric(tidy_data$'1')
tidy_data$"Cells_ml" = as.numeric(tidy_data$"Cells_ml")

# gather data in columns 1:10
# separate sample

## new df
tidy_data1 <- tidy_data %>%
  pivot_longer(cols = c('1', '2', '3', '4', '5', '6', '7', '8', '9', '10'), 
               names_to = "square", values_to = "counts") %>%
  separate(sample, into = c('MC', 'sample'), sep=' ') 
View(tidy_data1)

## have a look at your data
ggplot(data = tidy_data1, 
       aes(x = MC, y =Cells_ml, fill = square)) +
  geom_col()
 
## Export your new df
#write.csv2(x = tidy_data, file = 'tidy_counts_JC.csv')

tidy_data1 %>% 
  group_by(spezies) %>% 
  summarise(sum_counts = sum(counts, na.rm = TRUE))

data_counts <- tidy_data1[, c("spezies", "counts")]

data_counts <- data_counts %>% 
  filter(!is.na(counts))
  
data_counts %>% 
  group_by(spezies) %>% 
  summarise(sum_counts = sum(counts))

tidy_data1 %>% 
  group_by(spezies, square) %>% 
  summarise(sum_counts = sum(counts, na.rm = TRUE))


na_to0 <- tidy_data1 %>% 
  mutate(counts_new = replace_na(counts, 0))

