# power5.R

library(tidyverse)

# create df of power 5 conference football teams

p5_team_names <- c("Boston College", "Clemson", "Duke", "Florida St",
              "Georgia Tech", "Louisville", "Miami FL", 
              "North Carolina", "NC State", "Pittsburgh",
              "Syracuse", "Virginia", "Virginia Tech", 
              "Wake Forest",
              
              "Notre Dame", 
              
              "Baylor", "Iowa St", "Kansas", "Kansas St", 
              "Oklahoma", "Oklahoma St", "TCU", "Texas",
              "Texas Tech", "West Virginia",
              
              "Illinois", "Indiana", "Iowa", "Maryland", 
              "Michigan", "Michigan St", "Minnesota", 
              "Nebraska", "Northwestern", "Ohio St",
              "Penn St", "Purdue", "Rutgers", "Wisconsin",
              
              "Arizona", "Arizona St", "California", "UCLA",
              "Colorado", "Oregon", "Oregon St", "USC",
              "Stanford", "Utah", "Washington", "Washington St", 
              
              "Alabama", "Arkansas", "Auburn", "Florida",
              "Georgia", "Kentucky", "LSU", "Mississippi", 
              "Mississippi St", "Missouri", "South Carolina",
              "Tennessee", "Texas A&M", "Vanderbilt")

p5 <- tibble(team = p5_team_names,
                conf = c(rep("acc", 14),
                         "ind",
                         rep("big 12", 10),
                         rep("big 10", 14),
                         rep("pac 12", 12),
                         rep("sec", 14))) 

devtools::use_data(p5, overwrite = TRUE, internal = TRUE)
