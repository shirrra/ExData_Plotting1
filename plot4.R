if (!file.exists("household_power_consumption_subset.saved.R")){
        print("loading data from web and processing, might take a while")

        # downloading file
        zipurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        tempzip <- tempfile()
        download.file(zipurl,tempzip)
        unzip(tempzip)
        unlink(tempzip)
        
        # read the entire table and process it
        data  <- read.table("household_power_consumption.txt", colClasses=c("character","character",rep("numeric",7)),
                            header=T, sep=";", nrows=-1, strip.white=T, na.strings="?")
        data$time <- dmy_hms(paste(data$Date, data$Time))
        data$Date <- NULL
        data$Time <- NULL
        
        # subset and save data from first two day of Feb 2007
        subsetdata <- data[data$time<dmy("03/02/2007") & data$time>dmy("01/02/2007"),]
        save(subsetdata, file="household_power_consumption_subset.saved.R")
        
        # clean the environment and apply garbage collector
        rm(data)
        gc()
} else {
        print("loading saved data")
        load("household_power_consumption_subset.saved.R")
}

# create four plots in png file
png(filename="plot4.png")
par(mfrow=c(2,2))
par(mar=c(4.1,4.1,3.1,2.1))
par(cex=0.75) #default 0.83
par(oma=c(1,0.3,0,0))
par(pty="m")

#plot(1,1)
with(subsetdata, plot(time, Global_active_power, 
                      xlab="", ylab="Global Active Power",
                      main="", type="l"))

#plot(1,2)
with(subsetdata, plot(time, Voltage, 
                      xlab="datetime", ylab="Voltage",
                      main="", type="l"))

#plot(2,1)
with(subsetdata, plot(time, Sub_metering_1, type="l",
                      xlab="", ylab="Energy sub metering", main=""))
with(subsetdata, lines(time, Sub_metering_2, col="red"))
with(subsetdata, lines(time, Sub_metering_3, col="blue"))
leg.txt <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
leg.col <- c("black", "red", "blue")
leg.lwd <- c(1,1,1)
legend("topright", legend=leg.txt, col=leg.col, lwd=leg.lwd, bty="n")

#plot(2,2)
with(subsetdata, plot(time, Global_reactive_power, 
                      xlab="datetime", ylab="Global_reactive_power",
                      main="", type="l"))

dev.off()