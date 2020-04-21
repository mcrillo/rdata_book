# R for Data Science
# 21/4/2020

# 5 Data transformation
# https://r4ds.had.co.nz/transform.html


# install.packages("nycflights13")
library(nycflights13)
library(tidyverse)

?flights

#********************************
### 5.2 filter(): selecting rows

?filter

dec25 <- filter(flights, month == 12, day == 25)

filter(flights, month == 1)
sqrt(2) ^ 2  == 2
near(sqrt(2) ^ 2,  2)

filter(flights, month == 11 | month == 12)
nov_dec <- filter(flights, month %in% c(11, 12))
filter(flights, month == 11 & day == 12)

# !(x & y) is the same as !x | !y
# !(x | y) is the same as !x & !y

filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)

# If you want to preserve missing values, ask for them explicitly:
df <- tibble(x = c(1, NA, 3))
filter(df, x > 1)
filter(df, is.na(x) | x > 1)

##
## 5.2.4 Exercise
##

names(flights)

# Had an arrival delay of two or more hours
filter(flights, arr_delay >= 2)

# Flew to Houston (IAH or HOU)
filter(flights, dest %in% c("IAH", "HOU"))

# Were operated by United, American, or Delta
flights$carrier # Which ones are c("United","American","Delta")?
# filter(flights, dest %in% c("United","American","Delta"))

# Departed in summer (July, August, and September)
filter(flights, month %in% c(7,8,9))

# Arrived more than two hours late, but didn’t leave late
?flights
filter(flights, flights$dep_delay == 0 & arr_delay>=120)

# Were delayed by at least an hour, but made up over 30 minutes in flight
filter(flights, flights$dep_delay >= 60 & arr_delay<=30)

# Departed between midnight and 6am (inclusive)
filter(flights, flights$dep_time >= 000 & flights$dep_time <= 600 )
filter(flights, flights$dep_time >= 000, flights$dep_time <= 600 )

# Another useful dplyr filtering helper is between(). 
?between()
filter(flights, between(x = dep_time, left = 000, right = 600))

# How many flights have a missing dep_time? 
filter(flights, is.na(dep_time))

# Why is NA ^ 0 not missing? Why is NA | TRUE not missing? Why is FALSE & NA not missing? Can you figure out the general rule? (NA * 0 is a tricky counterexample!)
# ??????????


#***************************************
### 5.3 arrange(): changes order of rows

?arrange

arrange(flights, year, month, day)

arrange(flights, dep_delay) # lower to higher
arrange(flights, desc(dep_delay)) # higher to lower

# Missing values are always sorted at the end:
df <- tibble(x = c(5, 2, NA))
arrange(df, x)
arrange(df, desc(x))

##
## 5.3.1 Exercise
##

# How could you use arrange() to sort all missing values to the start? (Hint: use is.na()).
# arrange(df, is.na(x), x) 
# ??????????

# Sort flights to find the most delayed flights. 
arrange(flights, desc(arr_delay))
# Find the flights that left earliest.
arrange(flights, dep_delay)
# Fastest (highest speed) flights.
View(arrange(flights, air_time))
# Which flights travelled the farthest? 
View(arrange(flights, desc(distance)))
# Which travelled the shortest?
View(arrange(flights, distance))


#***************************************
### 5.4 select(): select columns

?select

select(flights, year, month, day) # Select columns by name
select(flights, year:day) # Select all columns between year and day (inclusive)
select(flights, -(year:day)) # Select all columns except those from year to day (inclusive)

# rename() variables
rename(flights, tail_num = tailnum)


##
## 5.4.1 Exercise
##

# Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.
select(flights, dep_time, dep_delay, arr_time) 
select(flights, dep_delay, dep_time, arr_time) 
names(flights)
select(flights, dep_time:arr_time) 

# What happens if you include the name of a variable multiple times in a select() call?
select(flights, dep_delay, dep_delay, dep_delay, dep_delay) 

