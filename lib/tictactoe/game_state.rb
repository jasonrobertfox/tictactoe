# Encoding: utf-8

module Tictactoe
  class GameState
    # TODO: get rid of this blank thing...
    BLANK = ''

    attr_reader :player_piece, :opponent_piece, :winner

    def initialize(player_piece, opponent_piece)
      validate_arguments(player_piece, opponent_piece)
      @player_piece, @opponent_piece = player_piece, opponent_piece
    end

    def board=(board)
      @board = board
      @max_index = board.width - 1
      @board_range = board.width.times.to_a
      @minimum_moves_required_to_win = (2 * board.width) - 1
      check_for_win if win_possible?
    end

    def board
      fail 'Game state has know knowledge of a board.' unless @board
      @board
    end

    def make_move(space)
      new_state = dup
      new_state.player_piece = opponent_piece
      new_state.opponent_piece = player_piece
      new_state.board = board.dup.place_piece(player_piece, space)
      new_state
    end

    def available_moves
      board.blank_spaces
    end

    def corner_spaces
      [0, @max_index].product([0, @max_index])
    end

    def unplayed?
      board.blank?
    end

    def final_move
      return board.blank_spaces.first if board.number_of_blanks == 1
    end

    def over?
      @winner || draw?
    end

    def draw?
      board.number_of_blanks == 0 && !@winner
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

    protected

    attr_writer :player_piece, :opponent_piece

    private

    def validate_arguments(player_piece, opponent_piece)
      validate_piece(player_piece)
      validate_piece(opponent_piece)
      fail ArgumentError, "Pieces must not be the same: #{player_piece}, #{opponent_piece}" if player_piece.downcase == opponent_piece.downcase
    end

    def validate_piece(piece)
      fail ArgumentError, "Pieces must be a single character: #{piece}" unless piece.length == 1
    end

    def win_possible?
      board.number_of_occupied >= @minimum_moves_required_to_win
    end

    def check_for_win
      @winner = winning_row || winning_column || winning_diagonal || winning_reverse_diagonal
    end

    def winning_row
      @board_range.each do |r|
        candidate = board.contents_of([r, 0])
        if candidate != BLANK && @board_range.map { |c| board.contents_of([r, c]) }.count(candidate) == board.width
          @winning_line = [r].product(@board_range) if @gather_line
          return candidate
        end
      end
      nil
    end

    def winning_column
      @board_range.each do |c|
        candidate = board.contents_of([0, c])
        if candidate != BLANK && @board_range.map { |r| board.contents_of([r, c]) }.count(candidate) == board.width
          @winning_line = @board_range.product([c]) if @gather_line
          return candidate
        end
      end
      nil
    end

    def winning_diagonal
      check_diagonal(board.contents_of([0, 0])) { |i| i }
    end

    def winning_reverse_diagonal
      check_diagonal(board.contents_of([@max_index, 0])) { |i| @max_index - i }
    end

    def check_diagonal(candidate)
      diagonal = []
      (0..@max_index).each do |i|
        column = yield i
        return nil unless candidate != BLANK && board.contents_of([i, column]) == candidate
        diagonal << [i, column] if @gather_line
      end
      @winning_line = diagonal if diagonal.count == board.width
      candidate
    end
  end
end
