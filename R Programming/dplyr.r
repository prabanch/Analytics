library(s)
library(nycflights13)
dim(flights)
#> [1] 336776     19
head(flights)
s
#Filter
filter(flights, month == 1, day == 1)

#This is equivalent to the more verbose code in base R:
  
flights[flights$month == 1 & flights$day == 1, ]

#To select rows by position, use slice():
  
slice(flights, 1:10)

#arrange
arrange(flights, year, month, day)

#Use desc() to order a column in descending order:
  
arrange(flights, desc(arr_delay))


# Select columns by name
select(flights, year, month, day)

# Select all columns between year and day (inclusive)
select(flights, year:day)

#You can rename variables with select() by using named arguments:
  
  select(flights, tail_num = tailnum)
  ?select
#> # A tibble: 336,776 x 1
  
#  Use distinct()to find unique values in a table:
    
    distinct(flights, tailnum)
    
#Add new columns with mutate()
    
 #   Besides selecting sets of existing columns, it's often useful to add new columns that are functions of existing columns. This is the job of mutate():
      
      mutate(flights,
             gain = arr_delay - dep_delay,
             speed = distance / air_time * 60)
      
      
#Summarise values with summarise()
  summarise(flights,
                delay = mean(dep_delay, na.rm = TRUE))
  