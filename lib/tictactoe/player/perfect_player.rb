# Encoding: utf-8

# require 'tictactoe/game_state'

module Tictactoe
  module Player
    class PerfectPlayer
      attr_reader :piece, :game_state

      Node = Struct.new(:score, :move)

      def initialize(piece)
        @piece = piece
      end

      def take_turn(game_state)
        validate_players_turn(game_state)
        @game_state = game_state
        if game_state.blank?
          play_random_corner_move
        elsif game_state.last_move?
          play_last_available_move
        else
          move = best_possible_move
          game_state.place_piece(piece, move)
          game_state
        end
      end

      private

        def validate_players_turn(game_state)
          fail ArgumentError, 'It is not this player\'s turn.' if piece != game_state.player_piece
        end

        def play_random_corner_move
          move = game_state.corner_spaces.sample
          game_state.place_piece(piece, move)
          game_state
        end

        def play_last_available_move
          move = game_state.available_moves[0]
          game_state.place_piece(piece, move)
          game_state
        end

        def last_available_move
          game_state.available_moves.first
        end

        def best_possible_move
          @base_score = game_state.number_of_spaces + 1
          minmax(game_state, 0)
          @current_move_choice
        end

        def minmax(node_state, depth)
          return evaluate_state(node_state, depth) if node_state.over?
          minmax_node = reduce_nodes(node_state, generate_nodes(node_state, depth))
          @current_move_choice = minmax_node.move
          minmax_node.score
        end

        def evaluate_state(node_state, depth)
          if node_state.has_won?(piece)
            @base_score - depth
          elsif node_state.has_lost?(piece)
            depth - @base_score
          else
            0
          end
        end

        def generate_nodes(node_state, depth)
          node_state.available_moves.map do |move|
            new_node = node_state.hand_off
            new_node.place_piece(node_state.player_piece, move)

            Node.new minmax(new_node, depth + 1), move
          end
        end

        def reduce_nodes(node_state, nodes)
          nodes.reduce do |base, node|
            if node_state.player_piece == piece
              base.score > node.score ? base : node
            else
              base.score < node.score ? base : node
            end
          end
        end
    end
  end
end
