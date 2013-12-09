# Encoding: utf-8

require 'app/game_state'

module App
  module Player
    class RandomPlayer
      def get_new_state(game_state)
        board = game_state.board
        # Randomly choose one of the blank spaces
        choice = game_state.get_blanks.sample
        # Populate the blank space with the active turn piece
        board[choice[0]][choice[1]] = game_state.active_turn
        # Swap to the next turn
        next_turn = game_state.active_turn == 'x' ? 'o' : 'x'
        # Return the new game state
        App::GameState.new(board, next_turn)
      end
    end
  end
end
