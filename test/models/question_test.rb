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
  setup do
    @question = questions(:question)
  end

  test 'valid' do
    assert @question.valid?
  end

  test 'content and epigraph are less than 200 chars' do
    @question.content = 'a' * 200
    @question.epigraph = 'a' * 200
    assert @question.invalid?
  end
end
