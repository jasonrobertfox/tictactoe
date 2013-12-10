# Encoding: utf-8

module App
  class GameState
    attr_accessor :board, :active_turn

    def self.new_from_data(board, active_turn)
      board_array = [[], [], []]
        rows = %w(top middle bottom)
        columns = %w(left center right)
        board.each do |space|
          row_column = space['id'].split('-')
          row = rows.index(row_column.first)
          column = columns.index(row_column.last)
          board_array[row][column] = space['value']
        end
        new(board_array, active_turn)
    end

    def initialize(board, active_turn)
      @id = SecureRandom.uuid
      @board = board
      @active_turn = active_turn
    end

    def over?
      win? || draw?
    end

    def win?(player = nil)
      # Test for both players unless one is specified
      return win?('x') || win?('o') unless player

      # Check each row
      (0..2).each do | row |
        return true if @board[row][0] == player && @board[row][1] == player && @board[row][2] == player
      end

      # Check each column
      (0..2).each do | column |
        return true if @board[0][column] == player && @board[1][column] == player && @board[2][column] == player
      end

      # Check first diagonal
      return true if @board[0][0] == player && @board[1][1] == player && @board[2][2] == player

      # Check second diagonal
      return true if @board[0][2] == player && @board[1][1] == player && @board[2][0] == player

      # There is no win at this point, but there could be a draw
      false
    end

    def draw?
      # A draw is a full board without a win
      !win? && !@board.flatten.include?('')
    end

    def get_blanks
      blanks = []
      (0..2).each do | row |
        (0..2).each do | column |
          blanks.push([row, column]) if @board[row][column] == ''
        end
      end
      blanks
    end

    def get_new_state(choice)
      # This needs to be looked into further, as there is some very strange behavior
      # The board reference is updating other objects
      new_board = [[], [], []]
      (0..2).each do | row |
        (0..2).each do | column |
          if row == choice[0] && column == choice[1]
            new_board[row][column] = @active_turn
          else
            new_board[row][column] = @board[row][column]
          end
        end
      end
      active_turn = @active_turn == 'x' ? 'o' : 'x'
      GameState.new(new_board, active_turn)
    end

    def get_data
      return_data = []
      rows = %w(top middle bottom)
      columns = %w(left center right)
      @board.each_index do | row |
        @board[row].each_index do | column |
          return_data.push('id' => "#{rows[row]}-#{columns[column]}", 'value' => @board[row][column])
        end
      end
      return_data
    end
  end
end
