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

# arcgis time file name
arcgisfilename <- "arcgistimes.txt"

# weight file name
weightfilename <- "weights.txt"

# output table file name
total_casefactor_filename <- "total_casefactor_table.txt"

# output concluded table file name
conc_filename <- "concluded_file.config"

# arcgis time
arcgis_data <- read.table(arcgisfilename)
arcgis_time <- arcgis_data[, 1]

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

# absolute speedup radio
abs_speed_radio <- vector(length=n)

# relative speedup radio
rel_speed_radio <- vector(length=n)

# optimized kernel number
opt_kernel_num <- vector(length=n)

for(i in 1:n) {
  time_filename <- paste(algorithm_name, i, ".time", sep="")
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
  abs_speed_radio[i] <- arcgis_time[i] / min_execute_time[i];
  rel_speed_radio[i] <- serial_time[i] / min_execute_time[i];
  
  mean_para_proficiency[i] <- 0.0
  for(j in 2:index) {
    cur_para_proficiency <- serial_time[i] / kernel_time_data[j , 2] / kernel_time_data[j , 1];
    mean_para_proficiency[i] <- mean_para_proficiency[i] + cur_para_proficiency;
  }
  mean_para_proficiency[i] <- mean_para_proficiency[i] / (index - 2 + 1)
}

outdata <- data.frame(arcgis_time, weight, serial_time, 
                      max_para_proficiency, mean_para_proficiency, min_para_proficiency,
                      min_execute_time, abs_speed_radio, rel_speed_radio, opt_kernel_num)

write.table(outdata, total_casefactor_filename, row.names=FALSE)

cat("total_table_content=\'", sep="", append=TRUE, file=conc_filename)
for(i in 1:nrow(outdata)) {
  cat("<tr><td>", i,"</td>", sep="", append=TRUE, file=conc_filename)
  for(j in 1:ncol(outdata)) {
    cat("<td>", outdata[i, j],"</td>", sep="",  append=TRUE, file=conc_filename)
  }
  cat("</tr>", sep="",  append=TRUE, file=conc_filename)
}

cat("\'\n", sep="",  append=TRUE, file=conc_filename)
