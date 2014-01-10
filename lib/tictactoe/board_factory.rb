# Encoding: utf-8

require 'tictactoe/board'

module Tictactoe
  class BoardFactory
    def self.build(size, player_piece, opponent_piece)
      validate_pieces(player_piece, opponent_piece)
      Board.new(size, player_piece, opponent_piece)
    end

    private

    def self.validate_pieces(player_piece, opponent_piece)
      validate_piece player_piece
      validate_piece opponent_piece
      validate_pieces_different player_piece, opponent_piece
    end

    def self.validate_piece(piece)
      fail ArgumentError, "Piece #{piece} must be a single character." if piece.length != 1
    end

    def self.validate_pieces_different(first_player, second_player)
      fail ArgumentError, 'You can not have both pieces be the same character.' if first_player.downcase == second_player.downcase
    end
  end
end
