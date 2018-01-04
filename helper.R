

library('dplyr')
library('tidyr')
library('ggplot2')
library(lubridate)
library(NLP)
library(tm)
library(wordcloud)
library(wordcloud2)
library(data.table)
grotime = read.csv("grotime.csv")
date = read.csv( "year.csv")
grodate2 = read.csv("groyear1.csv")
grosize = read.csv("grosize.csv")
data = read.csv("Airplane_Crashes_and_Fatalities_Since_1908.csv")
word_cloud = read.csv("wordcount.csv")
data = data[!is.na(data$Fatalities) &!is.na(data$Aboard), ]
data = data %>% mutate(death_ratio = Fatalities/Aboard)

############time###############
data_date = data[!(data$Time == ""),]
data_date$Time= as.character(data_date$Time)
# covert Time from xx:xx to xx
for (i in 1:length(data_date$Time)){
  data_date$Time[i] = gsub( ":.*$", "", data_date$Time[i] )
  
}

data_date$Time = as.numeric(data_date$Time) 

#remove "c" row
time=data_date
time$Time = as.integer(time$Time)
grotime = summarise(time %>% group_by(Time),count = n(),Fatal = sum(Fatalities),Ratio = sum(Fatalities)/sum(Aboard))
grotime = grotime[grotime$Time <25 & grotime$Time >= 0 & !is.na(grotime$Time),]
##############time##############

##############date##############
#options("scipen"=100, "digits"=4)
#date = data[!data$Date == "",]
#date1 = data[-1,]
#date = data[-1,]
#date$Date = as.Date(date1$Date,format='%m/%d/%Y')
#for (i in 1 : length(date$Date)){
#  if (date$Date[i]<"0012-07-12"){
#    year(date$Date[i]) = year(date$Date[i])+2000
#  }else{
#    year(date$Date[i]) = year(date$Date[i])+1900
#  }
#}
#write.csv(date,file = "year1.csv")
###change date to year
date$Date = year(date$Date)
grodate = summarise(date %>% group_by(Date),count = n(),Fatal = sum(Fatalities), Ratio = sum(Fatalities)/sum(Aboard))
date$Date = as.integer(date$Date)
class(date$Date)

grodate2 = date %>% 
  group_by(gr=cut(Date, breaks= seq(1910, 2010, by = 10), right=F)) %>% 
  summarise(count = n(),Fatal = sum(Fatalities),Ratio = sum(Fatalities)/sum(Aboard)) %>%
  arrange(gr)
grodate2$gr = as.character(grodate2$gr)
class(grodate2$gr)
u = 1910
for (i in 1:length(grodate2$gr)){
  grodate2$gr[i] = u
  u = u + 10 
}

grodate2$gr = as.Date(grodate2$gr,"%Y")
pl1 = ggplot(date, aes(x=Date)) + 
  geom_histogram(binwidth = 0.25, color=rgb(0.2,0.7,0.1,0.4), fill=rgb(0.2,0.7,0.1,0.4) )

pl2 = ggplot(grodate2, aes(x=gr, y = Fatal)) + 
  geom_histogram(binwidth = 0.25, color="#8A958F", fill=rgb(0.2,0.7,0.1,0.4),stat = "identity" )+ 
  geom_line(aes(y = Ratio*20000),color="#ECB082",size = 1)+ scale_y_continuous(sec.axis = sec_axis(~./20000, name = "Death Ratio"))
#########made########
made = date %>% mutate(made = ifelse(grepl("Boeing", date$Type),"Boeing",ifelse(grepl("Airbus", date$Type),"Airbus",ifelse(grepl("Cessna", date$Type),'Cessna',ifelse(grepl("Embraer", date$Type),'Embraer',ifelse(grepl("Tupoloev", date$Type),'Tupoloev',ifelse(grepl("BAe", date$Type),'BAe',ifelse(grepl("Douglas", date$Type),'Douglas',ifelse(grepl("Antonov", date$Type),'Antonov',ifelse(grepl("de Havilland", date$Type),'de Havilland',ifelse(grepl("CRJ", date$Type),'CRJ',"Others")))))))))))
made1 = made[!made$made == "Others",]



