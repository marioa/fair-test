# Sample code that will download data of births and deaths from the 
# national registry in Scotland. The data will be saved locally but
# will not be added/uploaded to the git repository.

library(readr)      # To read data.
library(dplyr)      # To manipulate data.
library(ggplot2)    # To plot data.
library(scales)     # Mainly for the use of percents in plots

library(tidymodels) # For modelling
library(parsnip)    # Also for modelling

# Get the birth data if it has not already been downloaded
if(!file.exists("../Data/births.zip")){
  download.file("https://www.nrscotland.gov.uk/files//statistics/time-series/birth-21/births-time-series-21-bt.1.zip", destfile = "../Data/births.zip")

}

# Births - skip the first 5 lines
births <- read_csv("../Data/births.zip", show_col_types = FALSE, skip = 5, col_select = c(1:4))

# Name the columns
names(births) <- c("Year", "Total", "Males", "Females")

# Remove the last three rows (contains copyright)
births <- births[1:(nrow(births)-3),]

# Set the year as a number
births$Year <- as.integer(births$Year)

# Plot the births
births %>% ggplot(aes(x = Year)) + geom_line(aes(y = Males), colour = "blue") +
           geom_line(aes(y = Females), colour = "pink") + theme_bw() +
           labs(y = "Number of births")

# Use points
births %>% ggplot(aes(x = Males, y = Females)) + geom_point(alpha = 0.2) +
           theme_bw() +
           labs(y = "Number of Female birth", x = "Number of Male births")

# Colour in by decade
births %>% mutate(Decade = factor(Year - Year%%10)) %>% 
           ggplot(aes(x = Males, y = Females, colour = Decade)) + 
           geom_point(alpha = 0.75) +
           theme_bw() +
           labs(y = "Number of Female birth", x = "Number of Male births")

# Do a linear fit
(birthm <- lm(data = births, formula = Females ~ Males))

# Use points
births %>% ggplot(aes(x = Males, y = Females)) + geom_point(alpha = 0.2) +
           theme_bw() +
           labs(y = "Number of Female birth", x = "Number of Male births") +
           geom_abline(intercept = -277.8160, slope = 0.9554, colour = "red", lty = 2)

# Plot the difference
births %>% ggplot(aes(x = Year, y = (Males - Females)/Total)) + 
           geom_bar(stat = "identity", fill = "red", colour ="black") +
           scale_y_continuous(labels = percent) +
           theme_bw() + labs(y = "Number of Male - Female births as a percentage of the total")

# Get the death by gender data if it has not already been downloaded
if(!file.exists("../Data/deaths.zip")){
  download.file("https://www.nrscotland.gov.uk/files//statistics/time-series/death-21/deaths-time-series-21-dt.1.zip", destfile = "../Data/deaths.zip")

}

# Read the death data
deaths <- read_csv("../Data/deaths.zip", show_col_types = FALSE, skip = 5, col_select = c(1:4))

# Name the columns
names(deaths) <- c("Year", "Total", "Males", "Females")

# Remove the last ten rows (contains copyright)
deaths <- deaths[1:(nrow(deaths)-10),]

# Set the year as a number
deaths$Year <- as.integer(deaths$Year)

# Plot the Deaths
deaths %>% ggplot(aes(x = Year)) + geom_line(aes(y = Males), colour = "blue") +
           geom_line(aes(y = Females), colour = "pink") + theme_bw() +
           labs(y = "Number of deaths")

# Use points
deaths %>% ggplot(aes(x = Males, y = Females)) + geom_point(alpha = 0.2) +
           theme_bw() +
           labs(y = "Number of Female deaths", x = "Number of Male deaths")

# Use points classified by decade
deaths %>% mutate(Decade = factor(Year - Year%%10)) %>% 
           ggplot(aes(x = Males, y = Females, colour = Decade)) + 
           geom_point(alpha = 0.75) +
           theme_bw() +
           labs(y = "Number of Female deaths", x = "Number of Male deaths")

# Use points classified by century
deaths %>% mutate(Century = factor(Year - Year%%100)) %>% 
           ggplot(aes(x = Males, y = Females, colour = Century)) + 
           geom_point(alpha = 0.75) +
           theme_bw() +
           labs(y = "Number of Female deaths", x = "Number of Male deaths")

