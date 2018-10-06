require "sinatra"
require "./lib/corpse.rb"

post "/game" do
  Corpse::create_game 1
end

post "/player" do
  Corpse::create_player params[:name]
end



