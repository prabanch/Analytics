Mu=0.295
Sigma=0.025
ProbLiessthan0.280=pnorm(.28, Mu, Sigma)
ProbLiessthan0.280
ProbLiessmorethan0.350=pnorm(0.350, Mu, Sigma, lower=FALSE)
ProbLiessmorethan0.350
ProbBetween0.260and.340=pnorm(.340, Mu, Sigma)-pnorm(.260, Mu, Sigma)
ProbBetween0.260and.340
Weightexceedby0.90=qnorm(.90, Mu, Sigma, llower=FALSE)
Weightexceedby0.90
prob=pnorm(0.263, Mu, Sigma)
prob

