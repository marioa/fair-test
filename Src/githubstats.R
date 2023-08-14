#
# Get the commits for various FAIR checking packages.
#
library(jsonlite)
library(dplyr)
library(ggplot2)
library(scales)
library(tibble)
library(lubridate)
library(ggrepel)


# Get the commit data --------------------------------------------------------

# Get commits from specific repositories on GitHub
#
# /repos/{owner}/{repo}/commits
# https://docs.github.com/en/rest/commits/commits
#
# default is to return 30 records, can be set with per_page with a max of 100.

# Get the data from GitHub including pagination
# Need to give it the base url including "?per_page=100&page=" at the end of the URL,
# dat is the tibble to be used (optional) and page is the starting page which defaults
# to 1.
getData <- function(baseURL, dat = tibble(), page = 1){
  
  while(!is.null(nrow(w <- fromJSON(paste0(baseURL, page), simplifyDataFrame = TRUE, flatten = TRUE)))){
      w <- as_tibble(w)
      message("Doing page ", page)
      page <- page + 1
      if(ncol(dat) == 0){
        dat <- w
      }else{
        dat <-add_row(dat, w)
      }
  } # End while
  return(dat)
}

# Function to process the commit data
# dat - the input data
# rel - the tibble tht contains the current data which will get appended to
# tool - string with the tool name
Commits <- function(dat, rel, tool){
  
  dat %>% mutate(cdate = as.Date(commit.committer.date)) %>% 
          mutate(Tool = tool)                            %>% 
          select(cdate, Tool) -> new_rows
  
  if(ncol(rel) == 0){
       rel <- new_rows
  }else{
       rel <- add_row( rel, new_rows)
  }
          
}

# Clear the existing commit information
ToolCommits <- tibble()

## FAIR-Checker ---- 
# https://github.com/IFB-ElixirFr/FAIR-checker
r <- getData("https://api.github.com/repos/IFB-ElixirFr/FAIR-checker/commits?per_page=100&page=")

# Get the commit information
ToolCommits <- Commits(r, ToolCommits, "FAIR-Checker")

## Howfairis ----
# https://github.com/fair-software/howfairis
p <- getData("https://api.github.com/repos/fair-software/howfairis/commits?per_page=100&page=")

ToolCommits <- Commits(p, ToolCommits, "howfairis")

## F-UJI ----
# https://github.com/pangaea-data-publisher/fuji
q <- getData("https://api.github.com/repos/pangaea-data-publisher/fuji/commits?per_page=100&page=")

ToolCommits <- Commits(q, ToolCommits, "F-UJI")

## FAIR-Enough ----
# https://github.com/MaastrichtU-IDS/fair-enough-metrics
s <- getData("https://api.github.com/repos/MaastrichtU-IDS/fair-enough-metrics/commits?per_page=100&page=")

ToolCommits <- Commits(s, ToolCommits, "FAIR-Enough")


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
               labs(x = "Commit date", y = "Number of commts per day")

# Plot commits by month
ToolCommits %>% mutate(cdate = floor_date(cdate, unit = "month")) %>% 
               ggplot(aes(x = cdate, fill = Tool)) + 
               geom_bar(colour = "black", position = position_dodge()) + 
               theme_bw() + 
               scale_y_continuous(breaks = breaks_pretty()) +
               labs(x = "Commit date", y = "Number of commts per week")

# Plot commits by week
ToolCommits %>% mutate(cdate = floor_date(cdate, unit = "week")) %>% 
               ggplot(aes(x = cdate, fill = Tool)) + 
               geom_bar(colour = "black", position = position_dodge()) + 
               theme_bw() + 
               scale_y_continuous(breaks = breaks_pretty()) +
               labs(x = "Commit date", y = "Number of commts per month")

# Density plot
ToolCommits %>% mutate(cdate = floor_date(cdate, unit = "week")) %>% 
               ggplot(aes(x = cdate, fill = Tool)) + 
               geom_density(colour = "black", alpha = 0.25) + 
               theme_bw() + 
               scale_y_continuous(breaks = breaks_pretty()) +
               labs(x = "Commit date", y = "Number of commts per month")

