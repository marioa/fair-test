# Sample code that will download data of births and deaths from the 
# national registry in Scotland. The data will be saved locally but
# will not be added/uploaded to the git repository.

library(readr)      # To read data.
library(dplyr)      # To manipulate data.
library(ggplot2)    # To plot data.
library(scales)     # Mainly for the use of percents in plots
library(tidyr)      # To change from wide to long format
library(ggrepel)

library(tidymodels) # For modelling
library(parsnip)    # Also for modelling


# Scotland's population ---------------------------------------------------


## Births ------------------------------------------------------------------

# https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/births/births-time-series-data


### Get the data ------------------------------------------------------------


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


### Simple plots ------------------------------------------------------------

# Plot the births
births %>% ggplot(aes(x = Year)) + geom_line(aes(y = Males), colour = "blue") +
           geom_line(aes(y = Females), colour = "pink") + theme_bw() +
           labs(y = "Number of births") 


# Change to long format and plot
births %>% pivot_longer(cols = c("Males", "Females"), 
                        names_to = "Sex", 
                        values_to = "Numbers")     %>% 
           ggplot(aes(x = Year, y = Numbers, colour = Sex)) +
           geom_line() +
           labs(y = "Number of births") +
           theme_bw()

# Change to long format and plot
births %>% pivot_longer(cols = c("Males", "Females"), 
                        names_to = "Sex", 
                        values_to = "Numbers")     %>% 
           ggplot(aes(x = Year, y = Numbers, colour = Sex)) +
           geom_line() +
           geom_point(size = 0.75) +
           labs(y = "Number of births") +
           guides(colour = "none") +
           geom_label_repel(data = ~subset(., Year == max(Year)), aes(label = Sex), nudge_x = -10) +
           theme_bw()

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


### Line fitting ------------------------------------------------------------

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

# See https://en.wikipedia.org/wiki/Human_sex_ratio

# Look at the distribution of the residuals of least squares
l <- lm(data = births, formula = Females ~ Males)

# Get the R2 value
summary(l)$r.squared

r <- residuals(l)

dd <- density(r, n = length(r))

data.frame(x = dd$x, y = dd$y, res = r) %>% 
          ggplot(aes(x, y))  +
          geom_point(size = 0.5, alpha = 0.25) +
          #geom_smooth(method="lm", formula = y ~ x, fill=NA, lwd=2) +
          theme_bw()

## Deaths ------------------------------------------------------------------

# https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/deaths/deaths-time-series-data


### Get the data ------------------------------------------------------------

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


### Simple plots ------------------------------------------------------------


# Plot the Deaths
deaths %>% ggplot(aes(x = Year)) + geom_line(aes(y = Males), colour = "blue") +
           geom_line(aes(y = Females), colour = "pink") + theme_bw() +
           labs(y = "Number of deaths")

# Use points
deaths %>% ggplot(aes(x = Males, y = Females)) + geom_point(alpha = 0.2) +
           theme_bw() +
           labs(y = "Number of Female deaths", x = "Number of Male deaths")

# Change to long format and plot
deaths %>% pivot_longer(cols = c("Males", "Females"), 
                        names_to = "Sex", 
                        values_to = "Numbers")     %>% 
           ggplot(aes(x = Year, y = Numbers, colour = Sex)) +
           geom_line() +
           geom_point(size = 0.75) +
           labs(y = "Number of deaths") +
           guides(colour = "none") +
           geom_label_repel(data = ~subset(., Year == max(Year)), aes(label = Sex), nudge_x = -10) +
           theme_bw()

# Back-to-back bar chart
deaths %>% pivot_longer(cols = c("Males", "Females"),
                        names_to = "Sex",
                        values_to = "Number")   %>% 
           ggplot(aes(x = Year, y = Number, group = Sex, fill = Sex)) +
           geom_bar(data = ~subset(.,  (Sex == "Males")), aes(y = Number, fill = Sex), stat = "identity") +
           geom_bar(data = ~subset(., (Sex == "Females")), aes(y = -Number, fill = Sex), stat = "identity") +
           coord_flip() +
          scale_y_continuous(breaks = seq(-40000, 40000, 10000),
                     labels = abs(seq(-40000, 40000, 10000))) +
           theme_bw()


