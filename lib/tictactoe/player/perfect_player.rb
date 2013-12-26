# Encoding: utf-8

require 'tictactoe/game_state'

module Tictactoe
  module Player
    class PerfectPlayer
      attr_reader :piece

      Node = Struct.new(:score, :move)

      def initialize(piece)
        @piece = piece
      end

      def take_turn(game_state)
        validate_game_state(game_state)
        if game_state.board_empty?
          game_state.apply_move random_corner_move(game_state)
        elsif game_state.available_moves.count == 1
          game_state.apply_move last_available_move(game_state)
        else
          game_state.apply_move best_possible_move(game_state)
        end
      end

      private

        def validate_game_state(game_state)
          fail ArgumentError, 'It is not this player\'s turn.' if piece != game_state.player_piece
        end

        def random_corner_move(game_state)
          max_index = game_state.board_size - 1
          [[0, max_index].sample, [0, max_index].sample]
        end

        def last_available_move(game_state)
          game_state.available_moves.first
        end

        def best_possible_move(game_state)
          @base_score = game_state.board_size**2 + 1
          minmax(game_state, 0)
          @current_move_choice
        end

        def minmax(game_state, depth)
          return evaluate_state(game_state, depth) if game_state.is_over?
          minmax_node = reduce_nodes(game_state, generate_nodes(game_state, depth))
          @current_move_choice = minmax_node.move
          minmax_node.score
        end

        def evaluate_state(game_state, depth)
          if game_state.have_i_won?(self)
            @base_score - depth
          elsif game_state.have_i_lost?(self)
            depth - @base_score
          else
            0
          end
        end

        def generate_nodes(game_state, depth)
          game_state.available_moves.map do |move|
            Node.new minmax(game_state.apply_move(move), depth + 1), move
          end
        end

        def reduce_nodes(game_state, nodes)
          nodes.reduce do |base, node|
            if game_state.player_piece == piece
              base.score > node.score ? base : node
            else
              base.score < node.score ? base : node
            end
          end
        end
    end
  end
end