# Commits Tool by date
ToolCommits %>%  ggplot(aes(x = cdate, y = Tool, colour = Tool)) + 
                 geom_point() + geom_line() +
                 theme_bw() + 
                 theme(legend.position = "None") +
                 labs(x = "Commit dates", y = "Tool") +
                 geom_label_repel(data = ToolCommits %>%  group_by(Tool) %>% reframe(y = Tool, x = max(cdate), label = n()) %>% distinct(),
                   aes(x = x, y = y, label = paste0("Total Commits = ", label)), colour = "black",
                   nudge_y = 0.1)

ToolCommits %>%  ggplot(aes(x = cdate, y = Tool, colour = Tool)) + 
                 geom_point(alpha = 0.25) + geom_line() + geom_jitter() +
                 theme_bw() + 
                 theme(legend.position = "None") +
                 labs(x = "Commit dates", y = "Tool") 

# Violin plot of commits Tool by date
ToolCommits %>%  ggplot(aes(x = cdate, y = Tool, colour = Tool)) + 
                 geom_violin() + 
                 theme_bw() + 
                 stat_summary(fun.y = min, geom = "point", size = 3) +
                 stat_summary(fun.y = max, geom = "point", size = 3) +
                 theme(legend.position = "None") +
                 labs(x = "Commit dates", y = "Tool") 

# Commits - first and last commit only
ToolCommits %>%  group_by(Tool) %>% 
                 ggplot(aes(x = cdate, y = Tool, colour = Tool)) + 
                 geom_line() +
                 theme_bw() + 
                 theme(legend.position = "None") +
                 stat_summary(fun.y = min, geom = "point", size = 3) +
                 stat_summary(fun.y = max, geom = "point", size = 3) +
                 labs(x = "Dates", y = "Tool")


# Releases ----------------------------------------------------------------

# https://docs.github.com/en/rest/releases/releases?apiVersion=2022-11-28
#
# /repos/{owner}/{repo}/releases
#

Rel <- function(dat, rel, tool){
  
  dat %>% mutate(rdate = as.Date(created_at)) %>% 
          mutate(Tool = tool)                 %>% 
          select(tag_name, rdate, Tool) -> new_rows
  
  if(ncol(rel) == 0){
       rel <- new_rows
  }else{
       rel <- add_row( rel, new_rows)
  }
          
}

# Reset the array
Releases <-  tibble()

# FAIR-Checker https://github.com/IFB-ElixirFr/FAIR-checker
r <- fromJSON("https://api.github.com/repos/IFB-ElixirFr/FAIR-checker/releases", simplifyDataFrame = TRUE, flatten = TRUE)

Releases <- Rel(r, Releases, "FAIR-Checker")

# Howfairis https://github.com/fair-software/howfairis
p <- fromJSON("https://api.github.com/repos/fair-software/howfairis/releases", simplifyDataFrame = TRUE, flatten = TRUE)

Releases <- Rel(p, Releases, "howfairis")

# F-UJI https://github.com/pangaea-data-publisher/fuji
q <- fromJSON("https://api.github.com/repos/pangaea-data-publisher/fuji/releases", simplifyDataFrame = TRUE, flatten = TRUE)

Releases <- Rel(q, Releases, "F-UJI")

# Plot releases -----------------------------------------------------------

Releases %>%  ggplot(aes(x = rdate, y = Tool, colour = Tool)) + 
              geom_point() + 
              geom_line() +
              theme_bw() + theme(legend.position = "none") +
              geom_label_repel(aes(label = tag_name), force = 2) +
              labs(x = "Release dates", y = "Tool") 

# Only label the first and last release for each tool
Releases %>%  group_by(Tool) %>% 
              ggplot(aes(x = rdate, y = Tool, colour = Tool)) + 
              geom_point() + 
              geom_line() +
              theme_bw() + theme(legend.position = "none") +
              geom_label_repel(data = Releases %>% group_by(Tool) %>% filter(rdate == min(rdate)| rdate == max(rdate)), aes(label = tag_name), 
                                nudge_y = 0.1) +
              labs(x = "Release dates", y = "Tool") 
