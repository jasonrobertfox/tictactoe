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
          # Whoever is playing is trying to maximize their game
          max_choice(@game_state, 0)
          @game_state.get_new_state(@choice)
        end
      end

      private

        def evaluate_state(state, depth)
          if state.win?(@player)
            # The active turn for a current state is next player
            score = 10 - depth
          elsif state.win?(@other_payer)
            score = depth - 10
          else
            score = 0
          end
          # puts "Terminal state: #{state.board.inspect} #{score}"
          score
        end

        def max_choice(state, depth)
          return evaluate_state(state, depth) if state.over?
          base_score = -100_000
          depth += 1
          state.get_blanks.each do |choice|
            node = state.get_new_state(choice)
            # puts "Max #{depth} -> #{node.board}"
            score = min_choice(node, depth)
            if score > base_score
              base_score = score
              @choice = choice
            end
          end
          base_score
        end

        def min_choice(state, depth)
          return evaluate_state(state, depth) if state.over?
          base_score = 100_000
          depth += 1
          state.get_blanks.each do |choice|
            node = state.get_new_state(choice)
            # puts "Min #{depth} -> #{node.board}"
            score = max_choice(node, depth)
            base_score = score if score < base_score
          end
          base_score
        end
    end
  end
end
