
argv <- commandArgs(TRUE)

# logdata working dir
# setwd("~/workspace/R/logdata")
setwd(as.character(argv[1]))

# case_num
# n <- 8
n <- as.numeric(argv[2])

# algorithm name
# algorithm_name <- "overlay"
algorithm_name <- as.character(argv[3])

#out_time_filename
out_time_filename <- "case_time_table.txt"

# output concluded table file name
conc_filename <- "concluded_file.config"

# io time
io_time <- vector(length=n)

# cpu time
cpu_time <- vector(length=n)

# measurement time
measurement_time <- vector(length=n)

for(i in 1:n) {
  io_time_filename <- paste(algorithm_name, i, ".io", sep="")
  cpu_time_filename <- paste(algorithm_name, i, ".cpu", sep="")
  mesurement_time_filename <- paste(algorithm_name, i, ".time", sep="")
  
  io_time_data <- read.table(io_time_filename)
  cpu_time_data <- read.table(cpu_time_filename)
  total_time_data <- read.table(mesurement_time_filename)
  
  time_data_row <- nrow(total_time_data)
  index <- 1
  for(j in 2:time_data_row) {
    if(total_time_data[index , 2] > total_time_data[j , 2]) {
      index <- j
    }
  }
  io_time[i] <- io_time_data[index, 2];
  cpu_time[i] <- cpu_time_data[index, 2];
  measurement_time[i] <- total_time_data[index, 2]
}

outdata <- data.frame(io_time, cpu_time, measurement_time)
write.table(outdata, out_time_filename, row.names=FALSE)


cat("time_table_content=\'", sep="", append=TRUE, file=conc_filename)
for(i in 1:nrow(outdata)) {
  cat("<tr><td>", i,"</td>", sep="", append=TRUE, file=conc_filename)
  for(j in 1:ncol(outdata)) {
    cat("<td>", outdata[i, j],"</td>", sep="",  append=TRUE, file=conc_filename)
  }
  cat("</tr>", sep="",  append=TRUE, file=conc_filename)
}

cat("\'\n", sep="",  append=TRUE, file=conc_filename)
