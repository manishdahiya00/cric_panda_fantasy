class MatchTeamsController < ApplicationController
  before_action :authorize
  before_action :set_match_team, only: [:show, :edit, :update, :destroy]

  # GET /match_teams
  # GET /match_teams.json
  def index
    @match_teams = MatchTeam.all
  end

  # GET /match_teams/1
  # GET /match_teams/1.json
  def show
  end

  # GET /match_teams/new
  def new
    @match_team = MatchTeam.new
  end

  # GET /match_teams/1/edit
  def edit
  end

  # POST /match_teams
  # POST /match_teams.json
  def create
    @match_team = MatchTeam.new(match_team_params)

    respond_to do |format|
      if @match_team.save
        format.html { redirect_to @match_team, notice: 'Match team was successfully created.' }
        format.json { render :show, status: :created, location: @match_team }
      else
        format.html { render :new }
        format.json { render json: @match_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /match_teams/1
  # PATCH/PUT /match_teams/1.json
  def update
    respond_to do |format|
      if @match_team.update(match_team_params)
        format.html { redirect_to @match_team, notice: 'Match team was successfully updated.' }
        format.json { render :show, status: :ok, location: @match_team }
      else
        format.html { render :edit }
        format.json { render json: @match_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /match_teams/1
  # DELETE /match_teams/1.json
  def destroy
    @match_team.destroy
    respond_to do |format|
      format.html { redirect_to match_teams_url, notice: 'Match team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match_team
      @match_team = MatchTeam.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def match_team_params
      params.fetch(:match_team, {})
    end
end
