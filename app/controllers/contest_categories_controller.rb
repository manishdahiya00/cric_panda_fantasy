class ContestCategoriesController < ApplicationController
  before_action :authorize
  before_action :set_contest_category, only: [:show, :edit, :update, :destroy]

  # GET /contest_categories
  # GET /contest_categories.json
  def index
    @contest_categories = ContestCategory.all
  end

  # GET /contest_categories/1
  # GET /contest_categories/1.json
  def show
  end

  # GET /contest_categories/new
  def new
    @contest_category = ContestCategory.new
  end

  # GET /contest_categories/1/edit
  def edit
  end

  # POST /contest_categories
  # POST /contest_categories.json
  def create
    @contest_category = ContestCategory.new(contest_category_params)

    respond_to do |format|
      if @contest_category.save
        format.html { redirect_to @contest_category, notice: 'Contest category was successfully created.' }
        format.json { render :show, status: :created, location: @contest_category }
      else
        format.html { render :new }
        format.json { render json: @contest_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contest_categories/1
  # PATCH/PUT /contest_categories/1.json
  def update
    respond_to do |format|
      if @contest_category.update(contest_category_params)
        format.html { redirect_to @contest_category, notice: 'Contest category was successfully updated.' }
        format.json { render :show, status: :ok, location: @contest_category }
      else
        format.html { render :edit }
        format.json { render json: @contest_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contest_categories/1
  # DELETE /contest_categories/1.json
  def destroy
    @contest_category.destroy
    respond_to do |format|
      format.html { redirect_to contest_categories_url, notice: 'Contest category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contest_category
      @contest_category = ContestCategory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contest_category_params
      params.fetch(:contest_category, {})
    end
end
