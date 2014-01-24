# Encoding: utf-8

module Tictactoe
  module Player
    class PerfectPlayer
      INITIAL_DEPTH = 0

      Node = Struct.new(:score, :move)

      def take_turn(game_state)
        return game_state if game_state.over?
        @game_state = game_state
        @piece = game_state.player_piece
        game_state.make_move(choose_move)
      end

      private

      attr_reader :piece, :game_state

      def choose_move
        return game_state.corner_spaces.sample if game_state.unplayed?
        return game_state.final_move if game_state.final_move
        best_possible_move
      end

      def best_possible_move
        @base_score = game_state.available_moves.count + 1
        bound = @base_score + 1
        minmax(game_state, INITIAL_DEPTH, -bound, bound)
        @current_move_choice
      end

      def minmax(game_state, depth, lower_bound, upper_bound)
        return evaluate_state(game_state, depth) if game_state.over?
        candidate_move_nodes = []
        game_state.available_moves.each do |move|
          child_board = game_state.make_move(move)
          score = minmax(child_board, depth + 1, lower_bound, upper_bound)
          node = Node.new score, move

          if game_state.player_piece == piece
            candidate_move_nodes << node
            lower_bound = node.score if node.score > lower_bound
          else
            upper_bound = node.score if node.score < upper_bound
          end
          break if upper_bound < lower_bound
        end

        return upper_bound unless  game_state.player_piece == piece
        @current_move_choice = candidate_move_nodes.max_by { |node| node.score }.move
        lower_bound
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
