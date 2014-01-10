# Encoding: utf-8

module Tictactoe
  class Board
    BLANK = ''

    attr_reader :available_moves, :corner_spaces, :number_of_spaces, :player_piece, :opponent_piece, :board, :winner

    def initialize(size, player_piece, opponent_piece)
      @player_piece, @opponent_piece, @size = player_piece, opponent_piece, size
      @board = Array.new(@size) { Array.new(@size, BLANK) }
      initialize_board_meta_data
    end

    def place_piece(piece, coordinate)
      unless piece == BLANK
        @board[coordinate.first][coordinate.last] = piece
        update_moves(coordinate)
        check_for_win if win_possible?
      end
      self
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
      copy.board = @board.map { |i| i.dup }
      copy.available_moves = @available_moves.map { |i| i.dup }
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
      @moves_made >= @minimum_moves_required_to_win
    end

    def check_for_win
      @winner = winning_row(@board) || winning_column || winning_diagonal || winning_reverse_diagonal
    end

    def winning_row(board)
      board.each_with_index do |row, i|
        candidate = row[0]
        if candidate != BLANK && row.count(candidate) == @size
          @winning_line = [i].product(@board_range) if @gather_line
          return candidate
        end
      end
      nil
    end

    def winning_column
      result = winning_row(@board.transpose)
      if result && @gather_line
        @winning_line.map! { |i| i.reverse } if @gather_line
      end
      result
    end

    def winning_diagonal
      check_diagonal(@board[0][0]) { |i| i }
    end

    def winning_reverse_diagonal
      check_diagonal(@board[@max_index][0]) { |i| @max_index - i }
    end

    def check_diagonal(candidate)
      diagonal = []
      (0..@max_index).each do |i|
        column = yield i
        return nil unless candidate != BLANK && @board[i][column] == candidate
        diagonal << [i, column] if @gather_line
      end
      @winning_line = diagonal if diagonal.count == @size
      candidate
    end
  end
end
