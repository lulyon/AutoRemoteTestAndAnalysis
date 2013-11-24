library(Cairo)
CairoFonts(regular = "WenQuanYi Micro Hei",
           bold = "WenQuanYi Micro Hei")


argv <- commandArgs(TRUE)

# logdata working dir
# setwd("~/workspace/R/logdata")
setwd(as.character(argv[1]))



total_casefactor_table_filename <- "total_casefactor_table.txt"

data <- read.table(total_casefactor_table_filename, header=TRUE)

case_num <- nrow(data)
x<-1:case_num
emax=data[,4]
emin=data[,6]
emean=data[,5]
w=data[,2]
a=min(emean)
b=max(emean)
c=emean%*%w
emax=signif(emax, digits=2)
emin=signif(emin, digits=2)
emean=signif(emean, digits=2)
c=signif(c, digits =3)

he=max(emax)

CairoPNG(paste("parallel_proficiency", ".png", sep=""))
plot(x, type='n', xlim=c(0, case_num + 3), ylim=c(0, 1), main='并行效率分析', xlab='测试用例', ylab='并行效率', xaxt='n', yaxt='n')
axis(side=1, at=1:case_num)
axis(side=2, at=seq(0, he*1.1, 0.1))

rect(x-0.3,emin,x+0.3,emax,col='white')
rect(x-0.3,emean-0.005,x+0.3,emean+0.005,col='red')
rect(x-0.3,emax-0.005,x+0.3,emax+0.005,col='blue')
rect(x-0.3,emin-0.005,x+0.3,emin+0.005,col='yellow')
k=b/30
text(x,emin+k,emin,ps=0.5, cex=0.5)
text(x,emean+k,emean, cex=0.5)
text(x,emax+k,emax, cex=0.5)
abline(h=0.2,lty=1,lwd=4,col='red')
text(case_num + 1.5, 0.2,'0.2', cex=0.5)
abline(h=c,lwd=2,lty=4,col='red')
text(case_num + 1.5, c+k,'算法并行效率', cex=0.5)
text(case_num + 1.5, c-k,c, cex=0.5)
abline(h=0.5,lty=1,lwd=4,col='blue')
text(case_num + 1.5, 0.5,'0.5', cex=0.5)
rect(case_num + 1, 0.95, case_num + 0.5, 0.96,col='blue')
rect(case_num + 1, 0.99, case_num + 0.5, 1, col='red')
text(case_num + 2.2, 0.95, '合同要求的并行效率均值的最低值', cex=0.3)
text(case_num + 2.2, 0.99, '合同要求的并行效率峰值的最低值', cex=0.3)

dev.off()
