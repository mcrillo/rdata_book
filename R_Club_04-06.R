# Marina Rillo
# R Club 04/April/2020
# Book "R for Data Science": https://r4ds.had.co.nz/


#******************************
#** 4 Workflow: basics ********
#******************************

# function_name(arg1 = val1, arg2 = val2, ...)
?seq

seq(from = 0, to = 10)
seq(0, 10)
seq(10, 0)

seq(0, 10, by = 2)
seq(0, 10, length.out = 6)

x <- 10
x

x = 10
x

# Exercices: typos
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

fliter(mpg, cyl = 8)
filter(diamonds, carat > 3)

#******************************
#** 6 Workflow: scripts *******
#******************************

seq(0, 10)
    
# Exercises:
# RStudio Tips: https://twitter.com/rstudiotips a
# Read: https://support.rstudio.com/hc/en-us/articles/205753617-Code-Diagnostics   

#*******************************************
#** 3.7 Statistical transformations ********
#*******************************************

ggplot(data = diamonds) + 
  geom_bar(aes(x = cut))

# But count is not a variable in diamonds! 
diamonds
table(diamonds$cut)
sum(table(diamonds$cut))
nrow(diamonds)

# Some geoms calculate new values to plot, 
# the algorithm used to calculate new values for a graph is called a stat
# short for statistical transformation.
?geom_bar
# The default behavior of geom_bar is to count the number of rows of data (using stat="count")

# Default geom_bar stat:
ggplot(data = diamonds) + 
  stat_count(aes(x = cut))

# When do you need to use 'stat' explicitly?

# Situation 1 #
demo <- tribble(
  ~cut,         ~freq,
  "Fair",       1610,
  "Good",       4906,
  "Very Good",  12082,
  "Premium",    13791,
  "Ideal",      21551
)

ggplot(data = demo) +
  geom_bar(mapping = aes(x = cut, y = freq), stat = "identity")

ggplot(data = demo) + # diamonds demo
  geom_bar(mapping = aes(x = cut))

table(diamonds$cut)
table(demo$cut)

# Situation 2 #

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut)) # default y: count

# Change default: propotion instead of count
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = stat(prop), group = 1)) # Why 'group = 1'? See Exercise 5.
# Same as:
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))

diamonds$prop # does not exist! 
?geom_bar # check 'Computed variables'

# Count:
table(diamonds$cut)
# Proportion:
table(diamonds$cut)/sum(table(diamonds$cut))


# Situation 3 #

ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )

## Exercices
## 1. What is the default geom associated with stat_summary()? 
# How could you rewrite the previous plot to use that geom function instead of the stat function?
?stat_summary
?geom_pointrange

ggplot(data = diamonds) + 
  geom_pointrange(aes(x = cut, y = depth, 
                      ymin = min(depth), 
                      ymax = max(depth)))

?stat_boxplot
?geom_boxplot

## 2. Difference between geom_bar() & geom_col()
?geom_col()

ggplot(data = diamonds) +
  geom_bar(aes(x = cut))
# Counts the number of rows (observations) for each cut

ggplot(data = diamonds) +
  geom_col(aes(x = cut, y = carat))
# Sums all carat values for each cut
# For more about geom_col() check: https://rpubs.com/Mentors_Ubiqum/geom_col_1

# Sums all carat values for each cut:
aggregate(carat ~ cut, data = diamonds, sum)
# same as:
diamonds %>% 
  group_by(cut) %>% 
  summarise(Frequency = sum(carat))


## 3. Pairs of geoms and stats
# ggplot2 cheatsheet: https://rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf
# https://ggplot2.tidyverse.org/reference/
# Area chart: geom_ribbon - from last R Club

## 4. Which variables stat_smooth() computes?

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))
# ?mpg # displ: engine displacement, in litres; hwy: highway miles per gallon

?stat_smooth() # Check 'Computed variables'
# Use stat_smooth() if you want to display the results with a non-standard geom.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  stat_smooth(mapping = aes(x = displ, y = hwy), se = TRUE)


## 5. Why 'group = 1'?
# Answer: https://stackoverflow.com/questions/39878813/ggplot-geom-bar-meaning-of-aesgroup-1

# The default behavior of geom_bar is to count the number of rows of data (using stat="count"):
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))

# If we want geom_bar to calculate proportions (instead of counts) we need to specify that:
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop..))
# But this does not work properly, because it does not compute the proportion for each 'cut' 

# geom_bar needs dummy variable "group = 1" to calculate proportions relative to all x (here: 'cut')
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 'x'))
# Same as:
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = stat(prop), group = 1)) 

# Also wrong:
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))



