# Encoding: utf-8

require 'tictactoe/board'

module Tictactoe
  class GameState
    BLANK = ''

    attr_reader :player_piece, :opponent_piece, :winner

    def initialize(size, player_piece, opponent_piece)
      @player_piece, @opponent_piece, @size = player_piece, opponent_piece, size
      # @board = Array.new(@size) { Array.new(@size, BLANK) }
      @board = Board.new(size)
      initialize_board_meta_data
    end

    def place_piece(piece, coordinate)
      @board.place_piece(piece, coordinate)
      # unless piece == BLANK
      #   @board[coordinate.first][coordinate.last] = piece
      #   update_moves(coordinate)
        check_for_win if win_possible?
      # end
      self
    end

    # Refactor methods

    def contents_of(x, y)
      @board.contents_of([x, y])
    end

    def available_moves
      @board.blank_spaces
    end

    def corner_spaces
      @board.corner_spaces
    end

    def number_of_spaces
      @board.number_of_spaces
    end

    def board
      array = []
      0.upto(@size - 1) do |r|
        row = []
        0.upto(@size - 1) do |c|
          row << contents_of(r, c)
        end
        array << row
      end
      array
    end

    def blank?
      @board.blank?
    end

    def last_move?
      @board.number_of_blanks == 1
    end

    def over?
      @winner || draw?
    end

    def draw?
      @board.number_of_blanks == 0 && !@winner
    end

    def winner_exists?
      !!@winner
    end

    def lost?(piece)
      @winner && @winner != piece
    end

    def won?(piece)
      piece == @winner
    end

    def winning_line
      @gather_line = true
      check_for_win
      @winning_line
    end

    def hand_off
      copy = dup
      copy.board = @board.dup
      copy.player_piece = @opponent_piece
      copy.opponent_piece = @player_piece
      copy
    end

    protected

    attr_writer :board, :available_moves, :player_piece, :opponent_piece

    private

    def initialize_board_meta_data
      @moves_made = 0
      @max_index = @size - 1
      @number_of_spaces = @size**2
      @moves_left = @number_of_spaces
      @board_range = (0..@max_index).to_a
      @minimum_moves_required_to_win = (2 * @size) - 1
      @available_moves = @board_range.product(@board_range)
      @corner_spaces = [0, @max_index].product([0, @max_index])
    end

    def update_moves(coordinate)
      @available_moves.delete(coordinate)
      @has_pieces ||= true
      @moves_left -= 1
      @moves_made += 1
    end

    def win_possible?
      @board.number_of_occupied >= @minimum_moves_required_to_win
    end

    def check_for_win
      @winner = winning_row || winning_column || winning_diagonal || winning_reverse_diagonal
    end

    def winning_row
      0.upto(@size - 1) do |r|
        candidate = contents_of(r, 0)
        if candidate != BLANK && 0.upto(@size - 1).map { |c| contents_of(r, c) }.count(candidate) == @size
          @winning_line = [r].product(@board_range) if @gather_line
          return candidate
        end
      end
      nil
    end

    def winning_column
      0.upto(@size - 1) do |c|
        candidate = contents_of(0, c)
        if candidate != BLANK && 0.upto(@size - 1).map { |r| contents_of(r, c) }.count(candidate) == @size
          @winning_line = @board_range.product([c]) if @gather_line
          return candidate
        end
      end
      nil
    end

    def winning_diagonal
      check_diagonal(contents_of(0, 0)) { |i| i }
    end

    def winning_reverse_diagonal
      check_diagonal(contents_of(@max_index, 0)) { |i| @max_index - i }
    end

    def check_diagonal(candidate)
      diagonal = []
      (0..@max_index).each do |i|
        column = yield i
        return nil unless candidate != BLANK && contents_of(i, column) == candidate
        diagonal << [i, column] if @gather_line
      end
      @winning_line = diagonal if diagonal.count == @size
      candidate
    end
  end
end
