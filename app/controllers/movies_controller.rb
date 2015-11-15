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
    
    sort_order = nil
    selected_ratings = nil
    session_sort = false
    session_ratings = false

    if session[:sort] && !params[:sort]
      session_sort = true
      sort_order = session[:sort]
    elsif params[:sort]
      session_sort = false
      sort_order = params[:sort]
    end
    
    if session[:ratings] && !params[:ratings]
      session_ratings = true
      selected_ratings = session[:ratings]
    elsif params[:ratings]
      session_ratings = false
      selected_ratings = params[:ratings]
      
    end
    
    if session_ratings || session_sort
      flash.keep
      redirect_to movies_path(sort: sort_order, ratings: selected_ratings) and return
    end
    
    if sort_order != nil && selected_ratings != nil
      @movies = Movie.where(:rating => selected_ratings.keys).order(sort_order).all 
    elsif sort_order != nil && selected_ratings == nil
      @movies = Movie.order(sort).all
    elsif sort_order == nil && selected_ratings != nil
      @movies = Movie.where(:rating => params[:ratings].keys)  
    else
      @movies = Movie.all
    end
    
    if params[:ratings] == nil
      params[:ratings] = Movie.MPAARatings
    end
    @all_ratings = Movie.MPAARatings.keys
    
  end

  def sorted_filtered_grid
    @movies = Movie.where(:rating => params[:ratings].keys).order(params[:sort]).all 
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