## Exploratory Data Analysis
## Project Course Week 1
## First Graph : histogram of Global Active Power

## Set libraries
library(data.table)
library(dplyr)

## Downloads the zip file in a "data" directory
if (!file.exists("data")){
        dir.create("data")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile = "./data/data.zip")

## Unzips the file in the "data" directory                        
unzip ("./data/data.zip", exdir = "./data/")

## Creates data table with the read.csv function
data <- data.table(read.csv("./data/household_power_consumption.txt", sep = ";",stringsAsFactors=FALSE))

## Transforms the "Date" factor into a date format : yyyy-mm-dd 
data$Date <- as.Date(data$Date, "%d/%m/%Y")

## Creates a datatable "dt" containing only the 2007-02-01 and 2007-02-02 observations
dt <- filter (data, Date=="2007-02-01")
dt <- rbind(dt,filter(data, Date=="2007-02-02"))
## We have now a datatable with only 2880 rows and 9 columns

## Creates a new column with the date and tim concatenated
dates <- dt$Date
times <- dt$Time
x <- paste(dates,times)
y <- strptime(x,"%Y-%m-%d %H:%M:%S")

dt <- cbind(y,dt)
## Warning message:
## In data.table::data.table(...) :
## POSIXlt column type detected and converted to POSIXct. We do not recommend use of POSIXlt 
## at all because it uses 40 bytes to store one date.

## Removes the old Date dans Time columns
clean <- subset(dt,select=-c(Date,Time))

## Replace the name "y" by the name "Date/Time"
setnames(clean, "y", "DateTime")

## Converts the character class into numeric
clean$Global_active_power <- as.numeric(clean$Global_active_power)
clean$Global_reactive_power <- as.numeric(clean$Global_reactive_power)
clean$Voltage <- as.numeric(clean$Voltage)
clean$Global_intensity <- as.numeric(clean$Global_intensity)
clean$Sub_metering_1 <- as.numeric(clean$Sub_metering_1)
clean$Sub_metering_2 <- as.numeric(clean$Sub_metering_2)
clean$Sub_metering_3 <- as.numeric(clean$Sub_metering_3)

## First Graph : histogram of Global Active Power

png(filename='plot1.png',width=480,height=480,units='px')  ## Open the PNG device

hist(clean$Global_active_power,                    ## plot the histogram
     main = "Global Active Power",              ## main = to give a title
     xlab = "Global Active Power (kilowatts)",  ## xlab to give a specified nam to the x axis
     col="red",                                 ## col to give a color to the histogram
     ylim=c(0,1200))                            ## ylim to precise the limit of the y axis
## (otherwise the limit is NULL) : 
## we don't get the "1200"

dev.off()      ## Close the device                       


