# Encoding: utf-8

require 'tictactoe/game_state'

module Tictactoe
  module Player
    class PerfectPlayer
      attr_reader :piece

      def initialize(piece)
        @piece = piece
      end

      def take_turn(game_state)
        fail ArgumentError, 'It is not this player\'s turn.' if piece != game_state.player_piece
        if game_state.empty?
          game_state.apply_move random_corner_move(game_state)
        elsif game_state.available_moves.count == 1
          game_state.apply_move last_available_move(game_state)
        else
          game_state.apply_move best_possible_move(game_state)
        end
      end

      private

        def random_corner_move(game_state)
          [[0, game_state.board_size - 1].sample, [0, game_state.board_size - 1].sample]
        end

        def last_available_move(game_state)
          game_state.available_moves.first
        end

        def best_possible_move(game_state)
          minmax(game_state, 0)
          @current_move_choice
        end

        def evaluate_state(state, depth)
          if state.have_i_won?(self)
            10 - depth
          elsif state.have_i_lost?(self)
            depth - 10
          else
            0
          end
        end

        def minmax(state, depth)
          return evaluate_state(state, depth) if state.is_over?
          depth += 1
          scores = []
          moves = []
          state.available_moves.each do |choice|
            node = state.apply_move(choice)
            scores.push minmax(node, depth)
            moves.push choice
          end
          if state.player_piece == piece
            # this is a maximizing move
            max_index = scores.each_with_index.max[1]
            @current_move_choice = moves[max_index]
            return scores[max_index]
          else
            # this is a minimizing move
            min_index = scores.each_with_index.min[1]
            @current_move_choice = moves[min_index]
            return scores[min_index]
          end
        end
    end
  end
end
