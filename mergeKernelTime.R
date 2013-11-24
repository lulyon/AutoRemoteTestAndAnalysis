
argv <- commandArgs(TRUE)

# logdata working dir
# setwd("~/workspace/R/logdata")
setwd(as.character(argv[1]))

# case_num
n <- as.numeric(argv[2])

# algorithm name
algorithm_name <- as.character(argv[3])

#out_time_filename
io_out_time_filename <- "kernel_time_data_table_io.txt"
cpu_out_time_filename <- "kernel_time_data_table_cpu.txt"
total_out_time_filename <- "kernel_time_data_table.txt"

# io time
io_time <- vector(length=n)

# cpu time
cpu_time <- vector(length=n)

# measurement time
measurement_time <- vector(length=n)

io_time_matrix <- NULL
cpu_time_matrix <- NULL
total_time_matrix <- NULL

for(i in 1:n) {
  io_time_filename <- paste(algorithm_name, i, ".io", sep="")
  cpu_time_filename <- paste(algorithm_name, i, ".cpu", sep="")
  mesurement_time_filename <- paste(algorithm_name, i, ".time", sep="")
  
  io_time_data <- read.table(io_time_filename)
  cpu_time_data <- read.table(cpu_time_filename)
  total_time_data <- read.table(mesurement_time_filename)
  
  if(i == 1) {
    io_time_matrix <- cbind(io_time_matrix, io_time_data[, 1])
    cpu_time_matrix <- cbind(cpu_time_matrix, cpu_time_data[, 1])
    total_time_matrix <- cbind(total_time_matrix, total_time_data[, 1])
  }
  
  io_time_matrix <- cbind(io_time_matrix, io_time_data[, 2])
  cpu_time_matrix <- cbind(cpu_time_matrix, cpu_time_data[, 2])
  total_time_matrix <- cbind(total_time_matrix, total_time_data[, 2])
  
}

io_outdata <- data.frame(io_time_matrix)
write.table(io_outdata, io_out_time_filename, row.names=FALSE)

cpu_outdata <- data.frame(cpu_time_matrix)
write.table(cpu_outdata, cpu_out_time_filename, row.names=FALSE)

total_outdata <- data.frame(total_time_matrix)
write.table(total_outdata, total_out_time_filename, row.names=FALSE)
