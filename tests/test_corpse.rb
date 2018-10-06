require "./lib/corpse.rb"
require "minitest/autorun"

describe "Exiquisite Corpse" do
  describe "Create a Game" do
    it "returns a created Game" do
      game = Corpse::create_game 1
      game.must_equal({ :status => :created, players: [], rounds: 1 })
    end

    it "fails creating a game without rounds" do
      proc { Corpse::create_game(0) }.must_raise Corpse::InvalidGame
    end
  end

  describe "Invites a Player" do
    it "Invites a single player" do
      game = Corpse::create_game 1
      first_player = Corpse::create_player "Machino"

      Corpse::invite_player first_player
      game.must_equal({ :status => :created, players: [first_player], rounds: 1 })
    end

    it "Invites many players" do
      game = Corpse::create_game 1

      players = [
        Corpse::create_player("Machino"),
        Corpse::create_player("Vitas"),
        Corpse::create_player("Lol")
      ]

      players.each { |player| Corpse.invite_player(player) }
 
      game.must_equal({ :status => :created, players: players, rounds: 1 })
    end

    it "fails inviting an invalid player" do
      Corpse::create_game 1
      proc { Corpse::invite_player("hi") }.must_raise Corpse::InvalidPlayer
    end
  end

  describe "Starts a Game" do
    it "fails starting a game without players" do
      Corpse::create_game 1
      proc { Corpse::start_game }.must_raise Corpse::InvalidGameState
    end

    it "fails starting a game with a single player" do
      Corpse::create_game 1
      Corpse::invite_player Corpse::create_player("Machino")

      proc { Corpse::start_game }.must_raise Corpse::InvalidGameState
    end

    it "fails starting a started game" do
      Corpse::create_game 1
      Corpse::invite_player Corpse::create_player("Machino")
      Corpse::invite_player Corpse::create_player("Vitas")
      Corpse::start_game

      proc { Corpse::start_game }.must_raise Corpse::InvalidGameState
    end
  end

  describe "Started Game" do
    before do
      @players = [
        Corpse::create_player("Machino"),
        Corpse::create_player("Vitas")
      ]

      Corpse::create_game 1
      @players.each { |player| Corpse.invite_player(player) }
      Corpse::start_game
    end

    it "returns the first turn" do
      Corpse::next_turn.must_equal({ :player => @players.first, :last_line => nil })
    end

    it "finishes a game after every player's turn" do
      first_turn = Corpse::next_turn
      first_turn[:last_line].must_be_nil
      Corpse::play_turn "Érase una vez"

      second_turn = Corpse::next_turn
      second_turn[:last_line].must_equal "Érase una vez"
      Corpse::play_turn "Y este es el fin"

      Corpse::next_turn \
        .must_equal({ :player => nil, :last_line => "Y este es el fin" })
      Corpse::play_turn("Test") \
        .must_equal({ :status => :finished, :text => "Érase una vez\nY este es el fin" })
    end

    it "finishes a game after every player's turn for N rounds" do
      Corpse::create_game 2
      @players.each { |player| Corpse.invite_player(player) }
      Corpse::start_game

      Corpse::next_turn.must_equal({ :player => @players[0], :last_line => nil })
      Corpse::play_turn "Érase una vez"

      Corpse::next_turn.must_equal({ :player => @players[1], :last_line => "Érase una vez" })
      Corpse::play_turn "en un lejano mundo"

      Corpse::next_turn.must_equal({ :player => @players[0], :last_line => "en un lejano mundo" })
      Corpse::play_turn "dónde la princesa"

      Corpse::next_turn.must_equal({ :player => @players[1], :last_line => "dónde la princesa" })
      Corpse::play_turn "se murió, fin"

      expected_text = [
        "Érase una vez",
        "en un lejano mundo",
        "dónde la princesa",
        "se murió, fin"
      ].join("\n")

      Corpse::next_turn \
        .must_equal({ :player => nil, :last_line => "se murió, fin" })
      Corpse::play_turn("Test") \
        .must_equal({ :status => :finished, :text => expected_text })
    end
  end
end
