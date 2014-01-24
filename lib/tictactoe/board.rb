# Encoding: utf-8

module Tictactoe
  class Board
    BLANK = nil

    attr_reader :width, :number_of_spaces, :number_of_blanks, :number_of_occupied, :blank_spaces

    def initialize(width)
      @width = width
      @number_of_spaces = @number_of_blanks = width**2
      @number_of_occupied = 0
      @blank_spaces = square_array(width.times.to_a)
      @board =  Array.new(width) { Array.new(width) { BLANK } }
    end

    def blank?
      @number_of_blanks == @number_of_spaces
    end

    def place_piece(piece, space)
      unless piece == BLANK
        @board[space.first][space.last] = piece
        @number_of_blanks -= 1
        @number_of_occupied += 1
        @blank_spaces.delete(space)
      end
      self
    end

    def contents_of(space)
      @board[space.first][space.last]
    end

    def to_a
      @board.flatten
    end

    private

    def initialize_copy(source)
      blank_spaces = @blank_spaces.map(&:dup)
      board = @board.map(&:dup)
      super
      @blank_spaces = blank_spaces
      @board = board
    end

    def square_array(array)
      array.product(array)
    end
  end
end
