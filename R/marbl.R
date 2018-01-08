#' marble_game
#'
#' @param df Data frame of NCAA football game results, should always be ncaa_games
#' @param yr Number indicating year of NCAA football season. Defaults to 2017.
#' @param wk Number indicating maximum week of NCAA football season. Defaults to 36 to ensure all weeks are included in a standard marble game.
#' @param p5_value Number indicating the amount of marbles for Power 5 conference teams have to start a season. Defaults to 120, while all other teams start with 100.
#' 
#' @import dplyr
#' @import tidyr
#' @import stringr
#' @import tibble
#'
#' @return A dataframe of game data.
#' @export
#'

marble_game <- function(df, yr = 2017,
                        wk = 36, p5_value = 120){
  if(!is.data.frame(df)){
    stop("`df` must be the `ncaa_games` data frame")
  }
  if(dim(df)[1]!=15938 | dim(df)[2] != 11){
    stop("`df` must be the `ncaa_games` data frame")
  }
  if((yr %% 1) != 0){
    stop("`season_year` must be an integer")
  }
  if(yr < 1995){
    stop("`season_year` can't be lower than 1995")
  }
  if(yr > 2017){
    stop("`season_year` can't be greater than 2017")
  }
  
  # set vars to null to satisfy devtools::check()
  season_wk <- NULL
  team <- NULL
  team1 <- NULL
  team2 <- NULL
  opponent <- NULL
  week <- NULL
  marbles <- NULL
  change <- NULL
  game_flag <- NULL

  
  # get season data, stopping at selected week
  season_data <- get_season(df, yr, wk)
  
  # find maximum week number
  unique_wk <- season_data %>% 
    select(season_wk) %>% 
    unique() %>% 
    pull(season_wk) %>% 
    max() 
  
  # get team names
  team_names <- c(season_data$team1, season_data$team2) %>% 
    unique() %>% 
    sort()
  
  # get week_names
  week_names <- paste0("wk_", 0:unique_wk)
  
  # create tibble of marbles
  marble_df <- matrix(c(rep(100, length(team_names)),
                        rep(NA, length(team_names) * unique_wk)),
                      nrow = length(team_names)) %>% 
    as.tibble() %>% 
    mutate(team = team_names) %>% 
    select(team, everything())

  # tidy colnames
  colnames(marble_df) <- c("team", week_names) 
  
  # adjust week 0 marbles based on p5 status
  marble_df <- marble_df %>% 
    mutate(wk_0 = ifelse(team %in% p5$team, p5_value, 100))
  
  # create long season df by team 
  
  schedule <- suppressMessages(tibble(team = rep(team_names, unique_wk +1)) %>% 
    arrange(team) %>% 
    mutate(season_wk = rep(0:unique_wk, length(team_names))) %>% 
    left_join(season_data %>% select(team1, team2, season_wk) %>% 
                rename(team = team1)) %>% 
    left_join(season_data %>% select(team1, team2, season_wk) %>% 
                rename(team = team2)) %>% 
    unite(opponent, team1, team2) %>% 
    mutate(opponent = str_replace_all(opponent, "NA", ""),
           opponent = str_replace_all(opponent, "_", ""),
           opponent = ifelse(opponent == "", NA, opponent)))
  
  
# run marble game for selected season and weeks
for(i in seq_along(1:unique_wk)){
  
  wk_num <- i
  
  if(wk_num %in% season_data$season_wk){
    
    prev_wk <- marble_df[,wk_num + 1]
    # create new week column, populate w/ current marble count to start
    marble_df[,wk_num + 2] <- prev_wk
    
    
    
    curr_wk <- season_data %>% 
      filter(season_wk == wk_num)
    
    for(j in seq_along(1:length(curr_wk$date))){
      
      winner <- curr_wk$team1[j]
      loser <- curr_wk$team2[j]
      
      if(curr_wk$home_status[j] == "team2"){
        
        marble_pct <- .25
        
      } else {
        
        marble_pct <- .2
        
      }
      
      # how many marbles does the loser have?
      loser_marbles <- marble_df %>%
        filter(team == loser) %>% 
        pull(wk_num + 1)
      
      # how many marbles does the winner have?
      winner_marbles <- marble_df %>% 
        filter(team == winner) %>% 
        pull(wk_num + 1)
      
      # calculate marble transfer
      marble_change <- loser_marbles * marble_pct
      # check if there is a fractional marble
      marble_remainder <- marble_change %% 1
      # make marble change whole number - loser keeps fractional marble
      marble_change <- marble_change-marble_remainder
      
      loser_marbles <- loser_marbles - marble_change
      winner_marbles <- winner_marbles + marble_change
      
      # transfer marbles
      marble_df[marble_df$team == winner, wk_num +2] <- winner_marbles
      marble_df[marble_df$team == loser, wk_num +2] <- loser_marbles
      
    }
    
  } else {
    
    # week w/o college football - carry over prev. wk scores
    prev_wk <- marble_df[,wk_num + 1]
    # create new week column, populate w/ current marble count 
    marble_df[,wk_num + 2] <- prev_wk
    
    
  }
  
  
  
}
  
  
  # create function to calcualte weekly marble change
  marble_change <- function(marbles){
    
    y <- numeric(length(marbles))
    
    for(i in 1:length(marbles)){
      
      
      if(i == 1){
        y[i] <- NA
      } else{
        
        y[i] <- marbles[i] - marbles[i-1]
      
        }
      
    }
    
    return(y)
  }
  
  marble_long <-  suppressMessages(marble_df %>%
    gather(week, marbles, -team) %>% 
    rename(season_wk = week) %>% 
    mutate(season_wk = as.numeric(str_replace_all(season_wk, "wk_", ""))) %>% 
    arrange(team, season_wk) %>% 
    group_by(team) %>% 
    mutate(change = marble_change(marbles)) %>% 
    left_join(schedule) %>% 
    ungroup() %>% 
    group_by(team) %>% 
    mutate(game_flag = ifelse(change >= 40, "big win", NA),
           game_flag = ifelse(change <= -40, "big loss", game_flag),
           game_flag = ifelse(change == min(change, na.rm = TRUE),
                              "biggest loss", game_flag),
           game_flag = ifelse(change == max(change, na.rm = TRUE),
                              "biggest win", game_flag),
           game_flag = ifelse(change == 0, NA, game_flag)) %>% 
    ungroup())
  
  return(marble_long)
  
} 

if(getRversion() >= "2.15.1")  utils::globalVariables(c("p5"))
