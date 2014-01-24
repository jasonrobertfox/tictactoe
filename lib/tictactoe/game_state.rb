# Encoding: utf-8

module Tictactoe
  class GameState
    DIAGONAL_ID = 'd'
    REVERSE_DIAGONAL_ID = 'rd'
    COLUMN_PREFIX = 'c'
    ROW_PREFIX = 'r'

    attr_reader :player_piece, :opponent_piece, :winner, :board

    def initialize(player_piece, opponent_piece)
      validate_arguments(player_piece, opponent_piece)
      @player_piece, @opponent_piece = player_piece, opponent_piece
      @imposible_lines = []
    end

    def board=(board)
      @board = board
      @board_width ||= board.width
      @max_index ||= @board_width - 1
      @minimum_moves_required_to_win ||= (2 * @board_width) - 1
      check_for_win
    end

    def make_move(space)
      new_state = dup
      new_state.player_piece = opponent_piece
      new_state.opponent_piece = player_piece
      new_state.imposible_lines = @imposible_lines.dup
      new_state.board = board.dup.place_piece(player_piece, space)
      new_state
    end

    def available_moves
      @board.blank_spaces
    end

    def corner_spaces
      [0, @max_index].product([0, @max_index])
    end

    def unplayed?
      @board.blank?
    end

    def final_move
      return @board.blank_spaces.first if @board.number_of_blanks == 1
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

    protected

    attr_writer :player_piece, :opponent_piece, :imposible_lines

    private

    def validate_arguments(player_piece, opponent_piece)
      validate_piece(player_piece)
      validate_piece(opponent_piece)
      fail ArgumentError, "Pieces must not be the same: #{player_piece}, #{opponent_piece}" if player_piece.downcase == opponent_piece.downcase
    end

    def validate_piece(piece)
      fail ArgumentError, "Pieces must be a single character: #{piece}" unless piece.length == 1
    end

    def check_for_win
      if @board.number_of_occupied >= @minimum_moves_required_to_win
        @winner = winning_row || winning_column || winning_diagonal || winning_reverse_diagonal
      end
    end

    def winning_row
      @board_width.times do |row_index|
        candidate = check_line([row_index, 0], "#{ROW_PREFIX}#{row_index}") { |index| [row_index, index] }
        return candidate if candidate
      end
      nil
    end

    def winning_column
      @board_width.times do |column_index|
        candidate = check_line([0, column_index], "#{COLUMN_PREFIX}#{column_index}") { |index| [index, column_index] }
        return candidate if candidate
      end
      nil
    end

    def winning_diagonal
      check_line([0, 0], DIAGONAL_ID) { |index| [index, index] }
    end

    def winning_reverse_diagonal
      check_line([0, @max_index], REVERSE_DIAGONAL_ID) { |index| [index, @max_index - index] }
    end

    def check_line(candidate_space, line_id)
      return if @imposible_lines.include?(line_id)
      candidate = @board.contents_of(candidate_space)
      return unless candidate
      line = [candidate_space]
      (1..@max_index).each do |index|
        space = yield index
        test_space =  @board.contents_of(space)
        unless test_space == candidate
          @imposible_lines << line_id if test_space
          return
        end
        line << space if @gather_line
      end
      @winning_line = line if @gather_line
      candidate
    end
  end
end
