class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
   
    session[:sort] = params[:sort] if params[:sort]
    session[:sort] = 'id' if !session[:sort]
    
    session[:ratings] = params[:ratings] if params[:ratings]
    session[:ratings] = Hash[@all_ratings.map {|rating| [rating, rating]}] if !session[:ratings]
    
    if (!params[:sort] || !params[:ratings])
     flash.keep
     redirect_to movies_path :sort => session[:sort], :ratings => session[:ratings]
    end
   
    @displayed_ratings = session[:ratings].keys
    @movies = Movie.where(rating: @displayed_ratings).order(session[:sort])
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
