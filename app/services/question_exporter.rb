class QuestionExporter

  def export
    CSV.generate(headers: true) do |csv|
      attributes = %w(id content region)
      csv << attributes + ['yes', 'no', 'na', 'null', 'favorites', 'tags']

      Question.includes(:tags).find_each do |question|
        null_count = User.count - question.answers.count
        null_count = null_count < 0 ? 0 : null_count
        csv << question.attributes.values_at(*attributes) + [
          question.answers.positive.count,
          question.answers.negative.count,
          question.answers.neutral.count,
          null_count,
          question.favorites.count,
          question.tags.map(&:name).join(', ')
        ]
      end
    end
  end
end
