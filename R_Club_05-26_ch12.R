### 12 Tidy data

library(tidyverse)

table1

table1 %>% 
  mutate(rate = cases / population * 10000)

table1 %>% 
  count(year, wt = cases)

library(ggplot2)
ggplot(table1, aes(year, cases)) + 
  geom_line(aes(group = country), colour = "grey50") + 
  geom_point(aes(colour = country))

str(table1)

ggplot(table1, aes(as.factor(year), cases)) + 
  geom_line(aes(group = country), colour = "grey50") + 
  geom_point(aes(colour = country))

### 12.3 Pivoting --------------------------------------------------

## 12.3.1 Longer
# narrower and longer
table4a

ggplot(data = table4a, aes(x = 1999, y = 2000)) +
  geom_point()

ggplot(data = table4a, aes(x = '1999', y = '2000')) +
  geom_point()

ggplot(data = table4a, aes(x = `1999`, y = `2000`)) +
  geom_point()

table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")

tidy4a <- table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")

tidy4b <- table4b %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")

left_join(tidy4a, tidy4b)

## 12.3.1 Wider
# shorter and wider

table2

table2 %>%
  pivot_wider(names_from = type, values_from = count)

## Exercises

# 1
stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)

stocks

stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% # rows into columns - all rows from the selected column
  pivot_longer(c(`2015`,`2016`), names_to = "year", values_to = "return") # columns into rows - which columns?

?pivot_longer

names_ptype = list(year = double())


# 2
table4a 

table4a %>% 
  pivot_longer(c(1999, 2000), names_to = "year", values_to = "cases")


# 3
people <- tribble(
  ~name,             ~names,  ~values,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)

people %>% 
  pivot_wider(names_from = names, values_from = values) 

people %>% 
  group_by(name, names) %>%
  summarise(values = mean(values, na.rm = T)) %>%
  pivot_wider(names_from = names, values_from = values) 


# 4
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)

preg %>% 
  pivot_longer(c(male, female), names_to = 'sex', values_to = 'n_ind') 




### 12.4 Separating and uniting --------------------------------------------------
table3

table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/") # default: splits at non-alphanumeric character

table3 %>% 
  separate(year, into = c("millenium","century", "year"), sep = c(1,2))

table5 %>% 
  unite(new, century, year, sep = "")


## Exercises

# 1 
?separate

letters <- tibble(x = c("a,b,c", "d,e,f,g", "h,i,j"))

letters %>% 
  separate(x, into = c("one", "two")) # missing a lot

letters %>% 
  separate(x, into = c("one", "two"), extra = "merge")

letters %>% 
  separate(x, c("one", "two", "three")) # missing 'g'

letters %>% 
  separate(x, c("one", "two", "three", "four"))

#

letters2 <- tibble(x = c("a,b,c", "d,e", "f,g,i")) 

letters2%>% 
  separate(x, c("one", "two", "three"))


letters2 %>% 
  separate(x, c("one", "two", "three"), fill= "left")

letters2 %>% 
  separate(x, c("one", "two", "three"), fill= "right")

#

letters %>% 
  separate(x, into = c("one", "two"), sep = 3)


# 2
letters2 %>% 
  separate(x, c("one", "two", "three"), remove = FALSE)

# 3 (by position, by separator, and with groups)
?extract
?separate

df <- data.frame(x = c(NA, "a-b", "a-d", "b-c", "d-e"))
df %>% extract(x, "A")
df %>% extract(x, c("A", "B"), regex = "([[:alnum:]]+)-([[:alnum:]]+)")

df %>% separate(x, into = c("l1", "l2"), sep = 2)
df %>% separate(x, into = c("l1", "l2"), sep = "-")


