# Encoding: utf-8

module Tictactoe
  class GameState
    BLANK = ''

    attr_reader :player_piece, :opponent_piece, :winner

    attr_writer :board

    def initialize(board, player_piece, opponent_piece)
      @player_piece, @opponent_piece = player_piece, opponent_piece
    end

    def board=(board)
      @board = board
      initialize_board_meta_data
      check_for_win if win_possible?
      self
    end

    def place_piece(piece, coordinate)
      # TODO: this is a hack and we should clean this up.
      self.board = @board.place_piece(piece, coordinate)
      # check_for_win if win_possible?
      self
    end

    def take_turn(space)
      copy = dup
      copy.board = @board.dup.place_piece(player_piece, space)
      copy.check_for_win if copy.win_possible?
      copy.player_piece = @opponent_piece
      copy.opponent_piece = @player_piece
      copy
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
      0.upto(@max_index) do |r|
        row = []
        0.upto(@max_index) do |c|
          row << @board.contents_of([r, c])
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

    attr_writer :player_piece, :opponent_piece

    private

    def initialize_board_meta_data
      @max_index = @board.width - 1
      @board_range = (0..@max_index).to_a
      @minimum_moves_required_to_win = (2 * @board.width) - 1
    end

    def win_possible?
      @board.number_of_occupied >= @minimum_moves_required_to_win
    end

    def check_for_win
      @winner = winning_row || winning_column || winning_diagonal || winning_reverse_diagonal
    end

    def winning_row
      0.upto(@max_index) do |r|
        candidate = @board.contents_of([r, 0])
        if candidate != BLANK && 0.upto(@max_index).map { |c| @board.contents_of([r, c]) }.count(candidate) == @board.width
          @winning_line = [r].product(@board_range) if @gather_line
          return candidate
        end
      end
      nil
    end

    def winning_column
      0.upto(@max_index) do |c|
        candidate = @board.contents_of([0, c])
        if candidate != BLANK && 0.upto(@max_index).map { |r| @board.contents_of([r, c]) }.count(candidate) == @board.width
          @winning_line = @board_range.product([c]) if @gather_line
          return candidate
        end
      end
      nil
    end

    def winning_diagonal
      check_diagonal(@board.contents_of([0, 0])) { |i| i }
    end

    def winning_reverse_diagonal
      check_diagonal(@board.contents_of([@max_index, 0])) { |i| @max_index - i }
    end

    def check_diagonal(candidate)
      diagonal = []
      (0..@max_index).each do |i|
        column = yield i
        return nil unless candidate != BLANK && @board.contents_of([i, column]) == candidate
        diagonal << [i, column] if @gather_line
      end
      @winning_line = diagonal if diagonal.count == @board.width
      candidate
    end
  end
end
