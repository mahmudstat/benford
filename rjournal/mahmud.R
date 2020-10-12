ben <- function(x, plot=TRUE, title=NULL){
  #Make all positive
  x1 <- abs(x)
  x2 <- as.character(x1)
  y1 <- strsplit(x2, "")
  #Get the first elemenet from each list element
  y2 <- lapply(y1, '[[',1)
  #Unlist it to make it character
  y3 <- unlist(y2)
  #Make it integer again
  y4 <- as.integer(y3)
  #Remove NA
  y6 <- subset(y4,!is.na(y4))
  y7 <- table(y6)
  y8 <- round(prop.table(y7)*100,2)
  exp_perc <- round(log10(1+1/(1:9))*100,2)
  #Data frame
  library(dplyr)
  df_init <- data.frame(Digit=as.numeric(1:9), Exp_Perc=exp_perc)
  
  #Convert the table to a dataframe
  ben_df <- as.data.frame(y8)
  
  #Convert the digit (y6) column to numeric as required for left_join
  ben_df$y6 <- as.numeric(levels(ben_df$y6))[ben_df$y6]
  ben_df$Obs_Freq <- as.data.frame(y7)$Freq
  
  
  #Make Digit column name same as in df_init
  names(ben_df) <- c("Digit", "Obs_Perc", "Obs_Freq")
  df_final <- df_init %>% left_join(ben_df, by="Digit")
  #Missing values to 0
  df_final[is.na(df_final)] <- 0
  #Barplot
  #par(family="serif")
  par( cex.lab=1.2, cex.main=1.1)
  chi=chisq.test(x=df_final$Obs_Freq,p=exp_perc/100)
  #Leemis test
  m <- sqrt(sum(df_final$Obs_Freq))*max(abs(exp_perc/100-
                                              df_final$Obs_Perc/100))
  d <- sqrt(sum(df_final$Obs_Freq)*sum((df_final$Obs_Perc/100-
                                          exp_perc/100)^2))
  if (plot==TRUE){
    plot(exp_perc, xlab="Digit",cex=1.2,
         ylab="Percentage of frequency",pch=19,
         main=paste0("Benford Law for ", title, " Data"),
         ylim=c(0,max(df_final$Exp_Perc, df_final$Obs_Perc)+10))
    points(df_final$Obs_Perc, pch=19, col="red", cex=1.2)
    lines(exp_perc, col="black")
    lines(df_final$Obs_Perc, col="red")
    legend("topright", 
           legend=c("Expected","Observed"), lwd=1,
           col=c("black", "red", "darkslategray4"), pch=19, cex=1.1)
    axis(1, at=1:9, labels=1:9)
    # text(ben_bar, label=paste0(df_final$Obs_Perc,"%"),
    # y=df_final$Obs_Perc, pos=1, col="black")
  }
  #Bar ends
  #Make a list 
  ben_list <- list(Table=df_final, "Leemis's"=m, "Cho-Gaines'd"=d,
                   "Pearson's chi-square test p-value"=chi$p.value)
  ben_list
}

#Reading data
flood <- read.csv("flood.csv")
quake <- read.csv("quake.csv")
war <- read.csv("war.csv")
accident <- read.csv("accident.csv")

#Testing accidents data
par(mfrow=c(2,2))
ben(flood$x, title = "Floods")
ben(quake$x, title = "Earthquakes")
ben(war$x, title = "Wars")
ben(accident$x, title = "Accidents")

#Population result
pop_test <- read.csv("pop_sub.csv")

m_old=c()
m_new=c()
p_old=c()
p_new=c()
d_old=c()
d_new=c()
for (i in 1960:2016) {
  popyr=pop_test %>% filter(Year==i) %>% select("Value")
  benyr=ben(popyr$Value, plot=FALSE)
  m_old=benyr$`Leemis's`
  m_new=c(m_new,m_old)
  p_old=benyr$`Pearson's chi-square test p-value`
  p_new=c(p_new,p_old)
  d_old=benyr$`Cho-Gaines'd`
  d_new=c(d_new, d_old)
}

m_new
p_new
d_new

pop_2 <- tibble(year=1960:2016, "Chi-square p-value" =p_new, 
                  "Leemis' m"=m_new, 
                  "Cho-Gaines'd"=d_new)

library(tidyverse)
pop_2 <- pop_2 %>%
  gather("Chi-square p-value", `Leemis' m`, `Cho-Gaines'd`, key="statistic",
         value="value")
ggplot(pop_2, aes( x=year, y=value, color=statistic))+
  geom_line()+geom_point()+facet_wrap(~statistic, nrow=3)+
  ggtitle("Tests of conformity of Benford's law with 
          world populations")
