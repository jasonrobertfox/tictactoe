# Encoding: utf-8

module Tictactoe
  class Board
    BLANK = ''

    attr_reader :size, :available_moves, :corner_spaces, :winner, :number_of_spaces, :player_piece, :opponent_piece

    def initialize(size, player_piece, opponent_piece)
      validate_piece player_piece
      validate_piece opponent_piece
      validate_pieces_different player_piece, opponent_piece
      @player_piece = player_piece
      @opponent_piece = opponent_piece
      @size = size
      @moves_left = @number_of_spaces = size**2
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
      @player_piece, @opponent_piece = opponent_piece, player_piece
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

    def winner_exists?
      !!@winner
    end

    def has_lost?(piece)
      @winner && @winner != piece
    end

    def has_won?(piece)
      piece == @winner
    end

    def clone
      copy = super
      copy.board = deep_copy @board
      copy
    end



    def check_for_win
      @winner = winning_row || winning_column || winning_diagonal || winning_reverse_diagonal
    end

      def validate_piece(piece)
        fail ArgumentError, "Piece #{piece} must be a single character." if piece.length != 1
      end

      def validate_pieces_different(first_player, second_player)
        fail ArgumentError, 'You can not have both pieces be the same character.' if first_player.downcase == second_player.downcase
      end

    def winning_row
      (0..size - 1).to_a.each do |row|
        candidate = @board[row][0]
        unless candidate == BLANK
          catch(:row_fail) do
            (1..size - 1).to_a.each do |column|
              throw :row_fail unless @board[row][column] == candidate
            end
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
          catch(:column_fail) do
            (1..size - 1).to_a.each do |row|
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
      candidate = @board[0][size - 1]
      @board.each_with_index do |row, index|
        return nil unless row[size - index - 1] == candidate
      end
      candidate
    end



    protected

    def board=(board)
      @board = board
    end

    private

    def deep_copy(value)
      if value.is_a?(Array)
        result = value.clone
        result.clear
        value.each { |v| result << deep_copy(v) }
        result
      else
        value
      end
    end

  end
end
