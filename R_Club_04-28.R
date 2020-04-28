# R for Data Science
#28/4/2020

# 5 Data transformation
# https://r4ds.had.co.nz/transform.html

# rm(list=ls())

library(nycflights13)
library(tidyverse)


#*******************************************
### 5.6 summarise()

mean(flights$dep_delay)
mean(flights$dep_delay, na.rm = T)
mean(flights$dep_delay, na.rm = TRUE)

cancelled     <- flights[which( is.na(flights$dep_delay)),]
not_cancelled <- flights[which(!is.na(flights$dep_delay)),]
mean(not_cancelled$dep_delay)

# Using tidyverse:
summarise(flights, mean_delay = mean(dep_delay, na.rm = TRUE))
not_cancelled <- filter(flights, !is.na(dep_delay)) 
summarise(not_cancelled, delay = mean(dep_delay))

# Using the 'pipe':
flights %>% 
  filter(!is.na(dep_delay)) %>%  # not_cancelled
  summarise(mean = mean(dep_delay)) # mean (already with na.rm because of not_cancelled)


# Summarise by month
# Marina: by_month -> flights_month
flights_month <- group_by(flights, year, month)
summarise(flights_month, delay = mean(dep_delay, na.rm = TRUE))

# Summarise by month, using the pipe
flights %>% 
  filter(!is.na(dep_delay)) %>% # not_cancelled
  group_by(year, month) %>% # group by month
  summarise(mean = mean(dep_delay)) # calculate the average delay (per month)


# Ungroup
flights_month <- flights %>% 
  filter(!is.na(dep_delay)) %>% # not_cancelled
  group_by(year, month) # group by month
  

flights_month %>% 
  ungroup() %>%
  filter(!is.na(dep_delay)) %>% 
  summarise(mean = mean(dep_delay))


# Counts
flights %>% 
  filter(!is.na(dep_delay)) %>% 
  group_by(year, month) %>% # group_by(year, month, day) 
  summarise(
    mean_dep_delay = mean(dep_delay), 
    number_flights = n()
  )



## 5.6.4 Useful summary functions

# Measures of location: mean(x), median(x) 
# Measures of spread: sd(x), IQR(x), mad(x)
# Measures of rank: min(x), quantile(x, 0.25), max(x)
# Measures of position: first(x), nth(x, 2), last(x) - similar to x[1], x[2], and x[length(x)]

not_cancelled %>% 
  group_by(year, month) %>% 
  summarise(n_flights = n(),    
            mean_dep_delay = mean(dep_delay),
            sd_dep_delay = sd(dep_delay),
            min = min(dep_delay), 
            max = max(dep_delay),
            mean_dep_delay_non0 = mean(dep_delay[dep_delay > 0])) %>%
  arrange(mean_dep_delay)

# mean(arr_delay)

not_cancelled <- filter(flights, !is.na(dep_delay), !is.na(arr_delay)) 
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))


# Subsetting
not_cancelled %>% 
  group_by(year, month) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0]) # the average positive delay
  )


## 5.6.7 Exercises
# 1) Brainstorm at least 5 different ways to assess the typical delay characteristics of a group of flights. 
# Consider the following scenarios:
# A flight is 15 minutes early 50% of the time, and 15 minutes late 50% of the time.
# A flight is always 10 minutes late.
# A flight is 30 minutes early 50% of the time, and 30 minutes late 50% of the time.
# 99% of the time a flight is on time. 1% of the time it’s 2 hours late.
# Which is more important: arrival delay or departure delay?
  
# 2) Come up with another approach that will give you the same output as without using count()
# not_cancelled %>% count(dest)
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(n_flights = n()) 

# not_cancelled %>% count(tailnum, wt = distance)
not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(n_flights = n(),
            total_dist = sum(distance, na.rm= FALSE)) 

# 3) Our definition of cancelled flights (is.na(dep_delay) | is.na(arr_delay) ) is slightly suboptimal. 
# Why? Which is the most important column?
# Their definition:
flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
# I think they are also removing flights that were completely on time, but not cancelled

flights %>% 
  filter(!is.na(arr_time))

# 4) Look at the number of cancelled flights per day. 
# Is there a pattern? 
flights %>% 
  filter(is.na(arr_time)) %>%
  group_by(day) %>%
  summarise(n_flights_cancelled = n()) 

flights %>% 
  filter(is.na(arr_time)) %>%
  group_by(day) %>%
  ggplot(aes(x = day)) +
  geom_histogram() 

flights %>% 
  filter(is.na(arr_time)) %>%
  group_by(month, day) %>%
  ggplot(aes(x = day, group = month)) +
  geom_histogram(bins = 31) +
  facet_wrap(vars(month)) +
  xlab("Day of the month") +
  ylab("Number of delayed arrivals")


# Is the proportion of cancelled flights related to the average delay?
flights %>% 
  group_by(day) %>%
  summarise(n_flights = n(),
            n_flights_cancelled = sum(is.na(arr_time)),
            average_delay = mean(arr_delay, na.rm = TRUE)) %>%
  ggplot(aes(x = average_delay, y = n_flights_cancelled)) +
  geom_point()

            
# 5) Which carrier has the worst delays?
flights %>% 
  group_by(carrier) %>%
  summarise(n_flights = n(),
            average_delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(desc(average_delay))

# Challenge: can you disentangle the effects of bad airports vs. bad carriers?
flights %>% 
  group_by(carrier, dest) %>%
  summarise(n_flights = n(),
            average_delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(desc(average_delay)) 
# not finished
  
# 6) What does the sort argument to count() do. When might you use it?


## 5.7 Grouped mutates (and filters)

flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)

# Find the top 10 worst members of each group:
flights_sml %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)

# Find all groups bigger than a threshold:
popular_dests <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 365)
popular_dests

# Standardise to compute per group metrics:
popular_dests %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay)


## 5.7.1 Exercises

# 1) Refer back to the lists of useful mutate and filtering functions. Describe how each operation changes when you combine it with grouping.

# 2) Which plane (tailnum) has the worst on-time record?

# 3) What time of day should you fly if you want to avoid delays as much as possible?
  
# 4) For each destination, compute the total minutes of delay. For each flight, compute the proportion of the total delay for its destination.

# 5) Delays are typically temporally correlated: even once the problem that caused the initial delay has been resolved, later flights are delayed to allow earlier flights to leave. Using lag(), explore how the delay of a flight is related to the delay of the immediately preceding flight.

# 6) Look at each destination. Can you find flights that are suspiciously fast? (i.e. flights that represent a potential data entry error). Compute the air time of a flight relative to the shortest flight to that destination. Which flights were most delayed in the air?
  
# 7) Find all destinations that are flown by at least two carriers. Use that information to rank the carriers.

# 8) For each plane, count the number of flights before the first delay of greater than 1 hour


