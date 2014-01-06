# Encoding: utf-8

module Tictactoe
  class Board
    BLANK = ''

    attr_reader :available_moves,
                :corner_spaces,
                :number_of_spaces,
                :player_piece,
                :opponent_piece,
                :board

    def initialize(size, player_piece, opponent_piece)
      validate_pieces(player_piece, opponent_piece)

      @player_piece = player_piece
      @opponent_piece = opponent_piece
      @size = size

      initialize_helper_values
      initialize_board
      initialize_move_data
    end

    def place_piece(piece, coordinate)
      @board[coordinate.first][coordinate.last] = piece
      update_moves(coordinate)
      check_for_win if win_possible?
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

    def has_lost?(piece)
      @winner && @winner != piece
    end

    def has_won?(piece)
      piece == @winner
    end

    def hand_off
      copy = self.dup
      copy.board = deep_copy @board
      copy.available_moves = deep_copy @available_moves
      copy.player_piece = @opponent_piece
      copy.opponent_piece = @player_piece
      copy
    end

    protected

    attr_writer :board, :available_moves, :player_piece, :opponent_piece

    private

    def validate_pieces(player_piece, opponent_piece)
      validate_piece player_piece
      validate_piece opponent_piece
      validate_pieces_different player_piece, opponent_piece
    end

    def validate_piece(piece)
      fail ArgumentError, "Piece #{piece} must be a single character." if piece.length != 1
    end

    def validate_pieces_different(first_player, second_player)
      fail ArgumentError, 'You can not have both pieces be the same character.' if first_player.downcase == second_player.downcase
    end

    def initialize_helper_values
      @number_of_spaces = @size**2
      @max_index = @size - 1
      @board_range = (0..@max_index).to_a
      @minimum_moves_required_to_win = (2 * @size) - 1
    end

    def initialize_board
      @board = Array.new(@size) { Array.new(@size, '') }
    end

    def initialize_move_data
      @moves_left = @number_of_spaces
      @moves_made = 0
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

    def deep_copy(value)
      if value.is_a?(Array)
        result = []
        value.each { |v| result << deep_copy(v) }
        result
      else
        value
      end
    end

    def check_for_win
      @winner = winning_row || winning_column || winning_diagonal || winning_reverse_diagonal
    end

    def winning_row
      @board_range.each do |row|
        candidate = @board[row][0]
        unless candidate == BLANK
          catch(:row_fail) do
            (1..@size - 1).to_a.each do |column|
              throw :row_fail unless @board[row][column] == candidate
            end
            return candidate
          end
        end
      end
      nil
    end

    def winning_column
      @board_range.each do |column|
        candidate = @board[0][column]
        unless candidate == BLANK
          catch(:column_fail) do
            (1..@size - 1).to_a.each do |row|
              throw :column_fail unless @board[row][column] == candidate
            end
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
      candidate = @board[0][@size - 1]
      @board.each_with_index do |row, index|
        return nil unless row[@size - index - 1] == candidate
      end
      candidate
    end

  end
end
