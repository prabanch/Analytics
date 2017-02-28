

install.packages('foreign')
require(foreign)
library("foreign")
data.spss <- read.spss("course total spartans.sav", use.value.labels=FALSE)
data.spss <- read.spss("course total spartans.sav")
