argv <- commandArgs(TRUE)

# logdata working dir
# setwd("~/workspace/R/logdata")
setwd(as.character(argv[1]))

# case_num
n <- as.numeric(argv[2])

# algorithm name
algorithm_name <- as.character(argv[3])

# weight file name
weightfilename <- "weights.txt"

# output table file name
cpu_casefactor_filename <- "cpu_casefactor_table.txt"

# weight
weight_data <- read.table(weightfilename)
weight <- weight_data[, 1]

# serial time
serial_time <- vector(length=n)

# maxinum parallel proficiency
max_para_proficiency <- vector(length=n)

# mean parallel proficiency
mean_para_proficiency <- vector(length=n)

# mininum parallel proficiency
min_para_proficiency <- vector(length=n)

# optimized execution time
min_execute_time <- vector(length=n)

# relative speedup radio
rel_speed_radio <- vector(length=n)

# optimized kernel number
opt_kernel_num <- vector(length=n)

for(i in 1:n) {
  time_filename <- paste(algorithm_name, i, ".cpu", sep="")
  kernel_time_data <- read.table(time_filename)
  serial_time[i] <- kernel_time_data[1 , 2]
  time_data_row <- nrow(kernel_time_data)
  index <- 1
  
  max_para_proficiency[i] <- serial_time[i] / kernel_time_data[2 , 2] / kernel_time_data[2 , 1];
  min_para_proficiency[i] <- max_para_proficiency[i];
  for(j in 2:time_data_row) {
    if(kernel_time_data[index , 2] > kernel_time_data[j , 2]) {
      index <- j
    }
    
    cur_para_proficiency <- serial_time[i] / kernel_time_data[j , 2] / kernel_time_data[j , 1];
    if(max_para_proficiency[i] < cur_para_proficiency) max_para_proficiency[i] <- cur_para_proficiency;
    if(min_para_proficiency[i] > cur_para_proficiency) min_para_proficiency[i] <- cur_para_proficiency;
  }
  
  min_execute_time[i] <- kernel_time_data[index , 2]
  opt_kernel_num[i] <- kernel_time_data[index , 1]

  rel_speed_radio[i] <- serial_time[i] / min_execute_time[i];
  
  mean_para_proficiency[i] <- 0.0
  for(j in 2:index) {
    cur_para_proficiency <- serial_time[i] / kernel_time_data[j , 2] / kernel_time_data[j , 1];
    mean_para_proficiency[i] <- mean_para_proficiency[i] + cur_para_proficiency;
  }
  mean_para_proficiency[i] <- mean_para_proficiency[i] / (index - 2 + 1)
}

outdata <- data.frame(weight, serial_time, 
                      max_para_proficiency, mean_para_proficiency, min_para_proficiency,
                      min_execute_time, rel_speed_radio, opt_kernel_num)

write.table(outdata, cpu_casefactor_filename, row.names=FALSE)
