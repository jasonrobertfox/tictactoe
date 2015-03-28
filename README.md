#Tic Tac Toe Documentation

[![Build Status](https://travis-ci.org/jasonrobertfox/tictactoe.png?branch=master)](https://travis-ci.org/jasonrobertfox/tictactoe) [![Coverage Status](https://coveralls.io/repos/jasonrobertfox/tictactoe/badge.png)](https://coveralls.io/r/jasonrobertfox/tictactoe) [![Code Climate](https://codeclimate.com/github/jasonrobertfox/tictactoe.png)](https://codeclimate.com/github/jasonrobertfox/tictactoe)

A simple game. Or is it!? Try your skill at [http://perfecttictactoe.herokuapp.com/](http://perfecttictactoe.herokuapp.com/)

Along with the game there is a "Tic Tac Toe" API, simply post a JSON request indicating the current board state and the "turn" piece. The response will be an updated board state.

**API End Point**

    POST /api/v2/play

**Example Request**

    {
       "player_piece":"o",
       "opponent_piece":"x",
       "board":[
          {
             "id":"top-left",
             "value":""
          },
          {
             "id":"top-center",
             "value":""
          },
          {
             "id":"top-right",
             "value":"x"
          },
          {
             "id":"middle-left",
             "value":""
          },
          {
             "id":"middle-center",
             "value":"o"
          },
          {
             "id":"middle-right",
             "value":""
          },
          {
             "id":"bottom-left",
             "value":"x"
          },
          {
             "id":"bottom-center",
             "value":"o"
          },
          {
             "id":"bottom-right",
             "value":"x"
          }
       ]
    }

**Example Response**

*Note the addition of "o" in the top-center and that the player and opponent has switched. Also any spaces in a "winning" line are indicated as such with the attribute `"winning_space": true`*.

    {
       "status":"success",
       "data":{
          "player_piece":"x",
          "opponent_piece":"o",
          "board":[
             {
                "id":"top-left",
                "value":""
             },
             {
                "id":"top-center",
                "value":"o"
             },
             {
                "id":"top-right",
                "value":"x",
                "winning_space": true
             },
             {
                "id":"middle-left",
                "value":""
             },
             {
                "id":"middle-center",
                "value":"o",
                "winning_space": true
             },
             {
                "id":"middle-right",
                "value":""
             },
             {
                "id":"bottom-left",
                "value":"x"
             },
             {
                "id":"bottom-center",
                "value":"o",
                "winning_space": true
             },
             {
                "id":"bottom-right",
                "value":"x"
             }
          ]
       }
    }

###Development
This game was built on top of my [sinatra-boilerplate](https://github.com/neverstopbuilding/sinatra-boilerplate) app. Specifics to that boilerplate can be found at its repository.

###Notes on Testing
Tests are best executed using the rake tasks:

- `rake test`
- `rake system`
- `rake js` (Run javascript unit tests via jasmine on phantomjs.)
- `rake build_full` (For all the tests.)

This is due to conditional configuration based on test type to improve the execution speed. You may run tests directly with the `rspec` command but this will include all dependencies.

To start a development server and guard simply run:

`bundle exec guard`

To start a jasmine server to view the results of javascript tests in the browser run:

`bundle exec rake jasmine`

###Room for Improvement
- The board class is a little heavy, there may be a way to pull this apart.
- There may be a way to further speed up the algorithm

##License
```
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```
License located in `LICENSE.md`

##Change Log

###2.1.1 - March 28, 2015
- Add GPL v3 License

###2.1.0 - January 23, 2014
- Split Board into a Board and GameState object for better separation of responsibilities.
- Improve turn hand off, isolating knowledge of pieces to the GameState.
- Cleaned up with win check algorithm to leverage a more universal function.
- Added mechanism to identify which "lines" on a board can never be winning because they contain at least 1 of both players' pieces. These are cached to prevent future checks of that line and improve speed.

###2.0.0 - January 10, 2014

- Ignore expensive win check if there are not enough pieces for a win to be possible (while following the rules). For example, the soonest a player could win on a 3x3 board is when marking the 5th square.
- Refactor board state object to improve copying performance and holding the state of the game as moves are made, this prevents expensive win checking of the whole board any time that method is called.
- Refactor minimax algorithm to employ alpha-beta pruning, which improved performance significantly on the first computer move.
- Update to version 2 of the api which reports winning spaces, allowing all the win check logic to be stripped out of the client.
- Refactor client javascript code to simply read/write board and manage turn/messages.
- Spruced up the styles a little.
- Various test/code cleaning and performance optimizations.
