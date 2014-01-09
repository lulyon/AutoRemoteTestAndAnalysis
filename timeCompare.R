library(Cairo)
CairoFonts(regular = "WenQuanYi Micro Hei",
           bold = "WenQuanYi Micro Hei")

argv <- commandArgs(TRUE)

# logdata working dir
# setwd("~/workspace/R/logdata")
setwd(as.character(argv[1]))

total_casefactor_table_filename <- "total_casefactor_table.txt"

data <- read.table(total_casefactor_table_filename, header=TRUE)

case_num <-nrow(data)

x <- 1:case_num
arcgis_time <- data[, 1]
serial_time <- data[, 3]
para_time <- data[, 7]

c <- max(c(arcgis_time, serial_time))

CairoSVG(paste("time_compare", ".svg", sep=""))
plot(x, type='n', xlim=c(0, case_num + 3), ylim=c(0, c*1.1), main='执行时间对比', xlab='测试用例', ylab='时间', xaxt='n', yaxt='n')
axis(side=1, at=1:case_num)
axis(side=2, at=seq(0,1.1*c,round(c/10, digits=0)))
rect(x-0.45, 0, x - 0.15, para_time, col=4)
rect(x-0.15, 0, x + 0.15, serial_time, col=3)
rect(x + 0.15, 0, x + 0.45, arcgis_time, col=5)

text(x-0.3, para_time + 0.5, para_time, cex=0.5)
text(x, serial_time + 0.5, serial_time, cex=0.5)
text(x+0.3, arcgis_time + 0.5, arcgis_time, cex=0.5)

a=case_num + 1.5
b=c/3
d=0.2
e=c/30
h=c/9
rect(a,b,a+d,b+e,col=4)
text(a+0.9,b+e/2,'并行时间', cex=0.5)
b=b+h
rect(a,b,a+d,b+e,col=3)
text(a+0.9,b+e/2,'串行时间', cex=0.5)
b=b+h
rect(a,b,a+d,b+e,col=5)
text(a+0.9,b+e/2,'ArcGIS时间', cex=0.5)

dev.off()