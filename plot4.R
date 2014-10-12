# Store file name in a variable
file<-"household_power_consumption.txt"

# Read file within a handle
data<-read.table(file, header=TRUE, sep=";", colClasses="character", na.strings="?")

# Typecast Date column as R's date type
data$Date<-as.Date(data$Date, "%d/%m/%Y")

data$Global_active_power<-as.double(data$Global_active_power)
data$Global_reactive_power<-as.double(data$Global_reactive_power)
data$Voltage<-as.double(data$Voltage)
data$Global_intensity<-as.double(data$Global_intensity)

data$Sub_metering_1<-as.numeric(data$Sub_metering_1)
data$Sub_metering_2<-as.numeric(data$Sub_metering_2)
data$Sub_metering_3<-as.numeric(data$Sub_metering_3)


# data$Time<-strptime(data$Time, "%H:%M:%S")

# Only select data for 1st, 2nd Feb of 2007
data1<-data[data$Date == "2007-02-01" | data$Date == "2007-02-02", ]

dtm<-paste(as.character(data1$Date), data1$Time)

# Convert date-time stamp as epoch time in seconds
tmp<-as.POSIXct(strptime(dtm,"%Y-%m-%d %H:%M:%S", tz="EST"))

data1<-as.data.table(data1)
data1[,tmstmp:=tmp]

# Plot multiple graphs 

par(mfrow=c(2,2))

# Plot Row-1, Col-1
with(data1, plot(tmstmp, Global_active_power, 
                 type="l", 
                 xlab="datetime",
                 ylab="Global Active Power(kilowatts)"))
                 

#Plot Row-1, col-2
with(data1, plot(tmstmp, Voltage, 
                 type="l", 
                 xlab="datetime"))

# Plot Row-2, Col-1
with(data1, plot(tmstmp, Sub_metering_1, 
                 ylab="Energy Sub metering",
                 xlab="datetime",
                 type="n"))

legend("topright", 
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
       col=c("black", "red", "blue"), 
       lwd=1, pch=c(NA,NA,NA))

points(data1$tmstmp, data1$Sub_metering_1, type="l", lend=1, col="black")
points(data1$tmstmp, data1$Sub_metering_2, type="l", lend=1, col="red")
points(data1$tmstmp, data1$Sub_metering_3, type="l", lend=1, col="blue")

#Plot Row-2, col-2
with(data1, plot(tmstmp, Global_reactive_power, 
                 type="l", 
                 xlab="datetime"))

# Copy plot to a png file
dev.copy(png, file="plot4.png", width=480, height=480, units="px")

# Close graphics device
dev.off()
