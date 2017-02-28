
attach(pf)

ggplot(aes(x = friend_count, y = ..count../sum(..count..)), 
       data = subset(pf, !is.na(gender))) +
  geom_freqpoly(aes(color = gender), binwidth=10) +
  scale_x_continuous(limits = c(0, 1000), breaks = seq(0, 1000, 50)) +
  xlab('Friend Count') +
  ylab('Percentage of users with that friend count')


ggplot(aes(x = www_likes), data = subset(pf, !is.na(gender))) +
  geom_freqpoly(aes(color = gender)) +
  scale_x_log10()

by(www_likes, dob_month, summary)

boxplot()

ggplot(aes(x = gender, y=friend_count), data =  pf) + geom_boxplot()
  