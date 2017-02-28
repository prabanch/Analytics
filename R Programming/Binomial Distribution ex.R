
success=c(0,1,0,3,4,5,6,7,8,9)
probabilities=dbinom(size = 7, prob = 0.6, success)
cbind(success, probabilities)
cumulative=pbinom(size=7, success, prob = 0.6)
cbind(success, cumulative)
cbind(success, probabilities, cumulative)
