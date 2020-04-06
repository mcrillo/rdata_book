# R for Data Science
# 30/3/2020

# 3 Data visualisation

### 3.1 Introduction
# install.packages("tidyverse")
library(tidyverse)

### 3.2 First steps

mpg

# All the same:
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point()

ggplot(data = mpg, aes(x = displ, y = hwy)) + 
  geom_point()

ggplot(data = mpg) + 
  geom_point(aes(x = displ, y = hwy))


# Exercises

# 1. Run ggplot(data = mpg). What do you see?
# 2. How many rows are in mpg? How many columns?
str(mpg)
dim(mpg)
nrow(mpg)
ncol(mpg)

# 3. What does the drv variable describe? Read the help for ?mpg to find out.
?mpg

# 4. Make a scatterplot of hwy vs cyl.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = cyl, y = hwy))

# 5. What happens if you make a scatterplot of class vs drv? Why is the plot not useful?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = class, y = drv))
?mpg


### 3.3 Aesthetic mappings
# An aesthetic is a visual property of the objects in your plot.
# The x and y locations of a point are themselves aesthetics, visual properties that you can map to variables to display information about the data.

# aes(color)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
# To map an aesthetic to a variable, associate the name of the aesthetic (color) to the name of the variable (class) inside aes()
# ggplot2 automatically assign a unique level of the aesthetic (here a unique color) and also adds a legend that explains which levels correspond to which values.

# aes(size)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

# aes(alpha)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

# aes(shape)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

# Once you map an aesthetic, ggplot2 takes care of the rest. It selects a reasonable scale to use with the aesthetic, and it constructs a legend that explains the mapping between levels and values.
# For x and y aesthetics, ggplot2 does not create a legend, but it creates an axis line with tick marks and a label.

# Here, the color/size/shape doesn’t convey information about a variable (they are outisde 'aes()')
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), size = 3)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), shape = 11)


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), 
             shape = 2, color = "blue", fill = "darkorange")
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), 
             shape = 17, color = "blue", fill = "darkorange")
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), 
             shape = 24, color = "blue", fill = "darkorange")

# Exercises

# 1. What’s gone wrong with this code? Why are the points not blue?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

# 2. Which variables in mpg are categorical? Which variables are continuous? (Hint: type ?mpg to read the documentation for the dataset). How can you see this information when you run mpg?
head(mpg)
?mpg
str(mpg)

# 3. Map a continuous variable to color, size, and shape. How do these aesthetics behave differently for categorical vs. continuous variables?

# continuous (color)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = cty))
# categorical (color)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = manufacturer))

# continuous (size)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = cty))
# categorical (size)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = manufacturer))

# continuous (shape)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = cty))
# categorical (shape)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = manufacturer))

# 4. What happens if you map the same variable to multiple aesthetics?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = cty, color = cty))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = manufacturer, color = manufacturer))

# 5. What does the stroke aesthetic do? What shapes does it work with? (Hint: use ?geom_point)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, stroke = cyl), shape = 2)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = cyl), stroke = 2)

?geom_point
vignette("ggplot2-specs")

# 6. What happens if you map an aesthetic to something other than a variable name, like aes(colour = displ < 5)? Note, you’ll also need to specify x and y.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, colour = displ < 5)) +
  scale_color_manual(values = c("purple", "yellow"))

### 3.4 Common problems
ggplot(data = mpg) +
geom_point(mapping = aes(x = displ, y = hwy))

### 3.5 Facets
# For categorical variables

# Facet_wrap: single variable
# The first argument of facet_wrap() should be a formula, which you create with ~ followed by a variable name
# The variable that you pass to facet_wrap() should be discrete.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class)) + 
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class)) + 
  facet_wrap(class ~. , nrow = 2)

# Facet_grid: two variables
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(cyl ~ drv)

# Difference between facet_wrap & facet_grid:
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(drv ~ .)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ .) # same as facet_wrap

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(.~ drv) # same as facet_wrap(. ~ drv)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(.~ drv, scales = "free") # DIFFERENT!

# Exercises
# 1. What happens if you facet on a continuous variable?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = cty)) + 
  facet_wrap(~ cty, nrow = 2)

# 2. What do the empty cells in plot with facet_grid(drv ~ cyl) mean? How do they relate to this plot?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl)) +
  facet_grid(drv ~ cyl) 


# 3. What plots does the following code make? What does . do?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

# 4.Take the first faceted plot in this section:
# What are the advantages to using faceting instead of the colour aesthetic? 
# What are the disadvantages? How might the balance change if you had a larger dataset?

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class)) 

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class)) + 
  facet_wrap(~ class, nrow = 2)


# 5. Read ?facet_wrap. What does nrow do? What does ncol do? What other options control the layout of the individual panels? 
# Why doesn’t facet_grid() have nrow and ncol arguments?
?facet_wrap # one variable
?facet_grid # two variables

# When using facet_grid() you should usually put the variable with more unique levels in the columns. Why?

### 3.6 Geometric objects
# A geom is the geometrical object that a plot uses to represent data. People often describe plots by the type of geom that the plot uses. 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) + 
  geom_line(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(x = displ, y = hwy))

# Every geom function in ggplot2 takes a mapping argument. 
# However, not every aesthetic works with every geom. 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, linetype = drv)) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))
# For example, 'linetype' does not work with geom_points()

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = drv, color = drv)) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv, color = drv))

# group aesthetic
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))
# groupd basically does what color, linetype, shape do, but without any change
ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, linetype = drv),
    show.legend = FALSE
  )

# Tip aes() in ggplot()

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth(aes(color = drv))

# Play around with aes and geoms
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = class)) + 
  geom_point() + 
  geom_smooth()

# Specific data for each layer
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = class)) + 
  geom_point() + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)


ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)


# Exercices
# 1. What geom would you use to draw a line chart? A boxplot? A histogram? An area chart?
# Line
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() +
  geom_line() 

# Boxplot
ggplot(data = mpg, mapping = aes(x = trans, y = displ)) + 
  geom_boxplot() +
  geom_point()

# Boxplot: continuous variable
ggplot(data = mpg, mapping = aes(x = cyl, y = displ)) + 
  geom_point() +
  geom_boxplot()
ggplot(data = mpg, mapping = aes(x = cyl, y = displ)) + 
  geom_point() +
  geom_boxplot(aes(group=cyl))

# Histogram
ggplot(data = mpg, mapping = aes(x = cyl)) + 
  geom_histogram()

# Area chart: geom_ribbon - NEXT R CLUB

# 2. Run this code in your head and predict what the output will look like. 
# Then, run the code in R and check your predictions.

# 3. What does show.legend = FALSE do? What happens if you remove it?
# Why do you think I used it earlier in the chapter?

# 4. What does the se argument to geom_smooth() do?
# It plot the standard error shade around the line

# 5. Will these two graphs look different? Why/why not?
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

# 6. Recreate the R code necessary to generate the following graphs.
# (go back to R Book and discuss)
