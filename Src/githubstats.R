#
# Get the commits for various FAIR checking packages.
#
library(jsonlite)
library(dplyr)
library(ggplot2)
library(scales)
library(tibble)
library(lubridate)

# Get commits on GitHub
#
# /repos/{owner}/{repo}/commits
# https://docs.github.com/en/rest/commits/commits?apiVersion=2022-11-28


# Get the commit data --------------------------------------------------------

# FAIR-Checker https://github.com/IFB-ElixirFr/FAIR-checker
r <- fromJSON("https://api.github.com/repos/IFB-ElixirFr/FAIR-checker/commits", simplifyDataFrame = TRUE, flatten = TRUE)

r %>% mutate(cdate = as.Date(commit.committer.date)) %>% 
      mutate(Tool = "FAIR-Checker")                  %>% 
      select(cdate, Tool) -> ToolCommits

# Howfairis https://github.com/fair-software/howfairis
p <- fromJSON("https://api.github.com/repos/fair-software/howfairis/commits", simplifyDataFrame = TRUE, flatten = TRUE)

p %>% mutate(cdate = as.Date(commit.committer.date)) %>% 
      mutate(Tool = "howfairis")                     %>% 
      select(cdate, Tool) -> new_rows

ToolCommits <- add_row(ToolCommits, new_rows)

# F-UJI https://github.com/pangaea-data-publisher/fuji
q <- fromJSON("https://api.github.com/repos/pangaea-data-publisher/fuji/commits", simplifyDataFrame = TRUE, flatten = TRUE)

q %>% mutate(cdate = as.Date(commit.committer.date)) %>% 
      mutate(Tool = "F-UJI")                         %>% 
      select(cdate, Tool) -> new_rows

ToolCommits <- add_row(ToolCommits, new_rows)

# FAIR-Enough https://github.com/MaastrichtU-IDS/fair-enough-metrics
s <- fromJSON("https://api.github.com/repos/MaastrichtU-IDS/fair-enough-metrics/commits", simplifyDataFrame = TRUE, flatten = TRUE)

s %>% mutate(cdate = as.Date(commit.committer.date)) %>% 
      mutate(Tool = "FAIR-Enough")                   %>% 
      select(cdate, Tool)-> new_rows

ToolCommits <- add_row(ToolCommits, new_rows)

# Plot the data -----------------------------------------------------------

# Plot commits by date
ToolCommits %>% 
               ggplot(aes(x = cdate, fill = Tool)) + 
               geom_bar(colour = "black") + 
               theme_bw() + 
               scale_y_continuous(breaks = breaks_pretty()) +
               labs(x = "Commit date", y = "Number of commts") 

# Plot commits by day
ToolCommits %>% mutate(cdate = floor_date(cdate, unit = "day")) %>% 
               ggplot(aes(x = cdate, fill = Tool)) + 
               geom_bar(colour = "black", position = position_dodge()) + 
               theme_bw() + 
               scale_y_continuous(breaks = breaks_pretty()) +
               labs(x = "Commit date", y = "Number of commts per month")

# Plot commits by month
ToolCommits %>% mutate(cdate = floor_date(cdate, unit = "month")) %>% 
               ggplot(aes(x = cdate, fill = Tool)) + 
               geom_bar(colour = "black", position = position_dodge()) + 
               theme_bw() + 
               scale_y_continuous(breaks = breaks_pretty()) +
               labs(x = "Commit date", y = "Number of commts per month")

# Plot commits by week
ToolCommits %>% mutate(cdate = floor_date(cdate, unit = "week")) %>% 
               ggplot(aes(x = cdate, fill = Tool)) + 
               geom_bar(colour = "black", position = position_dodge()) + 
               theme_bw() + 
               scale_y_continuous(breaks = breaks_pretty()) +
               labs(x = "Commit date", y = "Number of commts per month")
