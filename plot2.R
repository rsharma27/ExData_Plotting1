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

# data$Time<-strptime(data$Time, "%H:%M:%S")

# Only select data for 1st, 2nd Feb of 2007
data1<-data[data$Date == "2007-02-01" | data$Date == "2007-02-02", ]

dtm<-paste(as.character(data1$Date), data1$Time)

# Convert date-time stamp as epoch time in seconds
tmp<-as.POSIXct(strptime(dtm,"%Y-%m-%d %H:%M:%S", tz="EST"))

data1<-as.data.table(data1)
data1[,tmstmp2:=tmp]

# Plot a line graph between global active power & date-time columns
with(data1, plot(tmstmp, Global_active_power, 
                 type="l", 
                 main="Global Active Power",
                 xlab="Weekdays",
                 ylab="Global Active Power(kilowatts)"))

# Copy plot to a png file
dev.copy(png, file="plot2.png", width=480, height=480, units="px")

# Close graphics device
dev.off()
