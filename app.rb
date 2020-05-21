# frozen_string_literal: true

require 'awesome_print'
require 'genius'
require 'open-uri'
require 'nokogiri'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'

set :public_folder, (proc { File.join(root, "app/public") })
set :views, (proc { File.join(root, "app/views") })
set :bind, '0.0.0.0'

get '/' do
  Genius.access_token = 'JDdB5QgHH801TIX8YRyNoy4Y1QdA7SmWvqFKHFMUcZbK0jn_LnGTfI389zOalZcz'
  JUL = Genius::Artist.find(74_283)
  random = rand(0..20)
  @song_from_artist = JUL.songs(params: { per_page: 50, page: rand(1..15) })[random].resource
  @song_api_url = @song_from_artist['api_path']
  @song_id = @song_from_artist['id']
  @song_embed = @song_from_artist['embed_content']
  @song_title = @song_from_artist['title_with_featured']
  @song_url = @song_from_artist['url']
  @song_scrap = Nokogiri::HTML(open("https://genius.com#{@song_api_url}"))
  @full_lyrics = @song_scrap.search('.lyrics').text.strip.split("\n").map { |line| line if line =~ /^[A-Z]+[a-zA-Z0-9_ ]*/ }
  @parsed_lyrics = @full_lyrics.reject { |line| line.nil? || line == '' }

  @song_reponse = Genius::Song.find(@song_id).raw_response['response']['song']
  @song_embed = @song_reponse['embed_content']
  @song_art = @song_reponse['header_image_url']
  @song_url = @song_reponse['url']
  erb :homepage
end

