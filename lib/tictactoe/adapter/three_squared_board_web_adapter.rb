# Encoding: utf-8

require 'tictactoe/player/perfect_player'
require 'tictactoe/board_factory'

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
        board = create_board(player_piece, opponent_piece, board_data)
        unless board.over?
          board = Tictactoe::Player::PerfectPlayer.new(player_piece).take_turn(board)
        end
        create_response board
      end

      private

      def validate_request_data(request_data)
        player_piece = request_data['player_piece']
        opponent_piece = request_data['opponent_piece']
        board = request_data['board']
        fail ArgumentError, "Provided pieces need to be different." if player_piece && opponent_piece && (player_piece == opponent_piece)
        fail ArgumentError, "Board given contains less than #{board_width**2} spaces." unless board.count == board_width**2
        board.each do |i|
          unless [player_piece, opponent_piece, ''].include?(i['value'])
            fail ArgumentError, "Pieces in board must be either #{player_piece}, #{opponent_piece} or blank."
          end
        end
      end

      def create_board(player_piece, opponent_piece, board_data)
        board = Tictactoe::BoardFactory.build(board_width, player_piece, opponent_piece)
        board_data.each do |space|
          board.place_piece space['value'], id_to_coordinate(space['id'])
        end
        board
      end

      def create_response(board)
        { piece: board.player_piece, board: make_board_data(board) }.merge(make_meta_data(board))
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
