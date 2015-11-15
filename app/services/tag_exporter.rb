class TagExporter
  def export
    CSV.generate(headers: true) do |csv|
      csv << ['id'] + Tag.pluck(:name)

      User.find_each do |user|
        row = [user.id]

        Tag.find_each do |tag|
          favorites = user.favorite_questions.joins(:tags).where('tags.id' => tag.id)
          row += [favorites.count]
        end

        csv << row
      end
    end
  end
end
