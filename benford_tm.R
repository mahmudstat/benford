#' @title Checks Benford law
#'
#' @description Checks whether a collection of numbers follows benford law
#'
#' @param x
#' @param n
#' @param bar
#'
#' @return ben_df2
#'
#' @examples x= sample(100,60)
#' ben(x, bar=TRUE)
#'
#' @export

#A function to test compatability with benford law
ben=function(x,n=1, bar=FALSE){
	x1=round(x,0)
x2=ifelse(x1<0,x1*(-1),x1)
x3=as.character(x2)
y1=strsplit(x3, "")
#Get the nth/first elemenet from each list element
y2=lapply(y1, '[[',n)
#Unlist it to make it character
y3=unlist(y2)
#Make it integer
y4=as.integer(y3)
#Find out NA
y5=which(is.na(y4))
#Remove NA
y6=subset(y4,!is.na(y4))
y7=table(y6)
y8=round(y7*100/sum(y7),2)
if (bar==TRUE){
ben_bar=barplot(y8, ylim=c(0,max(y8)+mean(y8)))
text(ben_bar, label=paste0(y8,"%"), y=y8, pos=1, cex=0.8)
}
exp=round(log(1+1/(1:9))*100,2)
ben_df=as.data.frame(y7,exp)
Prob=round(ben_df$Freq/sum(ben_df$Freq),2)
Perc=paste0(Prob*100,"%")
ben_df2=data.frame(Digit=ben_df$y6, Freq=ben_df$Freq,
Prob,Perc, Expected=paste0(exp,'%'))
ben_df2
	}
