# Encoding: utf-8

module Tictactoe
  class GameState
    attr_reader :player_piece, :opponent_piece, :winner

    def initialize(player_piece, opponent_piece)
      validate_arguments(player_piece, opponent_piece)
      @player_piece, @opponent_piece = player_piece, opponent_piece
    end

    def board=(board)
      @board = board
      @max_index ||= board.width - 1
      @board_width = board.width
      @minimum_moves_required_to_win ||= (2 * board.width) - 1
      check_for_win if win_possible?
    end

    def board
      @board || fail('Game state has know knowledge of a board.')
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
      @board_width.times do |r|
        candidate = check_line([r, 0]) { |i| [r, i] }
        return candidate if candidate
      end
      nil
    end

    def winning_column
      @board_width.times do |c|
        candidate = check_line([0, c]) { |i| [i, c] }
        return candidate if candidate
      end
      nil
    end

    def winning_diagonal
      check_line([0, 0]) { |i| [i, i] }
    end

    def winning_reverse_diagonal
      check_line([0, @max_index]) { |i| [i, @max_index - i] }
    end

    def check_line(candidate_space)
      candidate = @board.contents_of(candidate_space)
      return nil unless candidate
      line = [candidate_space]
      (1..@max_index).each do |i|
        space = yield i
        return nil unless @board.contents_of(space) == candidate
        line << space if @gather_line
      end
      @winning_line = line if @gather_line
      candidate
    end
  end
end
