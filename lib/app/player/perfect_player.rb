# Encoding: utf-8

require 'app/game_state'

module App
  module Player
    class PerfectPlayer
      def get_new_state(game_state)
        @game_state = game_state
        @player = @game_state.active_turn
        @other_payer = @player == 'x' ? 'o' : 'x'

        # Pick the last available space if there is only one
        if @game_state.get_blanks.length == 1
          @game_state.get_new_state(@game_state.get_blanks.first)
        else
          ideal_move = min_choice(@game_state)
          @game_state.get_new_state(ideal_move[:choice])
        end
      end

      private

        def max_choice(state)
          # Check for an end condition
          if state.win?(@player)
            return 1
          elsif state.win?(@other_payer)
            return -1
          elsif state.draw?
            return 0
          else
            # Set a blank best choice hash
            best_choice = { score: 0 }
            # Loop through each available space
            state.get_blanks.each do | choice |
              new_state = state.get_new_state(choice)
              next_choice = min_choice(new_state)
              next_choice = next_choice.is_a?(Integer) ? { choice: choice, score: next_choice } : next_choice
              best_choice = next_choice if next_choice[:score] > best_choice[:score]
            end
            return best_choice
          end
        end

        def min_choice(state)
          if state.win?(@player)
            return -1
          elsif state.win?(@other_payer)
            return 1
          elsif state.draw?
            return 0
          else
            # Set a blank best choice hash
            best_choice = { score: 0 }
            # Loop through each available space
            state.get_blanks.each do | choice |
              new_state = state.get_new_state(choice)
              next_choice = max_choice(new_state)
              next_choice = next_choice.is_a?(Integer) ? { choice: choice, score: next_choice } : next_choice
              best_choice = next_choice if next_choice[:score] > best_choice[:score]
            end
            return best_choice
          end
        end
    end
  end
end
