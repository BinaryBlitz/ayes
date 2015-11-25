class AnswerExporter
  ATTRIBUTES = User::ATTRIBUTES_FOR_FORM - ['age']

  def initialize
    @questions = Question.joins(:answers).order(id: :asc).published.uniq
  end

  def export
    CSV.generate(headers: true) do |csv|
      csv << ['id', 'birthdate'] + ATTRIBUTES + header_ids

      User.joins(:answers).uniq.find_each do |user|
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
    @questions.ids.flat_map { |id| ["q#{id}", "fq#{id}"] }
  end

  def form_values(user, form = nil)
    user_values(user, form) + question_values_for(user, form)
  end

  def user_values(user, form = nil)
    attributes = form ? form.attributes : user.attributes
    values = [user.id, user.birthdate] + attributes.values_at(*ATTRIBUTES)
    values.map { |value| value ? value : 'null' }
  end

  def question_values_for(user, form = nil)
    values = []
    @questions.find_each do |question|
      answer = question.answers.find_by(user: user, form: form).try(:to_csv_value) || 'null'
      favorite = question.favorites.find_by(user: user) ? 1 : 0
      values += [answer, favorite]
    end
    values
  end
end
