# Encoding: utf-8

module App
  class GameState
    attr_reader :board, :board_array, :active_turn

    def initialize(board, active_turn)
      @board = board
      @active_turn = active_turn
      @board_array = make_board_array(board)
    end

    def over?
      win? || draw?
    end

    def win?(player = nil)
      # Test for both players unless one is specified
      return win?('x') || win?('o') unless player

      # Check each row
      (0..2).each do | row |
        return true if @board_array[row][0] == player && @board_array[row][1] == player && @board_array[row][2] == player
      end

      # Check each column
      (0..2).each do | column |
        return true if @board_array[0][column] == player && @board_array[1][column] == player && @board_array[2][column] == player
      end

      # Check first diagonal
      return true if @board_array[0][0] == player && @board_array[1][1] == player && @board_array[2][2] == player

      # Check second diagonal
      return true if @board_array[0][2] == player && @board_array[1][1] == player && @board_array[2][0] == player

      # There is no win at this point, but there could be a draw
      false
    end

    def draw?
      # A draw is a full board without a win
      !win? && !@board_array.flatten.include?('')
    end

    private

      def make_board_array(board)
        board_array = [[], [], []]
        rows = %w(top middle bottom)
        columns = %w(left center right)
        board.each do |space|
          row_column = space[:id].split('-')
          row = rows.index(row_column.first)
          column = columns.index(row_column.last)
          board_array[row][column] = space[:value]
        end
        board_array
      end
  end
end
