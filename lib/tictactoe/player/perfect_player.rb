# Encoding: utf-8

module Tictactoe
  module Player
    class PerfectPlayer
      attr_reader :piece, :game_state

      INITIAL_DEPTH = 0
      LOWER_BOUND = -100_000
      UPPER_BOUND = 100_000

      Node = Struct.new(:score, :move)

      def initialize(piece)
        @piece = piece
      end

      def take_turn(game_state)
        validate_players_turn(game_state)
        @game_state = game_state
        game_state.make_move(choose_move)
      end

      private

      def validate_players_turn(game_state)
        fail ArgumentError, 'It is not this player\'s turn.' if piece != game_state.player_piece
      end

      def choose_move
        return game_state.corner_spaces.sample if game_state.unplayed?
        return game_state.final_move if game_state.final_move
        best_possible_move
      end

      def best_possible_move
        @base_score = game_state.number_of_spaces + 1
        minmax(game_state, INITIAL_DEPTH, LOWER_BOUND, UPPER_BOUND)
      end

      def minmax(game_state, depth, lower, upper)
        return evaluate_state(game_state, depth) if game_state.over?
        candidate_move_nodes = []
        game_state.available_moves.each do |move|

          node = build_node(game_state, move, depth + 1, lower, upper)

          if game_state.player_piece == piece
            candidate_move_nodes << node
            lower = node.score if node.score > lower
          else
            upper = node.score if node.score < upper
          end
          break if upper < lower
        end

        return upper unless  game_state.player_piece == piece
        return candidate_move_nodes.max_by { |node| node.score }.move if depth == 0
        lower
      end

      def build_node(game_state, move, depth, lower, upper)
        # child_board = game_state.hand_off.place_piece(game_state.player_piece, move)
        child_board = game_state.make_move(move)
        score = minmax(child_board, depth + 1, lower, upper)
        Node.new score, move
      end

      def evaluate_state(game_state, depth)
        if game_state.won?(piece)
          @base_score - depth
        elsif game_state.lost?(piece)
          depth - @base_score
        else
          0
        end
      end
    end
  end
end
