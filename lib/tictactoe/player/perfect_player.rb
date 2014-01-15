# Encoding: utf-8

module Tictactoe
  module Player
    class PerfectPlayer
      attr_reader :piece, :board

      INITIAL_DEPTH = 0
      LOWER_BOUND = -100_000
      UPPER_BOUND = 100_000

      Node = Struct.new(:score, :move)

      def initialize(piece)
        @piece = piece
      end

      def take_turn(board)
        validate_players_turn(board)
        @board = board
        board.place_piece(piece, choose_move).hand_off
      end

      private

      def validate_players_turn(board)
        fail ArgumentError, 'It is not this player\'s turn.' if piece != board.player_piece
      end

      def choose_move
        return board.corner_spaces.sample if board.blank?
        return board.available_moves[0] if board.last_move?
        best_possible_move
      end

      def best_possible_move
        @base_score = board.number_of_spaces + 1
        minmax(board, INITIAL_DEPTH, LOWER_BOUND, UPPER_BOUND)
        @current_move_choice
      end

      def minmax(board, depth, lower, upper)
        return evaluate_state(board, depth) if board.over?
        candidate_move_nodes = []
        board.available_moves.each do |move|

          node = build_node(board, move, depth + 1, lower, upper)

          if board.player_piece == piece
            candidate_move_nodes << node
            lower = node.score if node.score > lower
          else
            upper = node.score if node.score < upper
          end

          break if upper < lower
        end

        return upper unless  board.player_piece == piece
        @current_move_choice = candidate_move_nodes.max_by { |node| node.score }.move
        lower
      end

      def build_node(board, move, depth, lower, upper)
        child_board = board.hand_off.place_piece(board.player_piece, move)
        score = minmax(child_board, depth + 1, lower, upper)
        Node.new score, move
      end

      def evaluate_state(board, depth)
        if board.won?(piece)
          @base_score - depth
        elsif board.lost?(piece)
          depth - @base_score
        else
          0
        end
      end
    end
  end
end
