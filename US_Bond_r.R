install.packages("xts")
install.packages("readr")
install.packages("sqldf")
install.packages("RH2")
install.packages("Quandl")
install.packages("dygraphs")
install.packages("shiny")
library(shiny)
library(dygraphs)
library(Quandl)
library(sqldf) #run sql statements in R
library(dplyr)
library(RH2)

df <- Quandl("FED/SVENY", api_key="15cxBvvbCzucYDswsDfJ")
covid_dates <- subset(df, Date > '2020-01-01' & Date < '2020-07-16')

str(df)
#covid_dates$Date <- format(as.Date(covid_dates$Date, format="%m/%d/%Y"),"%m/%d")

# time series data

dfasxts <- as.xts(x = df[, -1], order.by = df$Date)
covid_dates <- as.xts(x = covid_dates[, -1], order.by = covid_dates$Date)



dygraph(covid_dates, main = "Zero Coupon Yields (1-30) 2020", ylab = "Value") %>%
            dyAxis('x', axisLabelFontSize = 12) %>%
            dyLegend(labelsDiv = "legendDivID") %>%
            dyRangeSelector()

  
#get legend on outside

#convert date column to date class
df$Date <- as.Date(df$Date)

#covid_dates$Date <- as.Date(covid_dates$Date)




df$year <- format(as.Date(df$Date, format="%m/%d/%Y"),"%Y")






df <- select(df, -Date)


df <- na.omit(df)



df <- df %>%
  group_by(year) %>%
  summarise_all(mean)


#make dashboard with interactive filter for covid dates, and df

df

#do project normally

write.table(df, file="bondyield.csv", row.names=F, sep = ",")

# plotting the evaluation of bond yields
library(viridisLite)
library(magma)
yields <- dfasxts
plot.type <- "single"
plot.palette <- magma(n = 30)
asset.names <- colnames(dfasxts)
plot.zoo(x = dfasxts, plot.type = "single", col = plot.palette, ylab = "", xlab = "")
legend(x = "topright", legend = asset.names, col = plot.palette, cex = 0.45, lwd = 3)

#differentiate time series analysis
dfasxts_d <- diff(dfasxts)

plot.zoo(x = dfasxts_d, plot.type = "multiple", ylim = c(-0.5, 0.5), cex.axis = 0.7, ylab = 1:30, col = plot.palette, main = "", xlab = "")
