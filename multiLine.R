library(Cairo)
CairoFonts(regular = "WenQuanYi Micro Hei",
           bold = "WenQuanYi Micro Hei")

argv <- commandArgs(TRUE)

# logdata working dir
# setwd("~/workspace/R/logdata")
setwd(as.character(argv[1]))

# time_data_table
# source_time_data_table_filename <- "kernel_time_data_table.txt"
source_time_data_table_filename <- as.character(argv[2])

data <- read.table(source_time_data_table_filename, header=TRUE)
y <- data[, 2]
x <- data[, 1]
c=max(data[, -1])
maxkernel=max(x)

CairoPNG(paste(source_time_data_table_filename, ".png", sep=""))
plot(x, type='n', xlim=c(0, maxkernel), ylim=c(0, c*1.2), main='用例时间曲线', xlab='核数', ylab='时间', xaxt='n', yaxt='n')
d=round(c, digits=0)
axis(side=2, at=seq(0,d*1.1,signif(d/10,digits=1)))

for (i in 1:length(x))
{
  axis(side=1, at=seq(x[i],x[i]+1,2))
}
for (i in 2:ncol(data))
{
  lines(data[,1],data[,i],col=i)
}

dev.off()
