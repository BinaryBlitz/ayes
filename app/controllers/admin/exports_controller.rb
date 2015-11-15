class Admin::ExportsController < Admin::AdminController
  def index
  end

  def questions
    respond_to do |format|
      format.csv { send_data(QuestionExporter.new.export, filename: 'questions.csv') }
    end
  end

  def answers
    respond_to do |format|
      format.csv { send_data(AnswerExporter.new.export, filename: 'answers.csv') }
    end
  end

  def users
  end
end
