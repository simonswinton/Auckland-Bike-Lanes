install.packages(c("readxl","httr","tidyverse"))
install.packages("fs")
install.packages("fs", type = "source")
install.packages("tidyverse")
install.packages("gsubfn")
install.packages("lubridate")
library(readxl) #Reading from the AT Data sets
library(httr) #For connecting to the AT website
library(tidyverse) 
library(gsubfn) #Used in the renaming
library(lubridate) #Used for rejigging dates
library(ggplot2) #Used for plotting
library(plyr)

month <- c("2016","2017","2018","dec","nov","oct","sep","aug","jul","jun","may","apr","mar","feb","jan","jan20","feb20","mar20","apr20") 
urls<- c("https://at.govt.nz/media/1972974/dailyakldcyclecountdata2016_updated.csv",
         "https://at.govt.nz/media/1975716/dailyakldcyclecountdata2017_1.csv",
         "https://at.govt.nz/media/1979436/dailyakldcyclecountdata2018.csv",
         "https://at.govt.nz/media/1981853/dec2019akldcyclecounterdata.csv",
         "https://at.govt.nz/media/1981725/nov2019akldcyclecounterdata.csv",
         "https://at.govt.nz/media/1981442/oct2019akldcyclecounterdata.xlsx",
         "https://at.govt.nz/media/1981056/sep2019akldcyclecounterdata.csv",
         "https://at.govt.nz/media/1980887/aug2019akldcyclecounterdata.csv",
         "https://at.govt.nz/media/1980617/july2019akldcyclecounterdata.csv",
         "https://at.govt.nz/media/1980376/jun2019akldcyclecounterdata.csv",
         "https://at.govt.nz/media/1980138/may2019akldcyclecounterdata.csv",
         "https://at.govt.nz/media/1980039/apr2019akldcyclecounterdata.csv",
         "https://at.govt.nz/media/1979807/mar2019akldcyclecounterdata.csv",
         "https://at.govt.nz/media/1979638/feb2019akldcyclecounterdata.xlsx",
         "https://at.govt.nz/media/1979442/january-2019-auckland-cycle-counter-data.csv",
         "https://at.govt.nz/media/1982096/jan2020akldcyclecounterdata.xlsx",
         "https://at.govt.nz/media/1982597/feb2020akldcyclecounterdata.csv",
         "https://at.govt.nz/media/1982595/march2020akldcyclecounterdata.csv",
         "https://at.govt.nz/media/1982742/april-2020-cycle-movement.csv"
)

#loading the data using the GET function and assigning to the month names
for (i in 1:19){
  x <- urls[i]
  end <- substr(x, nchar(x) - 3 + 1, nchar(x))
  if(end == "lsx"){GET(x, write_disk(tf <- tempfile(fileext = ".xlsx")))
    temp <- read_excel(tf)
  }else{
    GET(urls[i], write_disk(tf <- tempfile(fileext = ".csv")))
    temp <- read.csv(tf)
  }
  colnames(temp) <- tolower(gsub(" |\\.|_|cyclists","",colnames(temp)))
  temp <- temp %>% rename( date = names(temp)[1])
  assign(month[i],temp)
}

#Combining all of the columns filling the empty rows
all_bikes <- rbind.fill(`2016`,`2017`,`2018`,jan,feb, mar,apr,may,jun,jul,aug,sep,oct,nov,dec,jan20,feb20,mar20,apr20)

# Download as CSV file
write.csv(all_bikes, "all_bikes.csv")