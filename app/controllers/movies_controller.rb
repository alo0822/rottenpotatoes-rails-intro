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
    redirect = false
    @all_ratings = Movie.uniq.pluck(:rating)
    @ratings_keys = @all_ratings
    
    if params[:ratings]
      @ratings_keys = params[:ratings].keys
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
      @ratings_keys = session[:ratings].keys
      redirect = true
    end
    
    if params[:sorted]
      @sorted = params[:sorted]
      session[:sorted] = @sorted
    else
      @sorted = session[:sorted]
    end
    @movies = Movie.where(:rating => @ratings_keys).order(@sorted)
    
    if redirect
      flash.keep
      redirect_to(movies_path({:sorted => session[:sorted], :ratings => session[:ratings]}))
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
