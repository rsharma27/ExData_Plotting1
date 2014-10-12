# Store file name in a variable
file<-"household_power_consumption.txt"

# Read file within a handle
data<-read.table(file, header=TRUE, sep=";", colClasses="character", na.strings="?")

# Typecast Date column as R's date type
data$Date<-as.Date(data$Date, "%d/%m/%Y")

# Only select data for 1st, 2nd Feb of 2007
data1<-data[data$Date == "2007-02-01" | data$Date == "2007-02-02", ]

# Plot a histogram on global active power column
hist(as.numeric(data1$Global_active_power), 
     col="Red", 
     main="Global Active Power",
     xlab="Global Active Power (kilowatts)")

# Copy plot to a png file
dev.copy(png, file="plot1.png", width=480, height=480, units="px")

# Close graphics device
dev.off()
