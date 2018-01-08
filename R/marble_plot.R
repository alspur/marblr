#' marble_plot
#'
#' @param df A dataframe resulting from calling the marble_game funciton
#' @param alpha_level A number between 0 and 1 representing the opacity of plotted lines. Default value is 0.4
#' 
#' @import ggplot2
#' @import dplyr
#'
#' @return A ggplot object plotting the results of a marble_game() call
#' @export
#'
marble_plot <- function(df, alpha_level = .4){
  
  if(!is.data.frame(df)){
    stop("`df` must be a data frame")
  }
  if(dim(df)[2] != 6){
    stop("`df` must be the result of a marble_game() call")
  }
  
  # set vars to null to satisfy devtools::check()
  season_wk <- NULL
  team <- NULL
  marbles <- NULL

  ggplot(df, aes(x = season_wk, y = marbles, group = team))+ 
    geom_line(alpha = alpha_level) +
    labs(x = "Week", y = "Marbles")+
    theme_bw()
  
}
