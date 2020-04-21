# R for Data Science
#28/4/2020

# 5 Data transformation
# https://r4ds.had.co.nz/transform.html


#*******************************************
### 5.6 summarise()

mean(flights$air_time)
mean(flights$air_time, na.rm = T)
mean(flights$air_time, na.rm = TRUE)

summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

## 5.6.1 Combining multiple operations with the pipe %>%

# Group flights by destination
by_dest <- group_by(flights, dest)

# Summarise to compute number of flights (count), distance and average delay
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)
?n() # This function can only be used from within summarise(), mutate() and filter().

# Filter to remove noisy points and Honolulu airport, which is almost twice as far away as the next closest airport.
delay <- filter(delay, count > 20, dest != "HNL")

# It looks like delays increase with distance up to ~750 miles 
# and then decrease. Maybe as flights get longer there's more 
# ability to make up delays in the air?
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

delays <- flights %>% # first
  group_by(dest) %>% # then
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% # then
  filter(count > 20, dest != "HNL")

mean(flights$arr_delay)
mean(flights$arr_delay, na.rm = TRUE)

