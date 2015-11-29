namespace :questions do
  task push: :environment do
    from = Time.zone.now.beginning_of_hour
    to = Time.zone.now.end_of_hour

    # Publish scheduled questions
    questions = Question.where(published_at: from..to).where(urgent: false)
    User.notify_all if questions.any?

    # Push to users with preferred time
    hour = Time.zone.now.hour
    User.where(preferred_time: hour).notify_all #if Question.unpublished.any?
  end

  # Publish one question each day
  # FIXME: Publish instead of deleting
  task publish: :environment do
    next unless Configurable.publish_time == Time.zone.now.hour
    question = Question.unpublished.order(position: :asc).first
    question.publish(urgent: false) if question
  end
end
