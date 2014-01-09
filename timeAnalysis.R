library(Cairo)
CairoFonts(regular = "WenQuanYi Micro Hei",
           bold = "WenQuanYi Micro Hei")

argv <- commandArgs(TRUE)

# logdata working dir
# setwd("~/workspace/R/logdata")
setwd(as.character(argv[1]))


total_casefactor_table_filename <- "case_time_table.txt"

data <- read.table(total_casefactor_table_filename, header=TRUE)

case_num <- nrow(data)
sy <- data[, 3]
x <- 1:case_num
io <- data[, 1]
to <- data[, 2]
to <- io + to
ca<-data[, 2]
c=max(sy)


CairoSVG(paste("time_analysis", ".svg", sep=""))
plot(x, type='n', xlim=c(0, case_num + 3), ylim=c(0, c*1.1), main='执行时间分析', xlab='测试用例', ylab='时间', xaxt='n', yaxt='n')

axis(side=1, at=1:case_num)
axis(side=2, at=seq(0,1.1*c,round(c/10, digit=0)))
rect(x-0.3,0,x,io,col=4)
rect(x-0.3,io,x,to,col=3)
rect(x,0,x+0.3,sy,col=5)

text(x-0.15, io + 0.5, io, cex=0.5)
text(x-0.2, to - 0.5, to, cex=0.5)
text(x+0.2, sy + 0.5, sy, cex=0.5)


a=case_num + 1.5
b=c/3
d=0.2
e=c/30
h=c/9
rect(a,b,a+d,b+e,col=4)
text(a+0.9,b+e/2,'I/O时间', cex=0.5)
b=b+h
rect(a,b,a+d,b+e,col=3)
text(a+0.9,b+e/2,'计算时间', cex=0.5)
b=b+h
rect(a,b,a+d,b+e,col=5)
text(a+0.9,b+e/2,'系统时间', cex=0.5)

dev.off()