module VotesHelper
  def vote_find_actual( paper_id )
    return nil if current_user.nil?
    Vote.find_by_paper_id_and_user_id( paper_id, current_user.id )
  end
end