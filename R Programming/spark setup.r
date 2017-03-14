install.packages("sparklyr")

library(sparklyr)


Sys.setenv(SPARK_HOME="C:/spark-2.0.1/spark-2.1.0-bin-hadoop2.7")

.libPaths(c(file.path(Sys.getenv("SPARK_HOME"),"R","lib"), .libPaths()))

library(SparkR)

sc=sparkR.init(master="local")
sqlContext=sparkRSQL.init(sc)



library(dplyr)
iris_tbl = copy_to(sc, iris)


data(t)
