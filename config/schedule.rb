# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

every 1.day do
  # Pop question from the queue
  runner 'PoolQuestion.pop'
end

every 1.hour do
  # Push question if preferred time is set
  runner 'PoolQuestion.push_with_preferred_time'
  runner 'Schedule.push_scheduled_questions'
end
