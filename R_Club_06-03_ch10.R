library(tidyverse)

### 10 Tibbles

# 1
mtcars
class(mtcars)
as_tibble(mtcars)

# 2
df <- data.frame(abc = 1, xyz = "a")
df$xyz
df[, "xyz"]
df[, c("abc", "xyz")]

dt <- as_tibble(df)
dt$x
dt$xyz
dt[['xyz']]
dt[, "xyz"]
dt[, c("abc", "xyz")]

# 3
var <- "xyz"
dt[[var]]
dt[,var]
df[,var]

# 4
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

# 4.1
annoying$1
annoying$'1'
annoying$`1`

# 4.2
ggplot(data = annoying, aes(x = `1`, y = `2`)) +
  geom_point()

# 4.3
annoying$`3` <- annoying$`2`/annoying$`1`  

# 4.4
annoying <- rename(annoying, 'one'=`1`,'two'=`2`,'three'=`3`)


# 5
?tibble::enframe()

c(a = 5, b = 7)
enframe(c(a = 5, b = 7))
deframe(annoying[,c(1,3)])




### 12.5
treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4
)

?fill
?pivot_wider
?complete

treatment %>% fill(person, .direction = "down")
treatment %>% fill(person, .direction = "up")

fill(data = treatment, person, .direction = "up")



