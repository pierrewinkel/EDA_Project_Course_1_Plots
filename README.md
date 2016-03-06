# Exploratory Data Analysis - Project Course Week 1

## Introduction

This assignment uses data from
the <a href="http://archive.ics.uci.edu/ml/">UC Irvine Machine
Learning Repository</a>, a popular repository for machine learning
datasets. In particular, I used  the "Individual household
electric power consumption Data Set" which R.D. Peng have made available on
the course web site:


* <b>Dataset</b>: <a href="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip">Electric power consumption</a> [20Mb]

* <b>Description</b>: Measurements of electric power consumption in
one household with a one-minute sampling rate over a period of almost
4 years. Different electrical quantities and some sub-metering values
are available.


The following descriptions of the 9 variables in the dataset are taken
from
the <a href="https://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption">UCI
web site</a>:

<ol>
<li><b>Date</b>: Date in format dd/mm/yyyy </li>
<li><b>Time</b>: time in format hh:mm:ss </li>
<li><b>Global_active_power</b>: household global minute-averaged active power (in kilowatt) </li>
<li><b>Global_reactive_power</b>: household global minute-averaged reactive power (in kilowatt) </li>
<li><b>Voltage</b>: minute-averaged voltage (in volt) </li>
<li><b>Global_intensity</b>: household global minute-averaged current intensity (in ampere) </li>
<li><b>Sub_metering_1</b>: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered). </li>
<li><b>Sub_metering_2</b>: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light. </li>
<li><b>Sub_metering_3</b>: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.</li>
</ol>

## Loading the data

* I made a rough size estimation : 
Dataset with 2.075.000 rows and 9 columns : 2.075.000 x 9 x 8 bytes = 150.000.000
= 150.000.000 / 2^20 bytes/MB = 150 MB / 2^10 MB/GB
= 0,150 GB

  I therefore need 0,15 x 2 = 0,3 GB of RAM : OK for my 8 GB RAM MacBook.

* As I am french, I need to change the R setting in order to get the weekdays in english
```
curr_locale <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME","en_US.UTF-8")
## To come back to local setting
## Sys.setlocale("LC_TIME",curr_locale)
```

* Set working directory
```
setwd("~/Coursera/Exploring Data/Week 1")
## getwd()
## [1] "/Users/pierrewinkel/Coursera/Exploring Data/Week 1"
```

* Set libraries
```
library(data.table)
library(dplyr)
```

* Downloads the zip file in a "data" directory
```
if (!file.exists("data")){
        dir.create("data")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile = "./data/data.zip")
```

* Unzips the file in the "data" directory                        
```
unzip ("./data/data.zip", exdir = "./data/")
```

* Creates data table with the read.csv function
```
data <- data.table(read.csv("./data/household_power_consumption.txt", sep = ";",stringsAsFactors=FALSE))
```

Let's have a look to the dimension and the classes
```
str(data)
Classes ‘data.table’ and 'data.frame':	2075259 obs. of  9 variables:
  $ Date                 : chr  "16/12/2006" "16/12/2006" "16/12/2006" "16/12/2006" ...
  $ Time                 : chr  "17:24:00" "17:25:00" "17:26:00" "17:27:00" ...
  $ Global_active_power  : chr  "4.216" "5.360" "5.374" "5.388" ...
  $ Global_reactive_power: chr  "0.418" "0.436" "0.498" "0.502" ...
  $ Voltage              : chr  "234.840" "233.630" "233.290" "233.740" ...
  $ Global_intensity     : chr  "18.400" "23.000" "23.000" "23.000" ...
  $ Sub_metering_1       : chr  "0.000" "0.000" "0.000" "0.000" ...
  $ Sub_metering_2       : chr  "1.000" "1.000" "2.000" "1.000" ...
  $ Sub_metering_3       : num  17 16 17 17 17 17 17 17 17 16 ...
  - attr(*, ".internal.selfref")=<externalptr> 
```

* Transforms the "Date" factor into a date format : yyyy-mm-dd 
```
data$Date <- as.Date(data$Date, "%d/%m/%Y")

str(data)
Classes ‘data.table’ and 'data.frame':	2075259 obs. of  9 variables:
  $ Date                 : Date, format: "2006-12-16" "2006-12-16" ...
  $ Time                 : chr  "17:24:00" "17:25:00" "17:26:00" "17:27:00" ...
  $ Global_active_power  : chr  "4.216" "5.360" "5.374" "5.388" ...
```

