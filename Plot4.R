## Exploratory Data Analysis
## Project Course Week 1
## Fourth graph : all measures with 4 plots on the same graph

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


## Fourth graph : all measures with 4 plots on the same graph

png(filename='plot4.png',width=480,height=480,units='px')  ## Open the PNG device
par(mfrow = c(2, 2))                       ## Set a 2 by 2 graph (ordered in rows)

## 1
plot(clean$DateTime,clean$Global_active_power,
     type = "l",                                   ## for a line
     xlab = "",                                    ## for no label on the x axis
     ylab = "Global Active Power")                 ## to give a specified label to y axis

## 2
plot(clean$DateTime,clean$Voltage,
     type = "l",                                   ## for a line
     xlab = "datetime",                            ## for no label on the x axis
     ylab = "Voltage")                             ## to give a specified label to y axis

## 3
plot(clean$DateTime,clean$Sub_metering_1,  ## 1st plot with Sub_metering_1
     type = "l",                           ## type of the plot : line
     xlab = "",                            ## no label on the x axis
     ylab = "Energy sub metering")         ## to give a label to the y axis

lines(clean$DateTime,clean$Sub_metering_2, ## add Sub_metering_2 on the graph
      type = "l",                          ## type of the plot : line
      col="red")                           ## color of the line : red

lines(clean$DateTime,clean$Sub_metering_3, ## add Sub_metering_3 on the graph
      type = "l",                          ## type of the plot : line
      col="blue")                          ## color of the line : red

legend("topright",                         ## positionning the legend at the top right of the graph
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
       ## name of each legend
       bty = "n",                          ## no box around the legend
       lty = "solid",                      ## lines type
       col=c("black","red","blue"))        ## color of each legend line

## 4
plot(clean$DateTime,clean$Global_reactive_power,
     type = "l",                                   ## for a line
     xlab = "datetime")                            ## for no label on the x axis

dev.off()         ## Close the device  



