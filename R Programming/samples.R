wd <- getwd()
sprintf("Current working dir: %s", wd)
message("Current working dir: ", wd)
for (year in c(2010,2011,2012,2013,2014,2015)){message("Current working dir: ", wd}
for (year in 10:15) print("Year is: ", year);

                            
for (i in 1:10) {
  if (!i %% 2){next}
  print(i)
}                        

i = 0
while (i < 10) {
  message(i);   i = i +1;
  
}
for letter in 'Python':     # First Example
  if letter == 'h':
  continue
print ('Current Letter :', letter)



x <- "The quick brown fox jumps over the lazy dog"
split.string <- strsplit(x, " ")
extract.words <- split.string[[1]]
result <- unique(tolower(extract.words))
print(result)


# Create the data frame.
emp.data <- data.frame(
  emp_id = c (1:5), 
  emp_name = c("Rick","Dan","Michelle","Ryan","Gary"),
  salary = c(623.3,515.2,611.0,729.0,843.25), 
  
  start_date = as.Date(c("2012-01-01", "2013-09-23", "2014-11-15", "2014-05-11",
                         "2015-03-27")),
  stringsAsFactors = FALSE
)
# Print the data frame.			
print(emp.data) 
emp.data



a <- "Hello"
b <- 'How'
c <- "are you? "

print(paste(a,b,c))

print(paste(a,b,c, sep = "-"))

print(paste(a,b,c, sep = "", collapse = ""))



# Create data for the graph.
x <- c(21, 62, 10, 53)
labels <- c("London", "New York", "Singapore", "Mumbai")

# Give the chart file a name.
png(file = "city.jpg")

# Plot the chart.
pie(x,labels)

# Save the file.
dev.off()

seq(1,10,.0010)
t <- c("Sun","Mon","Tue","Wed","Thurs","Fri","Sat")
u <- t[c(2,3,6)]
u
u[1]

install.packages("ggplot2")

setwd("C:/Users/prabanch/Desktop/R Programming")
getwd()a



data = read.csv("C:/Users/prabanch/Desktop/R Programming/statedata.csv", header = FALSE)
summary(data)

sub1 = subset(data, state.area = 1, state.area,state.region)
sub1

sub1 = data.frame(data, data$state.area)
sub1 = data[data$state.region==1,]
c = c(data$state.area)
c[1]


s=as.numeric(as.character(data$state.area))


s = merge(data, data, all = TRUE)

s
X <- c(3, 2, 4) 
Y<- c(1, 2,2)
z <- x*y
z
Z <- X*Y
Z
setdiff(c(1,3,5,7,10),c(1,5,10,12,14))
diff(c(1,3,5,7,10),c(1,5,10,12,14)) 
unique(c(1,3,5,7,10),c(1,5,10,12,14))

write.csv("result.csv", data)

write.csv(data,"result.csv", row.names = FALSE)

write.csv(file="result.csv",x=data,row.names = FALSE)


y=seq(1,1000,by=0.5)
y
length(y)
data
gsub("Alabama","a",data$data.state)
data
x <- 1:3
y <- 10:12 
 rbind(x, y)
 f <- function(num = 1) {
           hello <- "Hello, world!\n"
           for(i in seq_len(num)) {
                     cat(hello)
            }
           chars <- nchar(hello) * num
            chars
    }
 f()
 
 
 reddit
 str(reddit)
 levels(reddit$age.range)
 library(ggplot2)
 qplot(data = reddit, x=  reddit$age.range)
 
 ses.f <- factor( levels(reddit$age.range))
 ses.f
 reddit$age.range <- factor(reddit$age.range, ses.f, ordered = T)
 
 reddit$age.range
 