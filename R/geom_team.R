#' geom_team
#'
#' @param df A dataframe resulting from calling the marble_game funciton
#' @param team_name NCAA D1 FBS Football team name
#' @param team_color Color to represent team
#' 
#' @import ggplot2
#' @import dplyr
#'
#' @return A ggplot geom plotting the marbles of a team for a given season.
#' @export
#'
#'
geom_team <- function(df, team_name, team_color){
  
  # set vars to null to satisfy devtools::check()
  team <- NULL
  season_wk <- NULL
  marbles <- NULL
  
  geom_line(data = df %>% filter(team == team_name), 
            aes(x =season_wk, y = marbles), color = team_color)
  
}

#' geom_big_wins
#'
#' @param df A dataframe resulting from calling the marble_game funciton
#' @param team_name NCAA D1 FBS Football team name
#' @param team_color Color to represent team
#' 
#' @import ggplot2
#' @import dplyr
#'
#' @return A ggplot geom plotting a team's largest win and any win that results in a gain of 40+ marbles.
#' @export
#'
geom_big_wins <- function(df, team_name, team_color){
  
  # set vars to null to satisfy devtools::check()
  team <- NULL
  season_wk <- NULL
  marbles <- NULL
  game_flag <- NULL
  
  geom_point(data = df %>% 
               filter(team == team_name) %>% 
               filter(str_detect(game_flag, "win")), 
            aes(x =season_wk, y = marbles), color = team_color)
  
}



#' geom_big_loss
#'
#' @param df A dataframe resulting from calling the marble_game funciton
#' @param team_name NCAA D1 FBS Football team name
#' @param team_color Color to represent team
#' 
#' @import ggplot2
#' @import dplyr
#'
#' @return A ggplot geom plotting the biggest loss for a team or any loss that results in losing 40+ marbles.
#' @export
#'
geom_big_loss <- function(df, team_name, team_color){
  
  # set vars to null to satisfy devtools::check()
  team <- NULL
  season_wk <- NULL
  marbles <- NULL
  game_flag <- NULL
  
  geom_point(data = df %>% 
               filter(team == team_name) %>% 
               filter(str_detect(game_flag, "loss")), 
             aes(x =season_wk, y = marbles), 
             color = team_color, shape = 4, size = 2)
  
}