### Line fitting ------------------------------------------------------------


# Line fitting
l <- lm(data = deaths, formula = Females ~ Males)

deaths %>% ggplot(aes(x = Males, y = Females)) + geom_point(alpha = 0.2) +
           theme_bw() +
           labs(y = "Number of Female deaths", x = "Number of Male deaths") +
           geom_abline(intercept = 5096.958, slope = 0.853, colour = "red", lty = 2) +
           geom_abline(intercept = 0, slope = 1, colour = "blue", lty = 2)



# Get the R2 value
summary(l)$r.squared

r <- residuals(l)

dd <- density(r, n = length(r))

data.frame(x = dd$x, y = dd$y, res = r) %>% 
          ggplot(aes(x, y))  +
          geom_point(size = 0.5, alpha = 0.25) +
          #geom_smooth(method="lm", formula = y ~ x, fill=NA, lwd=2) +
          theme_bw()

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


## Births and deaths -------------------------------------------------------


### Join birth and death data by year ---------------------------------------


# Create a data frame with births and deaths
band <- births %>% left_join(deaths, by = "Year", suffix = c(".b", ".d"))


### Simple plots ------------------------------------------------------------

# Plot the births and deaths
band %>% ggplot(aes(x = Year)) + 
         geom_line(aes(y = Total.b), colour = "green") +
         geom_line(aes(y = Total.d), colour = "black") + 
         theme_bw() +
         labs(y = "Total births and deaths")

# Change to long format and plot
band %>%   mutate(Births = Total.b, Deaths = Total.d) %>% 
           pivot_longer(cols = c("Births", "Deaths"), 
                        names_to = "Band", 
                        values_to = "Numbers")     %>% 
           ggplot(aes(x = Year, y = Numbers, colour = Band)) +
           geom_line() +
           geom_point(size = 0.75) +
           labs(y = "Total births and deaths") +
           guides(colour = "none") +
           geom_label_repel(data = ~subset(., Year == max(Year)), aes(label = Band), nudge_x = -10) +
           theme_bw()

# Add labels to the lines
band %>% pivot_longer(cols = c("Total.b", "Total.d"),
                      names_to = "Types",
                      values_to = "Numbers") %>% 
         mutate(Types = ifelse(Types == "Total.b","Total births", "Total deaths")) %>% 
         ggplot(aes(x = Year, y = Numbers, colour = Types)) + 
         geom_line() + guides(colour = FALSE) +
         theme_bw() +
         scale_colour_manual(values = c("green", "black")) +
         labs(y = "Total births and deaths") +
         geom_label(data = ~subset(., Year == max(Year)), aes(label = Types), nudge_x = -10)

# Bar chart of births - deaths
band %>% mutate(diff = Total.b - Total.d) %>% 
         ggplot(aes(x = Year, y = diff)) +
         geom_col(fill = "red", colour = "black") +
         theme_bw() +
         labs(y = "Births - Deaths")

# Bar chart of births - deaths for each sex
band %>% mutate(m.diff = Males.b - Males.d, f.diff = Females.b - Females.d) %>% 
         ggplot(aes(x = Year)) +
         geom_col(aes(y = m.diff), fill = "blue", colour = "black", alpha = 0.5) +
         geom_col(aes(y = f.diff), fill = "pink", colour = "black", alpha = 0.5) +
         theme_bw() +
         labs(y = "Birth - Death by sex")

# Line plot of births - deaths by sex
band %>% mutate(m.diff = Males.b - Males.d, f.diff = Females.b - Females.d) %>% 
         pivot_longer(cols = c("m.diff", "f.diff"),
                      names_to = "Diff",
                      values_to = "Numbers") %>% 
        mutate(Diff = ifelse(Diff == "m.diff", "Males", "Females")) %>% 
        ggplot(aes(x = Year, y = Numbers, colour = Diff)) + 
         geom_line() + guides(colour = FALSE) +
         theme_bw() +
         scale_colour_manual(values = c("pink", "blue")) +
         labs(y = "Births - Deaths") +
         geom_label_repel(data = ~subset(., Year == max(Year)), aes(label = Diff), nudge_x = -10)
                   
                   