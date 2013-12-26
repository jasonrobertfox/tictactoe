# Encoding: utf-8

require 'tictactoe/player/perfect_player'
require 'tictactoe/game_state'

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
        validate_piece(request_data)
        turn_piece = extract_turn_piece_from_request(request_data)
        validate_board(request_data)
        board = extract_board_from_request(request_data)
        game_state = create_game_state(turn_piece, board)
        validate_game_state(game_state)
        create_response Tictactoe::Player::PerfectPlayer.new(turn_piece).take_turn(game_state)
      end

      private

        def validate_piece(request_data)
          fail ArgumentError, "Piece was not defined as either #{player_one} or #{player_two}." unless request_data['piece'] && (request_data['piece'] == player_one || request_data['piece'] == player_two)
        end

        def extract_turn_piece_from_request(request_data)
          request_data['piece']
        end

        def validate_board(request_data)
          fail ArgumentError, "Board given contains less than #{board_width**2} spaces." unless request_data['board'].count == 9
        end

        def extract_board_from_request(request_data)
          board = Array.new(board_width) { Array.new }
          request_data['board'].each do |space|
            row_column = space['id'].split('-')
            row = @rows.index(row_column.first)
            column = @columns.index(row_column.last)
            board[row][column] = space['value']
          end
          board
        end

        def create_game_state(turn_piece, board)
          opponent_piece = turn_piece == player_one ? player_two : player_one
          Tictactoe::GameState.new(board, turn_piece, opponent_piece)
        end

        def validate_game_state(game_state)
          fail ArgumentError, 'Nothing to do, the board provided is a draw.' if game_state.is_draw?
          fail ArgumentError, 'Nothing to do, there is already a winner.' if game_state.has_someone_won?
        end

        def create_response(game_state)
          board_data = []
          game_state.board.each_with_index do |row, r|
            row.each_with_index do |value, c|
              board_data.push('id' => "#{@rows[r]}-#{@columns[c]}", 'value' => value)
            end
          end
          { piece: game_state.player_piece, board: board_data }
        end
    end
  end
end