# What does the one_of() function do? Why might it be helpful in conjunction with this vector?
?tidyselect::one_of
# one_of() is retired in favour of the more precise any_of() and all_of() selectors.
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, one_of(vars))
select(flights, all_of(vars)) 
select(flights, any_of(vars)) # Same as all_of(), except that no error is thrown for names that don't exist.

?tidyselect::select_helpers # helper functions
# starts_with("abc"): matches names that begin with “abc”.
# ends_with("xyz"): matches names that end with “xyz”.
# contains("ijk"): matches names that contain “ijk”.
# matches("(.)\\1"): selects variables that match a regular expression. This one matches any variables that contain repeated characters. You’ll learn more about regular expressions in strings.
# num_range("x", 1:3): matches x1, x2 and x3.
# everything(): Matches all variables. # "the rest"

select(flights, contains("dep"))
select(flights, starts_with("dep"))
select(flights, year:day, ends_with("time"))

# handful of variables you’d like to move to the start of the data frame
select(flights, time_hour, air_time, everything())


select(flights, contains("TIME"))
select(flights, contains("time"))
select(flights, contains("TiMe")) 
select(flights, contains("TiMe"), ignore.case = TRUE) # Default
select(flights, contains("TiMe"), ignore.case = FALSE) # Default


#***********************************************************************
### 5.5 mutate()

?mutate
# adds new columns that are functions of existing columns
# adds new columns at the end of your dataset 

flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
                      )

mutate(flights_sml,
       gain = dep_delay - arr_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours # Note that you can refer to columns that you’ve just created:
)
# The key property is that the function must be vectorised: 
# It must take a vector of values as input, return a vector with the same number of values as output. 
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       hours = 3
)

# If you only want to keep the new variables, use transmute():
transmute(flights,
          gain = dep_delay - arr_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)

## 5.5.1 Useful creation functions
?base::Comparison
?dplyr::ranking
?dplyr::lead
?cumsum

##
## 5.5.2 Exercises 
##

# Currently dep_time and sched_dep_time are convenient to look at, but hard to compute with because they’re not really continuous numbers. 
# Convert them to a more convenient representation of number of minutes since midnight.
transmute(flights,
          
          dep_time,
          dep_hour = dep_time %/% 100,
          dep_minute = dep_time %% 100,
          dep_time_minutes = (dep_hour*60) + dep_minute,
          
          arr_time,
          arr_hour = arr_time %/% 100,
          arr_minute = arr_time %% 100,
          arr_time_minutes = (arr_hour*60) + arr_minute,
)


# Compare air_time with arr_time - dep_time. What do you expect to see? 
# What do you see? What do you need to do to fix it?
  
transmute(flights,
          air_time, # in minutes.
          arr_time, # format HHMM or HMM
          dep_time, # format HHMM or HMM
          arr_dep = arr_time - dep_time
)

transmute(flights,
          air_time, # in minutes
          dep_time, # format HHMM or HMM
          dep_time_minutes = ((dep_time %/% 100)*60) + (dep_time %% 100),
          arr_time, # format HHMM or HMM
          arr_time_minutes = ((arr_time %/% 100)*60) + (arr_time %% 100),
          arr_dep = arr_time_minutes - dep_time_minutes
) #???????????????????????


# Compare dep_time, sched_dep_time, and dep_delay. 
# How would you expect those three numbers to be related?
  
select(flights, c(dep_time, sched_dep_time, dep_delay))
transmute(flights,
          dep_time, 
          sched_dep_time, 
          dep_delay,
          new_column = dep_time - sched_dep_time
)


# Find the 10 most delayed flights using a ranking function.
transmute(arrange(flights, min_rank(-arr_delay)),
          min_rank(-arr_delay),
          arr_delay)

# How do you want to handle ties? Carefully read the documentation for min_rank().
?min_rank
?rank
# ???????????????

# What does 1:3 + 1:10 return? Why?
1:3 + 1:10 
1:3
1:10

# What trigonometric functions does R provide?
?base::Trig


#***********************************************************************
### 5.6 Grouped summaries with summarise()
# Next R Club!
