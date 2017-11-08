class MemoController < ApplicationController

  def overview
    @candidates = Candidate.all
    if params.has_key?('candidate_id')
      @candidate = Candidate.find(params['candidate_id'])
      @notes = Note.all.where('candidate_id = ?', params['candidate_id'])
    end
  end

  def new_note
    if params.has_key?('note')
      @note = Note.create(user_id: 3,  candidate_id: params['candidate_id'], message: params['note'])
      render json: @note
      return
    end
    render json: params
  end
end
