# Encoding: utf-8

module Tictactoe
  class Board
    BLANK = ''

    attr_reader :size, :available_moves, :corner_spaces, :winner

    def initialize(size)
      @size = size
      @moves_left = size**2
      @moves_made = 0
      @board = Array.new(size) { Array.new(size, '') }
      @available_moves = (0..size - 1).to_a.product((0..size - 1).to_a)
      @corner_spaces = [0, size - 1].product([0, size - 1])
    end

    def place_piece(piece, row, column)
      @board[row][column] = piece
      @available_moves.delete([row, column])
      @has_pieces ||= true
      @moves_left -= 1
      @moves_made += 1

      # check for win if a win is possible
      if @moves_made >= 2 * size - 1
        check_for_win
      end
    end

    def piece_at(row, column)
      @board[row][column]
    end

    def blank?
      ! @has_pieces
    end

    def last_move?
      @moves_left == 1
    end

    def over?
      @winner || draw?
    end

    def draw?
      @moves_left == 0 && !@winner
    end

    def check_for_win
      @winner = winning_row || winning_column || winning_diagonal || winning_reverse_diagonal
    end

    def winning_row
      @board.each do |row|
        candidate = row[0]
        unless candidate == BLANK
          (1..size - 1).to_a.each do |column|
            break unless row[column] == candidate
            return candidate
          end
        end
      end
      nil
    end

    def winning_column
      (0..size - 1).to_a.each do |column|
        candidate = @board[0][column]
        unless candidate == BLANK
          (1..size - 1).to_a.each do |row|
            break unless @board[row][column] == candidate
            return candidate
          end
        end
      end
      nil
    end

    def winning_diagonal
      candidate = @board[0][0]
      @board.each_with_index do |row, index|
        return nil unless row[index] == candidate
      end
      candidate
    end

    def winning_reverse_diagonal
      candidate = @board[0][size - 1]
      @board.each_with_index do |row, index|
        return nil unless row[size - index - 1] == candidate
      end
      candidate
    end

  end
end
