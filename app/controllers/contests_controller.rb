class ContestsController < ApplicationController
  before_action :authorize
  before_action :set_contest, only: [:show, :edit, :update, :destroy]

  # GET /contests
  # GET /contests.json
  def index
    @contests = Contest.all.order('created_at desc').paginate(:page => params[:page], :per_page => PER_PAGE)
  end

  # GET /contests/1
  # GET /contests/1.json
  def show
  end

  # GET /contests/new
  def new
    if !ContestCategory.first.present?
      ContestCategory.create(title: 'Mega Contest', gtype: 'Cricket', description: 'Mega Contest')
      ContestCategory.create(title: 'Trending Now', gtype: 'Cricket', description: 'Trending Now')
      ContestCategory.create(title: 'Low-Entry Contest', gtype: 'Cricket', description: 'Low-Entry Contest')
      ContestCategory.create(title: 'Beginners Play', gtype: 'Cricket', description: 'Beginners Play')
    end
    @contest = Contest.new
  end

  # GET /contests/1/edit
  def edit
  end

  # POST /contests
  # POST /contests.json
  def create
    @contest = Contest.new(contest_params)

    respond_to do |format|
      if @contest.save
        format.html { redirect_to contests_url, notice: 'Contest was successfully created.' }
        #format.html { redirect_to @contest, notice: 'Contest was successfully created.' }
        format.json { render :show, status: :created, location: @contest }
      else
        format.html { render :new }
        format.json { render json: @contest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contests/1
  # PATCH/PUT /contests/1.json
  def update
    respond_to do |format|
      if @contest.update(contest_params)
        format.html { redirect_to @contest, notice: 'Contest was successfully updated.' }
        format.json { render :show, status: :ok, location: @contest }
      else
        format.html { render :edit }
        format.json { render json: @contest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contests/1
  # DELETE /contests/1.json
  def destroy
    @contest.destroy
    respond_to do |format|
      format.html { redirect_to contests_url, notice: 'Contest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contest
      @contest = Contest.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contest_params
      #params.fetch(:contest, {})
      params.require(:contest).permit(:title, :entry_fee, :etype, :total_spot, :description,
        :contest_category_id, :entry_allowed, :winning_prize, :first_prize, :winning_percentage,
        :status, :commission, :discount, :bonus)
    end
end
