## load tidyverse ##
library(tidyverse)

## example data 
data(iris)

#check your import
str(iris)

#create a new data.frame 
## to work tidy also means to not change your original dataframe
data <- iris %>% 
  pivot_longer(cols = c('Sepal.Width', 'Sepal.Length'), 
               names_to = 'Sepal', values_to = 'value') #creates a new column 

# I can work without the pipe operator as well: 
data <- pivot_longer(iris, cols = c('Sepal.Width', 'Sepal.Length'), 
               names_to = 'Sepal', values_to = 'value') #creates a new column 

# However, using the pipe operator you can transform your data by introducing
# many functions at the same time! 
data <- iris %>% 
  mutate(petal_v = Petal.Length * Petal.Width) %>% #creates a new column 
  filter(Species == 'versicolor') %>% #only versicolor as species
  rename('Petal.V' = 'petal_v')  %>% # change name of my value column
  select(-Petal.V) %>% # remove column using select
  mutate(id = row_number()) %>% #column containing the row number
  slice(-c(1:5)) #removes first 5 columns 

#if you don't feel comfortable using the pipe operator you can also 
# apply one function at a time
## caution: you need to specify each time, which data frame you are using!

#creates a new column 
data <- mutate(iris, petal_v = Petal.Length * Petal.Width)  

#only versicolor as species
data <- filter(data, Species == 'versicolor')  

# change name of my value column
data <-rename(data, 'Petal.V' = 'petal_v')   

# remove column using select
data <-select(data, -Petal.V)  

#column containing the row number
data <-mutate(id = row_number())  

#removes first 5 columns 
data <-slice(-c(1:5)) 





