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

# create 'Global Ative Power' scatterplot in png file
png(filename="plot2.png")
with(subsetdata, plot(time, Global_active_power, 
                      xlab="", ylab="Global Active Power (killowats)",
                      main="", type="l"))
dev.off()