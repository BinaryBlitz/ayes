class QuestionExporter
  ATTRIBUTES = User::ATTRIBUTES_FOR_FORM - ['age']

  def export
    CSV.generate(headers: true) do |csv|
      csv << ['id', 'birthdate'] + ATTRIBUTES + header_ids

      User.includes(:answers, :favorites).find_each do |user|
        row_for_user(user, csv)
      end
    end
  end

  private

  def row_for_user(user, csv)
    if user.form_ids.any?
      user.form_ids.each do |form_id|
        form = Form.find(form_id)
        csv << form_values(user, form)
      end
    else
      csv << form_values(user)
    end
  end

  def header_ids
    Question.ids.flat_map { |id| ["q#{id}", "fq#{id}"] }
  end

  def form_values(user, form = nil)
    user_values(user, form) + question_values_for(user)
  end

  def user_values(user, form = nil)
    attributes = form ? form.attributes : user.attributes
    [user.id, user.birthdate] + attributes.values_at(*ATTRIBUTES)
  end

  def question_values_for(user)
    values = []
    Question.find_each do |question|
      answer = user.answers.find_by(question: question).try(:to_csv_value) || 'null'
      favorite = user.favorites.find_by(question: question) ? 1 : 0
      values += [answer, favorite]
    end
    values
  end
end
