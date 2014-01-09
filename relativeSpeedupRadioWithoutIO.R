library(Cairo)
CairoFonts(regular = "WenQuanYi Micro Hei",
           bold = "WenQuanYi Micro Hei")


argv <- commandArgs(TRUE)


# logdata working dir
# setwd("~/workspace/R/logdata")
setwd(as.character(argv[1]))

total_casefactor_table_filename <- "cpu_casefactor_table.txt"

data <- read.table(total_casefactor_table_filename, header=TRUE)

case_num <-nrow(data)
sp<-data[,7]
x<-1:case_num
w=data[,1]
a=min(sp)
b=max(sp)
c=sp%*%w
a=round(a, digits=2)
b=round(b, digits=2)
c=round(c, digits=3)

CairoSVG(paste("relative_speedup_radio_without_io", ".svg", sep=""))
plot(x, type='n', xlim=c(0, case_num + 3), ylim=c(0, b*1.1), main='相对加速比分析（不含IO）', xlab='测试用例', ylab='相对加速比', xaxt='n', yaxt='n')
axis(side=1, at=1:case_num)
axis(side=2, at=seq(0,1.1*b,0.1))

rect(x-0.2,0,x+0.2,sp,col=5)
abline(h=a,lty=2,lwd=0.5,col=4)
abline(h=b,lty=2,lwd=0.5,col=4)
abline(h=c,lty=1,lwd=4,col=2)
k=b/30
text(case_num + 2, a+k, '最小加速比', cex=0.5)
text(case_num + 2, a-k, a, cex=0.5)
text(case_num + 2, b+k,'最大加速比', cex=0.5)
text(case_num + 2, b-k, b, cex=0.5)
text(case_num + 2, c+k, '平均加速比', cex=0.5)
text(case_num + 2, c-k, c, cex=0.5)

dev.off()
