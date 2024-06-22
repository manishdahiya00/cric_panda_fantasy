class UserContestsController < ApplicationController
  before_action :authorize
  before_action :set_user_contest, only: [:show, :edit, :update, :destroy]

  # GET /user_contests
  # GET /user_contests.json
  def index
    @user_contests = UserContest.all
  end

  # GET /user_contests/1
  # GET /user_contests/1.json
  def show
  end

  # GET /user_contests/new
  def new
    @user_contest = UserContest.new
  end

  # GET /user_contests/1/edit
  def edit
  end

  # POST /user_contests
  # POST /user_contests.json
  def create
    @user_contest = UserContest.new(user_contest_params)

    respond_to do |format|
      if @user_contest.save
        format.html { redirect_to @user_contest, notice: 'User contest was successfully created.' }
        format.json { render :show, status: :created, location: @user_contest }
      else
        format.html { render :new }
        format.json { render json: @user_contest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_contests/1
  # PATCH/PUT /user_contests/1.json
  def update
    respond_to do |format|
      if @user_contest.update(user_contest_params)
        format.html { redirect_to @user_contest, notice: 'User contest was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_contest }
      else
        format.html { render :edit }
        format.json { render json: @user_contest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_contests/1
  # DELETE /user_contests/1.json
  def destroy
    @user_contest.destroy
    respond_to do |format|
      format.html { redirect_to user_contests_url, notice: 'User contest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_contest
      @user_contest = UserContest.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_contest_params
      params.fetch(:user_contest, {})
    end
end
