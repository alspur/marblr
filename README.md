## marblr

During the 2017 NCAA football season, [David Burge](https://twitter.com/iowahawkblog) proposed [a simple, easy-to-comprehend system](https://twitter.com/iowahawkblog/status/931947718628593664) for determining which NCAA football teams would be invited to the four-team playoff - the "marble game." The rules of the game are simple:

- Each team starts with a pre-determined amount of marbles.
- If a team wins a home game, they take 20% of the loser's marbles.
- If a team wins a road game, they take 25% of the loser's marbles.
- Neutral site games are treated as home wins for the victor (20% marble transfer).

The motivation behind the #marblegame is simple: 

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">The point of the <a href="https://twitter.com/hashtag/MarbleGame?src=hash&amp;ref_src=twsrc%5Etfw">#MarbleGame</a> is that CFB playoff selection could be simple, open, &amp; transparent, not backroom committees lobbying for the outcome of a beauty contest.</p>&mdash; David Burge (@iowahawkblog) <a href="https://twitter.com/iowahawkblog/status/937352469511835650?ref_src=twsrc%5Etfw">December 3, 2017</a></blockquote> 

### Package features

The `marblr` package allows R users to simulate the marble game for NCAA football seasons from 1995 to 2017 (data scraped from Massey Ratings). Data from 2018 games will be updated as it becomes availalbe. 

The `marble_game` function takes four inputs:

- `ncaa_games`: A dataframe that comes with the `marblr` package with game result data scraped from Massey Ratings.
- `yr`: A four-digit year from 1995 to 2018, indicating the desired football season.
- `wk`: A integer to determine the maximum week of the season to include. By default, it will pull all available weeks. If you want to limit to the first 6 weeks of the season, you would set this parameter to 6. 
- `p5_value`: An integer to determine the initial marble count given to teams from the 2017 Power 5 conferences (ACC, Big 10, Big 12, Pac 12, SEC, and Notre Dame) at the start of a season. This defaults to 120 for teams from the Power 5 and 100 for all other schools. 
