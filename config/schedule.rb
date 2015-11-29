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

every 1.hour do
  rake 'questions:publish'
end

every 1.hour do
  rake 'questions:push'
end

every 1.day do
  runner 'Question.notify_distribution_changed'
end
