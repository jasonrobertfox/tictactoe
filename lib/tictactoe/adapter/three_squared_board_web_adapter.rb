# Encoding: utf-8

require 'tictactoe/player/perfect_player'
require 'tictactoe/board_factory'

module Tictactoe
  module Adapter
    class ThreeSquaredBoardWebAdapter
      attr_reader :board_width, :player_one, :player_two

      BOARD_WIDTH = 3

      def initialize(player_one, player_two)
        @board_width = BOARD_WIDTH
        @player_one = player_one
        @player_two = player_two
        @rows = %w(top middle bottom)
        @columns = %w(left center right)
      end

      def get_response(request_data)
        validate_piece(request_data['piece'])
        turn_piece = extract_turn_piece_from_request(request_data)
        validate_board_data(request_data)
        board = create_board(turn_piece, request_data)


        unless board.over?
          board = Tictactoe::Player::PerfectPlayer.new(turn_piece).take_turn(board)
        end

        create_response board
      end

      private

      def validate_piece(piece)
        fail ArgumentError, "Piece was not defined as either #{player_one} or #{player_two}." unless piece && (piece == player_one || piece == player_two)
      end

      def extract_turn_piece_from_request(request_data)
        request_data['piece']
      end

      def validate_board_data(request_data)
        fail ArgumentError, "Board given contains less than #{board_width**2} spaces." unless request_data['board'].count == board_width**2
      end

      def create_board(turn_piece, request_data)
        opponent_piece = turn_piece == player_one ? player_two : player_one
        board = Tictactoe::BoardFactory.build(board_width, turn_piece, opponent_piece)
        request_data['board'].each do |space|
          row_column = space['id'].split('-')
          row = @rows.index(row_column.first)
          column = @columns.index(row_column.last)
          piece = space['value']
          unless piece == ''
            validate_piece piece
            board.place_piece(space['value'], [row, column])
          end
        end
        board
      end

      def create_response(board)
        board_data = []
        board.board.each_with_index do |row, r|
          row.each_with_index do |value, c|
            space_data = { 'id' => "#{@rows[r]}-#{@columns[c]}", 'value' => value }
            if board.winner_exists? && board.winning_line.include?([r, c])
              space_data['winning_space'] = 'true'
            end
            board_data.push(space_data)
          end
        end
        response = { piece: board.player_piece, board: board_data, status: game_status(board) }
        if board.winner_exists?
          response[:winner] = board.winner
        end
        response

      end

      def game_status(board)
        return 'draw' if board.draw?
        return 'win' if board.winner_exists?
        'active'
      end
    end
  end
end
