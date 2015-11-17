module MergeGroupsHelper
  def merge_groups_select
    values = MergeGroup.field.values - ['age']
    grouped_options = values.map { |value| [value, User.send(value).values] }
    grouped_options_for_select(grouped_options)
  end
end
