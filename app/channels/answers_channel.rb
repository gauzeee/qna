class AnswersChannel < ActionCable::Channel::Base
  def follow
    stream_from "answers_of_question#{params[:question_id]}"
  end
end
