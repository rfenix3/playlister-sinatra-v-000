require 'rack-flash'

class SongsController < ApplicationController
  use Rack::Flash

  get '/songs' do
    @songs = Song.all
    erb :'/songs/index'
  end

  get '/songs/new' do
    erb :'/songs/new'
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    @artist = Artist.find(@song.artist_id)
    @song_genre = SongGenre.find_by(song_id: @song.id)
    @genre = Genre.find_by(id: @song_genre.genre_id)
    erb :'/songs/show'
  end

  post '/songs' do
     @song = Song.create(:name => params["Name"])
     @song.artist = Artist.find_or_create_by(:name => params["Artist Name"])
     @song.genre_ids = params[:genres]
     @song.save

     flash[:message] = "Successfully created song."
     redirect "/songs/#{@song.slug}"
   end

   get '/songs/:slug/edit' do
     @song = Song.find_by_slug(params[:slug])
     erb :'songs/edit'
   end

   patch '/songs/:slug' do
     binding.pry
     @song = Song.find_by_slug(params[:slug])
     @song.update(params[:song])
     @song.artist = Artist.find_or_create_by(name: params[:artist][:name])
     @song.genre_ids = params[:genres]
     binding.pry
     @song.save

     flash[:message] = "Successfully updated song."
     redirect("/songs/#{@song.slug}")
   end

end
