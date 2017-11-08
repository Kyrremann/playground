class CandidateController < ApplicationController
  before_filter :find_candidate, only: [:show, :edit, :update]

  def index
    @candidates = Candidate.all
  end

  def show
  end

  def new
    @candidate = Candidate.new
  end

  def create
    @candidate = Candidate.new(candidate_params)
    if @candidate.save
      redirect_to overview_candidate_path(@candidate)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @candidate.update(candidate_params)
      redirect_to overview_candidate_path(@candidate)
    else
      render 'edit'
    end
  end

  private

  def candidate_params
    params.require(:candidate).permit(:name, :project, :image, :email, :phone, :job, :linkedin, :address)
  end

  def find_candidate
    @candidate = Candidate.find(params[:id])
  end
end
