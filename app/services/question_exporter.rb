class QuestionExporter
  ATTRIBUTES = User::ATTRIBUTES_FOR_FORM - ['age']

  def export
    CSV.generate(headers: true) do |csv|
      csv << ['id', 'birthdate'] + ATTRIBUTES + header_ids

      User.includes(:answers, :favorites).find_each do |user|
        user.form_ids.each do |form_id|
          form = Form.find(form_id)
          csv << form_values(form, user)
        end
      end
    end
  end

  private

  def header_ids
    Question.ids.flat_map { |id| ["q#{id}", "fq#{id}"] }
  end

  def form_values(form, user)
    user_values(user) + question_values_for(user)
  end

  def user_values(user)
    [user.id, user.birthdate] + user.attributes.values_at(*ATTRIBUTES)
  end

  def question_values_for(user)
    values = []
    Question.find_each do |question|
      answer = user.answers.find_by(question: question).try(:to_csv_value) || 'null'
      favorite = user.favorites.find_by(question: question).present?
      values += [answer, favorite]
    end
    values
  end
end
