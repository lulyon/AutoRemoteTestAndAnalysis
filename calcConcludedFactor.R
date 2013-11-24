argv <- commandArgs(TRUE)

# logdata working dir
# setwd("~/workspace/R/logdata")
setwd(as.character(argv[1]))

# input total table file name
total_casefactor_filename <- "total_casefactor_table.txt"

# input cpu(no io) table file name
cpu_casefactor_filename <- "cpu_casefactor_table.txt"

# output concluded file name
conc_filename <- "concluded_file.config"

total_data <- read.table(total_casefactor_filename, header=TRUE)
cpu_data <- read.table(cpu_casefactor_filename, header=TRUE)

s1 <- max(total_data[, 8])
s2 <- min(total_data[, 8])
s3 <- total_data[, 2] %*% total_data[, 8]

s4 <- max(total_data[, 9])
s5 <- min(total_data[, 9])
s6 <- total_data[, 2] %*% total_data[, 9]

s7 <- max(cpu_data[, 7])
s8 <- min(cpu_data[, 7])
s9 <- cpu_data[, 1] %*% cpu_data[, 7]

sa <- max(total_data[, 4])
sb <- total_data[, 2] %*% total_data[, 5]

sc <- max(cpu_data[, 3])
sd <- cpu_data[, 1] %*% cpu_data[, 4]


cat("replace_s1=", s1, "\n", sep="", append=TRUE, file=conc_filename);
cat("replace_s2=", s2, "\n", sep="", append=TRUE, file=conc_filename);
cat("replace_s3=", s3, "\n", sep="", append=TRUE, file=conc_filename);
cat("replace_s4=", s4, "\n", sep="", append=TRUE, file=conc_filename);
cat("replace_s5=", s5, "\n", sep="", append=TRUE, file=conc_filename);
cat("replace_s6=", s6, "\n", sep="", append=TRUE, file=conc_filename);
cat("replace_s7=", s7, "\n", sep="", append=TRUE, file=conc_filename);
cat("replace_s8=", s8, "\n", sep="", append=TRUE, file=conc_filename);
cat("replace_s9=", s9, "\n", sep="", append=TRUE, file=conc_filename);
cat("replace_sa=", sa, "\n", sep="", append=TRUE, file=conc_filename);
cat("replace_sb=", sb, "\n", sep="", append=TRUE, file=conc_filename);
cat("replace_sc=", sc, "\n", sep="", append=TRUE, file=conc_filename);
cat("replace_sd=", sd, "\n", sep="", append=TRUE, file=conc_filename);
