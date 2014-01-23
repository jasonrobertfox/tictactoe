# Encoding: utf-8

module Tictactoe
  class Board
    BLANK = ''

    attr_reader :width, :number_of_spaces, :number_of_blanks, :number_of_occupied, :corner_spaces, :blank_spaces

    def initialize(width)
      @width = width
      @number_of_spaces = @number_of_blanks = width**2
      @number_of_occupied = 0
      @blank_spaces = square_array(width.times.to_a)
      @board = Array.new(@number_of_spaces) { BLANK }
      @corner_spaces = square_array([0, width - 1])
    end

    def blank?
      @number_of_blanks == @number_of_spaces
    end

    def place_piece(piece, space)
      unless piece == BLANK
        @board[calculate_board_index(space)] = piece
        @number_of_blanks -= 1
        @number_of_occupied += 1
        @blank_spaces.delete(space)
      end
      self
    end

    def contents_of(space)
      @board[calculate_board_index(space)]
    end

    def to_a
      @board
    end

    private

    def initialize_copy(source)
      blank_spaces = @blank_spaces.map(&:dup)
      board = @board.dup
      super
      @blank_spaces = blank_spaces
      @board = board
    end

    def square_array(array)
      array.product(array)
    end

    def calculate_board_index(space)
      space.first * @width + space.last
    end
  end
end