#************************************
#** 3.8 Position adjustments ********
#************************************

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, colour = cut))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))


# All 3 version below give the same graph!
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))
ggplot(data = diamonds) + 
  geom_bar(aes(x = cut, fill = clarity))
ggplot(data = diamonds, aes(x = cut, fill = clarity)) + 
  geom_bar()


# Default: position = "stack", see ?geom_bar
ggplot(data = diamonds, aes(x = cut, fill = clarity)) + 
  geom_bar(position = "stack")

# position = "fill": count goes until 1 (100%) to compare proportions across groups.
ggplot(data = diamonds, aes(x = cut, fill = clarity)) + 
  geom_bar(position = "fill")

# position = "identity"
ggplot(data = diamonds, aes(x = cut, fill = clarity)) + 
  geom_bar(position = "identity")
ggplot(data = diamonds, aes(x = cut, color = clarity)) + 
  geom_bar(position = "identity", fill = NA)

# position = "dodge"
ggplot(data = diamonds, aes(x = cut, fill = clarity)) + 
  geom_bar(position = "dodge")

ggplot(data = diamonds, aes(x = cut, fill = color)) + 
  geom_bar(position = "dodge")

# Scatterpplot, position = "jitter
ggplot(data = mpg) + 
  geom_point(aes(x = displ, y = hwy)) 
# Over-plotting: plot displays only 126 points, but there are 234 observations! 

# position = "jitter" 
ggplot(data = mpg) + 
  geom_point(aes(x = displ, y = hwy), position = "jitter") 
unique(mpg$displ) # be careful in the interpretation
# add a small amount of random noise to each point to visualise points that overlap each other

# Same as:
ggplot(data = mpg) + 
  geom_jitter(aes(x = displ, y = hwy))
# Not exactly the same because adds random noise each time


## 3.8.1 Exercices

# 1) Improve:
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point() # Problem: overplotting 
# Fix:
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point(position = "jitter")
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_jitter()

# 2) Amount of jitter
?geom_jitter
ggplot(data = mpg, aes(x = displ, y = hwy)) + 
  geom_jitter(width = 2, height = 15)
# color = drv

# 3) geom_count() & geom_jitter()
ggplot(data = mpg, aes(x = displ, y = hwy)) + 
  geom_count()

# 4) position = "dodge2"
?geom_boxplot
# from example: https://ggplot2.tidyverse.org/reference/geom_boxplot.html

p <- ggplot(mpg, aes(class, hwy))

p + geom_point()  # Problem: overplotting 

p + geom_count(show.legend = FALSE)

p + geom_boxplot() 

p + geom_boxplot() + geom_point(color = "blue", position = "jitter")

p + geom_boxplot() + geom_jitter(color = "blue", width = 0.1)

p + geom_boxplot() + geom_point(aes(colour = drv))

ggplot(mpg, aes(class, hwy)) + 
  geom_boxplot(aes(colour = drv), position = "dodge") 


#**********************************
#** 3.9 Coordinate systems ********
#**********************************

# (one of the) most complicated part of ggplot2

# coord_flip()
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() +
  coord_flip()

ggplot(data = mpg, mapping = aes(y = class, x = hwy)) + 
  geom_boxplot() 


# coord_quickmap()
nz <- map_data("nz")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_map()

# coord_polar()
bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar
bar + coord_flip() # same as changing x for y (in aes)
bar + coord_polar()

## 3.9.1 Exercices

# 1. Turn a stacked bar chart into a pie chart using coord_polar()

# position = "fill"
ggplot(data = diamonds, 
       aes(x = cut, fill = clarity)) + 
  geom_bar(position = "fill")

ggplot(data = diamonds, 
       aes(x = cut, fill = clarity)) + 
  geom_bar(position = "fill") +
  coord_polar("y")

ggplot(data = diamonds[which(diamonds$cut == "Fair"),], 
       aes(x = cut, fill = clarity)) + 
  geom_bar(position = "fill") +
  coord_polar("y")
  
# 2. labs()
?labs()

# 3. Difference between coord_quickmap() and coord_map()?
?coord_map()
?map_data

world <- map_data("world") # "world2"

ggplot(world, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_map()

ggplot(world, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()

# 4. Explain components of plot below
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed() +
  xlim(c(0,50)) + 
  ylim(c(0,50)) 

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  geom_hline(yintercept = 10) +
  coord_fixed() +
  xlim(c(0,50)) + 
  ylim(c(0,50)) + 
  geom_hline(yintercept = 10, color = "red") +
  geom_vline(xintercept = 10, color = "green")
  

#************************************************
#** 3.10 The layered grammar of graphics ********
#************************************************


