# Encoding: utf-8

require 'tictactoe/board'
require 'tictactoe/game_state'
require 'tictactoe/player/perfect_player'

module Tictactoe
  module Adapter
    class ThreeSquaredBoardWebAdapter
      attr_reader :board_width

      BOARD_WIDTH = 3

      def initialize
        @rows = %w(top middle bottom)
        @columns = %w(left center right)
      end

      def get_response(request_data)
        @request_data = request_data
        board = build_board
        game_state = build_game_state(board)
        create_response(Tictactoe::Player::PerfectPlayer.new.take_turn(game_state))
      end

      private

      def build_board
        board = Tictactoe::Board.new(BOARD_WIDTH)
        @request_data['board'].each do |space_data|
          piece = space_data['value']
          if valid_piece(piece)
            space = id_to_coordinate(space_data['id'])
            board.place_piece(piece, space)
          end
        end
        board
      end

      def valid_piece(piece)
        [@request_data['player_piece'], @request_data['opponent_piece']].include? piece
      end

      def build_game_state(board)
        player_piece = @request_data['player_piece']
        opponent_piece = @request_data['opponent_piece']
        game_state = Tictactoe::GameState.new(player_piece, opponent_piece)
        game_state.board = board
        game_state
      end

      def create_response(game_state)
        {
          player_piece: game_state.player_piece,
          opponent_piece: game_state.opponent_piece,
          board: build_board_data(game_state)
        }.merge(build_meta_data(game_state))
      end

      def build_board_data(game_state)
        i = 0
        game_state.board.to_a.map do |value|
          coordinate = [i / BOARD_WIDTH, i % BOARD_WIDTH]
          i += 1
          build_space_data(game_state.winning_line, coordinate, value)
        end
      end

      def build_meta_data(game_state)
        return { status: 'draw' } if game_state.draw?
        return { status: 'win', winner: game_state.winner } if game_state.winner_exists?
        { status: 'active' }
      end

      def build_space_data(winning_line, coordinate, value)
        space_data = {}
        space_data[:winning_space] = true if winning_line && winning_line.include?(coordinate)
        space_data[:id] = coordiante_to_id(coordinate)
        space_data[:value] = value || ''
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
