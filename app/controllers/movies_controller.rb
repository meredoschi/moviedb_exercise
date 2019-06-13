# frozen_string_literal: true

# Movies
class MoviesController < ApplicationController
  before_action :set_movie, only: %i[show edit update destroy]
  before_action :set_current_user_id, only: %i[index]

  load_and_authorize_resource

  # GET /movies
  # GET /movies.json
  def index
    @title = 'List of movies'
    @all_movies = Movie.all.order(:title)
    #    @movies = @all_movies.page(params[:page]).per(10)
    @movies = @all_movies

    respond_to do |format|
      format.html
      format.json do
    # @movies.as_json(include: { category: { only: %i[id name] }, ratings: { only: %i[id user_id movie_id stars] }  }, except: :category_id)
        render json: @movies.as_json(include:
          { category: { only: %i[id name] },
            ratings: { only: %i[id user_id movie_id stars] } },
                                     except: :category_id)
      end
    end
  end

  # GET /movies/1
  # GET /movies/1.json
  def show; end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
    authorize! :edit, @movie
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(movie_params)

    @movie.user_id = current_user.id # authenticated user

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1
  # PATCH/PUT /movies/1.json
  def update

    authorize! :update, @movie

    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    authorize! :destroy, @movie

    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_movie
    @movie = Movie.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def movie_params
    params.require(:movie).permit(:title, :summary, :category_id)
  end

  def set_current_user_id
    @current_user_id = if current_user.present?
                         current_user.id
                       else
                         0
                       end
  end
end
