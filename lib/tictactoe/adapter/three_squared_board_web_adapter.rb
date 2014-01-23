# Encoding: utf-8

require 'tictactoe/player/perfect_player'
require 'tictactoe/board'
require 'tictactoe/game_state'

module Tictactoe
  module Adapter
    class ThreeSquaredBoardWebAdapter
      attr_reader :board_width

      BOARD_WIDTH = 3

      def initialize
        @board_width = BOARD_WIDTH
        @rows = %w(top middle bottom)
        @columns = %w(left center right)
      end

      def get_response(request_data)
        validate_request_data(request_data)
        player_piece = request_data['player_piece']
        opponent_piece = request_data['opponent_piece']
        board_data = request_data['board']
        game_state = create_game_state(player_piece, opponent_piece, board_data)
        unless game_state.over?
          game_state = Tictactoe::Player::PerfectPlayer.new(player_piece).take_turn(game_state)
        end
        create_response game_state
      end

      private

      def validate_request_data(request_data)
        player_piece = request_data['player_piece']
        opponent_piece = request_data['opponent_piece']
        board = request_data['board']
        fail ArgumentError, 'Provided pieces need to be different.' if player_piece && opponent_piece && (player_piece == opponent_piece)
        fail ArgumentError, "Board given contains less than #{board_width**2} spaces." unless board.count == board_width**2
        board.each do |i|
          unless [player_piece, opponent_piece, ''].include?(i['value'])
            fail ArgumentError, "Pieces in board must be either #{player_piece}, #{opponent_piece} or blank."
          end
        end
      end

      def create_game_state(player_piece, opponent_piece, board_data)
        board = Tictactoe::Board.new(board_width)
        board_data.each do |space|
          board.place_piece space['value'], id_to_coordinate(space['id'])
        end
        game_state = Tictactoe::GameState.new(board, player_piece, opponent_piece)
        game_state.board = board
        game_state
      end

      def create_response(board)
        { player_piece: board.player_piece, opponent_piece: board.opponent_piece, board: make_board_data(board) }.merge(make_meta_data(board))
      end

      def make_board_data(board)
        i = 0
        board_data = []
        board.board.flatten.each do |value|
          coordinate = [i / board_width, i % board_width]
          board_data << make_space_data(board.winning_line, coordinate, value)
          i += 1
        end
        board_data
      end

      def make_meta_data(board)
        return { status: 'draw' } if board.draw?
        return { status: 'win', winner: board.winner } if board.winner_exists?
        { status: 'active' }
      end

      def make_space_data(winning_line, coordinate, value)
        space_data = {}
        space_data[:winning_space] = true if winning_line && winning_line.include?(coordinate)
        space_data[:id] = coordiante_to_id(coordinate)
        space_data[:value] = value
        space_data
      end

      def id_to_coordinate(id)
        row_column = id.split('-')
        [@rows.index(row_column.first), @columns.index(row_column.last)]
      end

      def coordiante_to_id(coordinate)
        "#{@rows[coordinate.first]}-#{@columns[coordinate.last]}"
      end
    end
  end
end
