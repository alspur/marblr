#' NCAA FBS Football Game Results, 1995-2018
#'
#' @format A dataframe with 15,984 rows and 11 variables:
#' \describe{
#'   \item{season_yr}{College football season year}
#'   \item{season_wk}{Week number of college football season}
#'   \item{date}{Date of game}
#'   \item{team1}{Team 1 name}
#'   \item{team2}{Team 2 name}
#'   \item{team1_score}{Team 1 score}
#'   \item{team2_score}{Team 2 score}
#'   \item{home_status}{Indicates host status - either "team1", "team2", or "neutral"}
#'   \item{ot}{Number of overtime periods, if applicable}
#'   \item{playoff}{Inidcator of post-season game}
#'   \item{other_info}{Other game information, such as neutral game site or bowl game name}
#' }
#'
#' @source \url{https://www.masseyratings.com/data.php}
#'

"ncaa_games"
