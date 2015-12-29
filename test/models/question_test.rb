# == Schema Information
#
# Table name: questions
#
#  id           :integer          not null, primary key
#  epigraph     :string
#  content      :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  urgent       :boolean          default(FALSE)
#  published_at :datetime
#  position     :integer
#  region       :string           default("russia")
#  gender       :string           is an Array
#  occupation   :string           is an Array
#  income       :string           is an Array
#  education    :string           is an Array
#  relationship :string           is an Array
#  settlement   :string           is an Array
#  age          :integer          default([]), is an Array
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
