module ApplicationHelper
  def label_for_region(region)
    if region == 'world'
      'Мир'
    else
      'Россия'
    end
  end
end
