# Encoding: utf-8

module Tictactoe
  module Player
    class PerfectPlayer
      attr_reader :piece, :board

      Node = Struct.new(:score, :move)

      def initialize(piece)
        @piece = piece
      end

      def take_turn(board)
        validate_players_turn(board)
        @board = board
        if board.blank?
          new_state = play_random_corner_move
        elsif board.last_move?
          new_state = play_last_available_move
        else
          move = best_possible_move
          new_state = board.place_piece(piece, move)
        end
        new_state.hand_off
      end

      private

        def validate_players_turn(board)
          fail ArgumentError, 'It is not this player\'s turn.' if piece != board.player_piece
        end

        def play_random_corner_move
          move = board.corner_spaces.sample
          board.place_piece(piece, move)
          board
        end

        def play_last_available_move
          move = board.available_moves[0]
          board.place_piece(piece, move)
          board
        end

        def last_available_move
          board.available_moves.first
        end

        def best_possible_move
          @base_score = board.number_of_spaces + 1
          minmax(board, 0)
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
