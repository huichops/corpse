module Corpse
  class Game
    def initialize(rounds)
      @rounds = rounds
      @players = []
      @status = :created
      @current_player = 0
      @current_round = 1
      @text = []
    end

    def last_line
      @text.last
    end

    def add_player(player)
      @players.push(player)
    end

    def current_player
      @players[@current_player]
    end

    def next_player
      if @current_player == @players.length-1 && @current_round < @rounds
        @current_player = 0
        @current_round += 1
      else 
        @current_player += 1
      end
    end

    def play_turn(line)
      @text.push line
    end

    def finish
      @status = :finished
      { :status => @status, :text => @text.join("\n") }
    end

    def start
      @status = :started
    end

    attr_reader :rounds, :players, :status
  end
end
