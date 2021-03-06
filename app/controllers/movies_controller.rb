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


    sort = params[:sort] || session[:sort]
    if (session[:sort] == nil)
      session[:sort] = params[:sort]
    end
    
    @selected_ratings = params[:ratings] || session[:selected_ratings] || Hash[@all_ratings.map{|rating| [rating, rating]}]
    session[:selected_ratings] = params[:ratings]
    if (session[:selected_ratings] == nil)
      session[:selected_ratings] = params[:selected_ratings]
    end
    
    case sort
    when "title"
      @movies = Movie.where(:rating => @selected_ratings.keys).order(:title)
      @title = 'hilite'
    when "releasedate" 
      @movies = Movie.where(:rating => @selected_ratings.keys).order(:release_date)
      @releasedate = 'hilite'
    else
      @movies = Movie.where(:rating => @selected_ratings.keys)
    end
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
