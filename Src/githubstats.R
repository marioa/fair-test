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
r1 <- getData("https://api.github.com/repos/IFB-ElixirFr/FAIR-checker/commits?per_page=100&page=")

# Get the commit information
ToolCommits <- Commits(r1, ToolCommits, "FAIR-Checker")

## Howfairis ----
# https://github.com/fair-software/howfairis
#
# The number of commits not the same as quoted here:
# https://research-software-directory.org/software/howfairis
#
p1 <- getData("https://api.github.com/repos/fair-software/howfairis/commits?per_page=100&page=")

ToolCommits <- Commits(p1, ToolCommits, "howfairis")

## F-UJI ----
# https://github.com/pangaea-data-publisher/fuji
q1 <- getData("https://api.github.com/repos/pangaea-data-publisher/fuji/commits?per_page=100&page=")

ToolCommits <- Commits(q1, ToolCommits, "F-UJI")

## FAIR-Enough ----
# https://github.com/MaastrichtU-IDS/fair-enough-metrics
s1 <- getData("https://api.github.com/repos/MaastrichtU-IDS/fair-enough-metrics/commits?per_page=100&page=")

ToolCommits <- Commits(s1, ToolCommits, "FAIR-Enough")


# Plot the commit data -----------------------------------------------------------


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
               labs(x = "Commit date", y = "Number of commits per day")

# Plot commits aggregated by month
ToolCommits %>% mutate(cdate = floor_date(cdate, unit = "month")) %>% 
               ggplot(aes(x = cdate, fill = Tool)) + 
               geom_bar(colour = "black", position = position_dodge()) + 
               theme_bw() + 
               scale_y_continuous(breaks = breaks_pretty()) +
               labs(x = "Commit date", y = "Number of commits per week")

# Plot commits aggregated by week
ToolCommits %>% mutate(cdate = floor_date(cdate, unit = "week")) %>% 
               ggplot(aes(x = cdate, fill = Tool)) + 
               geom_bar(colour = "black", position = position_dodge()) + 
               theme_bw() + 
               scale_y_continuous(breaks = breaks_pretty()) +
               labs(x = "Commit date", y = "Number of commits per month")

# Density plot
ToolCommits %>% mutate(cdate = floor_date(cdate, unit = "week")) %>% 
               ggplot(aes(x = cdate, fill = Tool)) + 
               geom_density(colour = "black", alpha = 0.25) + 
               theme_bw() + 
               scale_y_continuous(breaks = breaks_pretty()) +
               labs(x = "Commit date", y = "Commit density  per month")

# Earliest and last commits
ToolCommits %>% group_by(Tool) %>% 
                summarise(Start = min(cdate), Last = max(cdate))

# Commits of Tool by date
ToolCommits %>%  ggplot(aes(x = cdate, y = Tool, colour = Tool)) + 
                 geom_point() + geom_line() +
                 theme_bw() + 
                 theme(legend.position = "None") +
                 labs(x = "Commit dates", y = "Tool") +
                 geom_label_repel(data = ToolCommits %>%  group_by(Tool) %>% reframe(y = Tool, x = max(cdate), label = n()) %>% distinct(),
                   aes(x = x, y = y, label = paste0("Total Commits = ", label)), colour = "black",
                   nudge_y = 0.1)

# Violin plot of commits of Tool by date
ToolCommits %>%  ggplot(aes(x = cdate, y = Tool, colour = Tool)) + 
                 geom_violin() + 
                 theme_bw() + 
                 stat_summary(fun = min, geom = "point", size = 3) +
                 stat_summary(fun = max, geom = "point", size = 3) +
                 theme(legend.position = "None") +
                 labs(x = "Commit dates", y = "Tool") 

# Commits - first and last commit only
ToolCommits %>%  group_by(Tool) %>% 
                 ggplot(aes(x = cdate, y = Tool, colour = Tool)) + 
                 geom_line() +
                 theme_bw() + 
                 theme(legend.position = "None") +
                 stat_summary(fun = min, geom = "point", size = 3) +
                 stat_summary(fun = max, geom = "point", size = 3) +
                 labs(x = "Dates", y = "Tool")


# Software releases ---------------------------------------------------------

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

# Github events -----

# Try to determine the level of public activity in a repo
#
# https://docs.github.com/en/free-pro-team@latest/rest/activity/events
#
# Only events created within the past 90 days will be included in timelines. 
# Events older than 90 days will not be included (even if the total number of 
# events in the timeline is less than 300).
#
# What is returned:
#
# https://docs.github.com/en/webhooks-and-events/events/github-event-types
#

# FAIR-Checker https://github.com/IFB-ElixirFr/FAIR-checker
rr <- fromJSON("https://api.github.com/repos/IFB-ElixirFr/FAIR-checker/events?per_page=100", simplifyDataFrame = TRUE, flatten = TRUE)

# Want activity from project members (contributors), i.e. not from an external
# submitting an issue or pull request.

# Also check-out https://docs.github.com/en/graphql/overview/explorer which uses GraphQL

rro <- fromJSON("https://api.github.com/repos/IFB-ElixirFr/FAIR-checker/contributors", simplifyDataFrame = TRUE, flatten = TRUE)

rro %>% filter(login != "dependabot[bot]") %>% 
        select(login) %>%  pull() -> users

rr %>% filter(actor.login %in% users)      %>% 
       mutate(cdate = as.Date(created_at)) %>% 
       select(cdate, type)                 %>% 
       ggplot(aes(x = cdate, y = type, colour = type)) +
       geom_line() +
       geom_point() +
       theme_bw()

rr %>% filter(actor.login %in% users)  %>% 
       select(type)                    %>% 
       ggplot(aes(x = type)) +
       geom_bar(fill = "red", colour = "black") +
       theme_bw() +
       theme( axis.text.x = element_text(angle = -45, hjust = 0)) +
       labs(y = "Number of Activities", x = "Type of Activity")
