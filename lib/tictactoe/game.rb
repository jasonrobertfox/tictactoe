# Encoding: utf-8

module Tictactoe
  class Game
    attr_reader :board_size, :first_player, :second_player

    def initialize(board_size, first_player, second_player)
      validate_piece first_player
      validate_piece second_player
      validate_pieces_different first_player, second_player
      @board_size = board_size
      @first_player = first_player
      @second_player = second_player
    end

    private

      def validate_piece(piece)
        fail ArgumentError, "Piece #{piece} must be a single character." if piece.length != 1
      end

      def validate_pieces_different(first_player, second_player)
        fail ArgumentError, 'You can not have both pieces be the same character.' if first_player.downcase == second_player.downcase
      end
  end
end
