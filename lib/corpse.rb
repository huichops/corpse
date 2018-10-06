require "corpse/game.rb"
require "corpse/player.rb"

def serialize_game(game)
  { status: game.status, players: game.players, rounds: game.rounds }
end

module Corpse
  class InvalidGame < StandardError
    def initialize(msg="Invalid game")
      super
    end
  end

  class InvalidGameState < StandardError
    def initialize(msg="Invalid game state")
      super
    end
  end

  class InvalidPlayer < StandardError
    def initialize(msg="Invalid player")
      super
    end
  end

  def self.create_player(player_name)
    Player.new player_name
  end

  def self.create_game(rounds)
    if rounds == 0
      raise InvalidGame.new("Rounds must be greater than 0")
    end

    @game = Game.new rounds
    serialize_game @game
  end

  def self.invite_player(player)
    if player.class != Corpse::Player
      raise InvalidPlayer.new
    end

    @game.add_player player
    serialize_game @game
  end

  def self.start_game
    if @game.players.length <= 1
      raise InvalidGameState.new
    end

    if @game.status == :started
      raise InvalidGameState.new
    end


    @game.start
    serialize_game @game
  end

  def self.next_player
    if @game.status != :started
      raise InvalidGameState.new
    end

    @game.current_player
  end

  def self.next_turn
    if @game.status != :started
      raise InvalidGameState.new
    end

    { player: @game.current_player, last_line: @game.last_line }
  end

  def self.play_turn(line)
    if @game.status != :started
      raise InvalidGameState.new
    end

    if @game.current_player != nil
      @game.play_turn line
      @game.next_player

      { player: @game.current_player, last_line: @game.last_line }
    else
      @game.finish
    end
  end
end
