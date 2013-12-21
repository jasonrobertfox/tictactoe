# Encoding: utf-8

module Tictactoe
  class GameState

    BLANK = ''

    attr_accessor :board, :player_piece, :opponent_piece

    # def self.new_from_data(board, active_turn)
    #   board_array = [[], [], []]
    #     rows = %w(top middle bottom)
    #     columns = %w(left center right)
    #     board.each do |space|
    #       row_column = space['id'].split('-')
    #       row = rows.index(row_column.first)
    #       column = columns.index(row_column.last)
    #       board_array[row][column] = space['value']
    #     end
    #     next_turn = active_turn == 'x' ? 'o' : 'x'
    #     new(board_array, active_turn, next_turn)
    # end

    def initialize(board, player_piece, opponent_piece)
      validate_piece player_piece
      validate_piece opponent_piece
      validate_pieces_different player_piece, opponent_piece
      @player_piece = player_piece
      @opponent_piece = opponent_piece
      validate_board board
      @board = board
    end

    def is_over?
      has_someone_won? || is_draw?
    end

    def has_someone_won?
      win_for_piece?(player_piece) || win_for_piece?(opponent_piece)
    end

    def is_draw?
      !has_someone_won? && !@board.flatten.include?(BLANK)
    end

    def have_i_won?(player)
      win_for_piece? player.piece
    end

    def have_i_lost?(player)
      !is_draw? && !win_for_piece?(player.piece)
    end

    def available_moves
      moves = []
      board.each_index do |row|
        board[row].each_index do |column|
          moves.push([row, column]) if board[row][column] == BLANK
        end
      end
      moves
    end

    # register_move?
    def get_new_state(choice)
      # This needs to be looked into further, as there is some very strange behavior
      # The board reference is updating other objects
      new_board = [[], [], []]
      (0..2).each do | row |
        (0..2).each do | column |
          if row == choice[0] && column == choice[1]
            new_board[row][column] = player_piece
          else
            new_board[row][column] = @board[row][column]
          end
        end
      end
      GameState.new(new_board, opponent_piece, player_piece)
    end

    # def get_data
    #   return_data = []
    #   rows = %w(top middle bottom)
    #   columns = %w(left center right)
    #   @board.each_index do | row |
    #     @board[row].each_index do | column |
    #       return_data.push('id' => "#{rows[row]}-#{columns[column]}", 'value' => @board[row][column])
    #     end
    #   end
    #   return_data
    # end

    private

      def validate_piece(piece)
        fail ArgumentError, "Piece #{piece} must be a single character." if piece.length != 1
      end

      def validate_pieces_different(first_player, second_player)
        fail ArgumentError, 'You can not have both pieces be the same character.' if first_player.downcase == second_player.downcase
      end

      def validate_board(board)
        if board.length != board.count { |row| row.length == board.length}
          fail ArgumentError, 'Provided board is not square.'
        end
        if board.flatten.reject { |e| [player_piece, opponent_piece, BLANK].include? e }.length > 0
          fail ArgumentError, 'Board contains invalid pieces.'
        end
      end

      def win_for_piece?(piece)

        # Check each row
        (0..2).each do | row |
          return true if @board[row][0] == piece && @board[row][1] == piece && @board[row][2] == piece
        end

        # Check each column
        (0..2).each do | column |
          return true if @board[0][column] == piece && @board[1][column] == piece && @board[2][column] == piece
        end

        # Check first diagonal
        return true if @board[0][0] == piece && @board[1][1] == piece && @board[2][2] == piece

        # Check second diagonal
        return true if @board[0][2] == piece && @board[1][1] == piece && @board[2][0] == piece

        # There is no win at this point, but there could be a draw
        false
      end
  end
end
