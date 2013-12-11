# Encoding: utf-8

require 'app/game_state'

module App
  module Player
    class PerfectPlayer
      def get_new_state(game_state)
        @game_state = game_state
        @player = @game_state.active_turn
        @other_payer = @player == 'x' ? 'o' : 'x'
        @choice = []

        if @game_state.get_blanks.length == 9
          # If its the first move pick a random good starting move
          @game_state.get_new_state([[0, 2].sample, [0, 2].sample])
        elsif @game_state.get_blanks.length == 1
          # Pick the last available space if there is only one
          @game_state.get_new_state(@game_state.get_blanks.first)
        else
          # Determine the best possible move via a minimax calculation
          minmax(@game_state, 0)
          @game_state.get_new_state(@choice)
        end
      end

      private

        def evaluate_state(state, depth)
          # Weight more shallow levels more so that even "bad" or "rigged" games are played
          # realistically.
          if state.win?(@player)
            score = 10 - depth
          elsif state.win?(@other_payer)
            score = depth - 10
          else
            score = 0
          end
          score
        end

        def minmax(state, depth)
          return evaluate_state(state, depth) if state.over?
          depth += 1
          scores = []
          moves = []
          state.get_blanks.each do |choice|
            node = state.get_new_state(choice)
            scores.push minmax(node, depth)
            moves.push choice
          end
          if state.active_turn == @player
            # this is a maximizing move
            max_index = scores.each_with_index.max[1]
            @choice = moves[max_index]
            return scores[max_index]
          else
            # this is a minimizing move
            min_index = scores.each_with_index.min[1]
            @choice = moves[min_index]
            return scores[min_index]
          end
        end
    end
  end
end
