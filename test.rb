# frozen_string_literal: true

require 'awesome_print'
require 'genius'
require 'open-uri'
require 'nokogiri'

Genius.access_token = 'JDdB5QgHH801TIX8YRyNoy4Y1QdA7SmWvqFKHFMUcZbK0jn_LnGTfI389zOalZcz'
# access_token = 'JDdB5QgHH801TIX8YRyNoy4Y1QdA7SmWvqFKHFMUcZbK0jn_LnGTfI389zOalZcz'
JUL = Genius::Artist.find(74_283)
random = rand(0..20)

song = JUL.songs(params: { per_page: 50, page: rand(1..15) })[random].resource
ap song
song_api_url = song['api_path']
song_title = song['title_with_featured']
song_url = song['url']
song_art = song['primary_artist']['image_url']
song_id = song['id']
song_embed = song['embed_content']

song_scrap = Nokogiri::HTML(open("https://genius.com#{@song_api_url}"))

full_lyrics = song_scrap.search('.lyrics').text.strip.split("\n").map { |line| line if line =~ /^[A-Z]+[a-zA-Z0-9_ ]*/ }
song_art = song['primary_artist']['image_url']
parsed_lyrics = full_lyrics.reject { |line| line.nil? || line == '' }

# ap song
# p song_embed

# api_response = open("http://api.genius.com#{song_api_url}&access_token=#{access_token}")
# p song

song_reponse = Genius::Song.find(song_id).raw_response['response']['song']

ap song_reponse['url']
