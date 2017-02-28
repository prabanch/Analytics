pf <- read.delim("C:/Users/prabanch/Desktop/R Programming/pseudo_facebook.tsv")
pf
library(ggplot2)
names(pf)
attach(pf)
ggplot(aes(x = dob_day), data = pf) +
  geom_histogram(binwidth = 1) +
  scale_x_continuous(breaks = 1:31)+ facet_wrap(~dob_month, ncol = 3)


qplot(x = friend_count, data = pf, xlim = c(0,1000))

qplot(x = friend_count, data = pf)+ 
  scale_x_continuous(limits = c(1,1000))

ggplot(aes(x = friend_count), data = pf) +
  geom_histogram()
head(pf)


qplot(x = friend_count, data = pf, xlim = c(0,1000))

qplot(x = friend_count, data = pf) +
  facet_grid(gender ~ .)


qplot(x = friend_count, data = pf, binwidth = 25) +
  scale_x_continuous(limits = c(0, 1000), breaks = seq(0, 1000, 50))


table(pf$gender)

ggplot(aes(x = friend_count), data = pf) +
  geom_histogram() +
  scale_x_continuous(limits = c(0, 1000), breaks = seq(0, 1000, 50)) +
  facet_wrap(~gender)

#find the fried count by gender

summary(friend_count)

by(friend_count, gender, summary)

qplot(x = tenure/365,   data = pf ) +
   geom_histogram(binwidth = .25, color = 'black', fill = '#099DD9')

ggplot(aes(x = tenure / 365), data = pf) +
  geom_histogram(color = 'black', fill = '#F79420') +
  scale_x_continuous(breaks = seq(1, 7, 1), limits = c(0, 7)) +
  xlab('Number of years using Facebook') +
  ylab('Number of users in sample')



 # define matrix mymat by replicating the sequence 1:5 for 4 times and transforming into a 
 mymat<-matrix(rep(seq(5), 4), ncol = 5) 
 mymat
# mymat sum on rows 
vapply(mymat,  sum) 

qplot(x = age, data = pf)

qplot(data = pf, x = age, binwidth = 1,  fill = I('#5760AB')) 


install.packages('gridExtra')
library(gridExtra)

summary(age)
attach(pf)

summary(log(age))
summary(sqrt(age))

anova()
