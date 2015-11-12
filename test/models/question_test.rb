# == Schema Information
#
# Table name: questions
#
#  id           :integer          not null, primary key
#  epigraph     :string
#  content      :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  urgent       :boolean
#  published_at :datetime
#  position     :integer
#

require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
