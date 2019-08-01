class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action -> { authorize answer }

  expose :answer, scope: -> { Answer.with_attached_files }
  expose :question, find: -> { answer&.question || Question.find(params[:question_id]) }
  expose :answers, -> { question.answers }

  def create
    answers << answer
    answer.user = current_user
    answer.save
    broadcast
  end

  def update
    answer.update(answer_params)
  end

  def destroy
    answer.destroy
  end

  def accept
    answer.accept!
  end

  private

  def answer_params
    params.require(:answer).permit(:body,
                                   files: [],
                                   links_attributes: %i[name url])
  end

  def broadcast
    AnswersChannel.broadcast_to(
      question,
      answer: GetAnswerData.call(answer: answer).data
    )
  end
end
