install.packages('astsa')
library(astsa)
data(jj)
plot(jj)
plot(decompose(jj))
lnjj = log(jj)
plot(decompose(lnjj))

View(jj)
plot(globtemp)
plot(djia[,4])
str(djia)
View(djia)

#moving average
w = rnorm(500,0,1)
v=filter(w, sides = 2, rep(1/3,3))
plot(v)
?arima.sim
data(presidents)
plot(presidents)
arima.sim(presidents)
?predict


plot(gnp)
plot(log(gnp))
#growth rate
plot(diff(log(gnp)))
plotgdp = diff(log(gnp))
plot(plotgdp)

acf(plotgdp)
pacf(plotgdp)
fit = arima(plotgdp, order = c(1,0,0))
fit

tsdiag(fit)
plot(rnorm(100,0,.2))


fit2 = arima(plotgdp, order = c(1,0,1))
fit2

library(forecast)

View(champagne_sales)


# save a numeric vector containing 72 monthly observations
# from Jan 2009 to Dec 2014 as a time series object
myts <- ts(champagne_sales[,-1], start=c(2008, 1), end=c(2016, 12), frequency=12)

View(myts)
# subset the time series (June 2014 to December 2014)
#myts2 <- window(myts, start=c(2014, 6), end=c(2014, 12))

# plot series
plot(myts)

plot(decompose(myts))
lnjj = log(myts)
plot(decompose(lnjj))

arima(champagne_sales)