* Creates a datatable "dt" containing only the 2007-02-01 and 2007-02-02 observations.
```
dt <- filter (data, Date=="2007-02-01")
dt <- rbind(dt,filter(data, Date=="2007-02-02"))
```
We have now a datatable with only 2880 rows and 9 columns
```
str(dt)
Classes ‘data.table’ and 'data.frame':	2880 obs. of  9 variables
```

* Creates a new column with the date and time concatenated
```
dates <- dt$Date
times <- dt$Time
x <- paste(dates,times)
y <- strptime(x,"%Y-%m-%d %H:%M:%S")

str(y)
POSIXlt[1:2880], format: "2007-02-01 00:00:00" "2007-02-01 00:01:00" "2007-02-01 00:02:00" ...

dt <- cbind(y,dt)
  Warning message:
  In data.table::data.table(...) :
  POSIXlt column type detected and converted to POSIXct. We do not recommend use of POSIXlt 
  at all because it uses 40 bytes to store one date.
```

* Removes the old Date and Time columns
```
clean <- subset(dt,select=-c(Date,Time))
```

* Replaces the name "y" by the name "Date/Time"
```
setnames(clean, "y", "DateTime")
str(clean)
Classes ‘data.table’ and 'data.frame':	2880 obs. of  8 variables:
  $ DateTime             : POSIXct, format: "2007-02-01 00:00:00" "2007-02-01 00:01:00" ...
  $ Global_active_power  : chr  "0.326" "0.326" "0.324" "0.324" ...
  $ Global_reactive_power: chr  "0.128" "0.130" "0.132" "0.134" ...
  $ Voltage              : chr  "243.150" "243.320" "243.510" "243.900" ...
  $ Global_intensity     : chr  "1.400" "1.400" "1.400" "1.400" ...
  $ Sub_metering_1       : chr  "0.000" "0.000" "0.000" "0.000" ...
  $ Sub_metering_2       : chr  "0.000" "0.000" "0.000" "0.000" ...
  $ Sub_metering_3       : num  0 0 0 0 0 0 0 0 0 0 ...
  - attr(*, ".internal.selfref")=<externalptr> 
```

* Converts the character class into numeric
```
clean$Global_active_power <- as.numeric(clean$Global_active_power)
clean$Global_reactive_power <- as.numeric(clean$Global_reactive_power)
clean$Voltage <- as.numeric(clean$Voltage)
clean$Global_intensity <- as.numeric(clean$Global_intensity)
clean$Sub_metering_1 <- as.numeric(clean$Sub_metering_1)
clean$Sub_metering_2 <- as.numeric(clean$Sub_metering_2)
clean$Sub_metering_3 <- as.numeric(clean$Sub_metering_3)

str(clean)
Classes ‘data.table’ and 'data.frame':	2880 obs. of  8 variables:
  $ DateTime             : POSIXct, format: "2007-02-01 00:00:00" "2007-02-01 00:01:00" ...
  $ Global_active_power  : num  0.326 0.326 0.324 0.324 0.322 0.32 0.32 0.32 0.32 0.236 ...
  $ Global_reactive_power: num  0.128 0.13 0.132 0.134 0.13 0.126 0.126 0.126 0.128 0 ...
  $ Voltage              : num  243 243 244 244 243 ...
  $ Global_intensity     : num  1.4 1.4 1.4 1.4 1.4 1.4 1.4 1.4 1.4 1 ...
  $ Sub_metering_1       : num  0 0 0 0 0 0 0 0 0 0 ...
  $ Sub_metering_2       : num  0 0 0 0 0 0 0 0 0 0 ...
  $ Sub_metering_3       : num  0 0 0 0 0 0 0 0 0 0 ...
  - attr(*, ".internal.selfref")=<externalptr> 
```

## Making Plots

Our overall goal here is simply to examine how household energy usage
varies over a 2-day period in February, 2007.

For each plot I have :

* Constructed the plot and save it to a PNG file with a width of 480
pixels and a height of 480 pixels.

* Named each of the plot files as `plot1.png`, `plot2.png`, etc.

* Created a separate R code file (`plot1.R`, `plot2.R`, etc.) that
constructs the corresponding plot, i.e. code in `plot1.R` constructs
the `plot1.png` plot. The code file includes code for reading
the data so that the plot can be fully reproduced.

* The PNG files and R code files are available on this git repository

