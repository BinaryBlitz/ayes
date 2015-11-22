class QuestionExporter

  def export
    CSV.generate(headers: true) do |csv|
      attributes = %w(id content region)
      csv << attributes + ['yes', 'no', 'na', 'favorites', 'tags']

      Question.includes(:tags).find_each do |question|
        csv << question.attributes.values_at(*attributes) + [
          question.answers.positive.count,
          question.answers.negative.count,
          question.answers.neutral.count,
          question.favorites.count,
          question.tags.map(&:name).join(', ')
        ]
      end
    end
  end
end
