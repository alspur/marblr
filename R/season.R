#' get_season
#'
#' @param df Data frame of game data - should always be `ncaa_games`
#' @param yr Number indicating year of NCAA football season
#' @param wk Number indicating maximum week within NCAA football season
#' 
#' @import dplyr
#'
#' @return A dataframe with NCAA FBS football game results
#' @export
#' 

get_season <- function(df, yr = 2017, wk = 36){
  
  if(!is.data.frame(df)){
    stop("`df` must be a `ncaa_games` data frame")
  }
  if(dim(df)[2] != 11){
    stop("`df` must be a `ncaa_games` data frame")
  }
  if(!is.numeric(yr)){
    stop("`yr` must be numeric")
  }
  
  if((yr %% 1) != 0){
    stop("`yr` must be an integer")
  }
  if(yr < 1995){
    stop("`yr` can't be lower than 1995")
  }
  if(yr > 2018){
    stop("`yr` can't be greater than 2018")
  }
  if(!is.numeric(wk)){
    stop("`wk` must be a number")
  }
  if(wk < 1){
    stop("`wk` must be a positive number")
  }
  
  season_yr <- NULL
  season_wk <- NULL
  
  req_season_data <- df %>%
    filter(season_yr == yr) %>% 
    filter(season_wk <= wk)
  
  return(req_season_data)
  
  
}
