require "./lib/corpse.rb"
require "minitest/autorun"

describe Corpse do
  describe "Game" do
    before do
      @game = Corpse::Game.new 1
      @player = Corpse::Player.new "Machino"
    end

    it "creates a game" do
      @game.rounds.must_equal 1
      @game.players.must_equal []
      @game.status.must_equal :created
    end

    it "adds a player" do
      @game.add_player @player
      @game.players.first.name.must_equal "Machino"
    end

    it "starts a game" do
      @game.add_player @player
      @game.start
      @game.status.must_equal :started
    end
  end
end

