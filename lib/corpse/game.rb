module Corpse
  class Game
    def initialize(rounds)
      @rounds = rounds
      @players = []
      @status = :created
      @current_player = 0
    end

    def invite(player)
      @players.push(player)
    end

    def start
      @status = :started
    end

    attr_reader :rounds, :players, :status
  end
end