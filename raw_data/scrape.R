# scrape.R

# load ------------

# load packages
library(tidyverse)
library(rvest)

# get season data urls ------------

# 2017 ncaa football results url
ncaa_2017_url <- "https://www.masseyratings.com/scores.php?s=295489&sub=11604&all=1&mode=2&format=0"

ncaa_2016_url <- "https://www.masseyratings.com/scores.php?s=286577&sub=11604&all=1&mode=2&format=0"

ncaa_2015_url <- "https://www.masseyratings.com/scores.php?s=279541&sub=11604&all=1&mode=2&format=0"

ncaa_2014_url <- "https://www.masseyratings.com/scores.php?s=262657&sub=11604&all=1&mode=2&format=0"

ncaa_2013_url <- "https://www.masseyratings.com/scores.php?s=199231&sub=11604&all=1&mode=2&format=0"

ncaa_2012_url <- "https://www.masseyratings.com/scores.php?s=181623&sub=11604&all=1&mode=2&format=0"

ncaa_2011_url <- "https://www.masseyratings.com/scores.php?s=107811&sub=11604&all=1&mode=2&format=0"

ncaa_2010_url <- "https://www.masseyratings.com/scores.php?s=98700&sub=11604&all=1&mode=2&format=0"

ncaa_2009_url <- "https://www.masseyratings.com/scores.php?s=94988&sub=11604&all=1&mode=2&format=0"

ncaa_2008_url <- "https://www.masseyratings.com/scores.php?s=85513&sub=11604&all=1&mode=2&format=0"

ncaa_2007_url <- "https://www.masseyratings.com/scores.php?s=73929&sub=11604&all=1&mode=2&format=0"

ncaa_2006_url <- "https://www.masseyratings.com/scores.php?s=68033&sub=11604&all=1&mode=2&format=0"

ncaa_2005_url <- "https://www.masseyratings.com/scores.php?s=41850&sub=11604&all=1&mode=2&format=0"

ncaa_2004_url <- "https://www.masseyratings.com/scores.php?s=41849&sub=11604&all=1&mode=2&format=0"

ncaa_2003_url <- "https://www.masseyratings.com/scores.php?s=41848&sub=11604&all=1&mode=2&format=0"

ncaa_2002_url <- "https://www.masseyratings.com/scores.php?s=41847&sub=11604&all=1&mode=2&format=0"

ncaa_2001_url <- "https://www.masseyratings.com/scores.php?s=41846&sub=11604&all=1&mode=2&format=0"

ncaa_2000_url <- "https://www.masseyratings.com/scores.php?s=41845&sub=11604&all=1&mode=2&format=0"

ncaa_1999_url <- "https://www.masseyratings.com/scores.php?s=41844&sub=11604&all=1&mode=2&format=0"

ncaa_1998_url <- "https://www.masseyratings.com/scores.php?s=41843&sub=11604&all=1&mode=2&format=0"

ncaa_1997_url <- "https://www.masseyratings.com/scores.php?s=41842&sub=11604&all=1&mode=2&format=0"

ncaa_1996_url <- "https://www.masseyratings.com/scores.php?s=41841&sub=11604&all=1&mode=2&format=0"

ncaa_1995_url <- "https://www.masseyratings.com/scores.php?s=41840&sub=11604&all=1&mode=2&format=0"

# create df of urls and years
ncaa_urls <- tibble(year = 2017:1995,
                    url = c(ncaa_2017_url, ncaa_2016_url, ncaa_2015_url,
                            ncaa_2014_url, ncaa_2013_url, ncaa_2012_url,
                            ncaa_2011_url, ncaa_2010_url, ncaa_2009_url,
                            ncaa_2008_url, ncaa_2007_url, ncaa_2006_url,
                            ncaa_2005_url, ncaa_2004_url, ncaa_2003_url,
                            ncaa_2002_url, ncaa_2001_url, ncaa_2000_url,
                            ncaa_1999_url, ncaa_1998_url, ncaa_1997_url,
                            ncaa_1996_url, ncaa_1995_url))

# create scrape/clean function ------

scrape_season <- function(s_year = 2017){
  
  # take s_year and extract url from ncaa_url df
  season_url <- ncaa_urls %>% 
    filter(year == s_year) %>% 
    pull(url)
  
  # scrape and parse raw text
  season_text <- season_url %>%
    read_html() %>% 
    html_nodes(xpath = "/html/body/pre")%>%
    html_text()
  
  # create vector of individual game entries
  raw_games <- str_split(season_text, "\n")
  
  # create df of individual ncaa games
  ncaa_games <- tibble(raw_game = raw_games[[1]]) %>% 
    # get rid of non-game rows
    filter(str_detect(raw_game ,"[0-9]{4}-")) %>% 
    # separate out game dates
    separate(raw_game, into = c("date", "raw_game"), sep = 10) %>% 
    mutate(raw_game = str_trim(raw_game)) %>% 
    # separate out team 1 
    separate(raw_game, into = c("team1", "raw_away"),
             sep = "[0-9]+", remove = FALSE, extra = "merge") %>% 
    # separate out team 2 
    separate(raw_away, into = c("team2", "raw_meta"),
             sep = "[0-9]+", extra = "merge") %>% 
    mutate(raw_score1 = str_replace_all(raw_game, team1, "")) %>% 
    separate(raw_score1, into= c("team1_score", "raw_score2"),
             extra = "merge") %>% 
    mutate(team2 = str_trim(team2),
           raw_score2 = str_trim(str_replace_all(raw_score2, 
                                                 str_replace_all(team2, "@", "" ),
                                                 ""))) %>% 
    separate(raw_score2, into= c("team2_score", "raw_score2"), 
             extra = "merge") %>% 
    select(date, team1, team2, team1_score, team2_score, raw_meta) %>% 
    mutate(team1_score = as.numeric(team1_score),
           team2_score = as.numeric(team2_score),
           home_status = ifelse(str_detect(team1, "@"), "team1",
                                ifelse(str_detect(team2, "@"),
                                       "team2", "neutral")),
           team1 = str_trim(str_replace_all(team1, "@", "")),
           team2 = str_trim(str_replace_all(team2, "@", ""))) %>% 
    # create clean season week number
    mutate(season_wk = lubridate::week(lubridate::ymd(date)),
           season_wk = ifelse(season_wk < 20, season_wk + max(season_wk), season_wk),
           season_wk = season_wk - (min(season_wk)-1)) %>% 
    # create overtime column
    mutate(ot = str_extract(raw_meta, "O[0-9]")) %>% 
    # create playoff column
    mutate(playoff = str_trim(str_extract(raw_meta, "P(?![a-z])"))) %>% 
    # create clean meta column
    mutate(info = str_replace_all(raw_meta, "P(?![a-z])", ""),
           info = str_replace_all(info, "O[0-9]", ""),
           info = str_trim(info),
           info = ifelse(info == "", NA, info)) %>% 
    # add column for season year
    mutate(season_yr = s_year) %>% 
    rename(other_info = info) %>% 
    select(season_yr, season_wk, date,
           team1, team2, team1_score, team2_score, 
           home_status, ot, playoff, other_info)
  
  return(ncaa_games)
  
}

# download season data -----

fb17 <- scrape_season(2017)
fb16 <- scrape_season(2016)
fb15 <- scrape_season(2015)
fb14 <- scrape_season(2014)
fb13 <- scrape_season(2013)
fb12 <- scrape_season(2012)
fb11 <- scrape_season(2011)
fb10 <- scrape_season(2010)
fb09 <- scrape_season(2009)
fb08 <- scrape_season(2008)
fb07 <- scrape_season(2007)
fb06 <- scrape_season(2006)
fb05 <- scrape_season(2005)
fb04 <- scrape_season(2004)
fb03 <- scrape_season(2003)
fb02 <- scrape_season(2002)
fb01 <- scrape_season(2001)
fb00 <- scrape_season(2000)
fb99 <- scrape_season(1999)
fb98 <- scrape_season(1998)
fb97 <- scrape_season(1997)
fb96 <- scrape_season(1996)
fb95 <- scrape_season(1995)

# join data from all years ------------

ncaa_games <- bind_rows(fb17, fb16, fb15, fb14, fb13, fb12, fb11, fb10,
                        fb09, fb08, fb07, fb06, fb05, fb04, fb03, fb02, 
                        fb01, fb00, fb99, fb98, fb97, fb96, fb95)

devtools::use_data(ncaa_games, overwrite = TRUE)
