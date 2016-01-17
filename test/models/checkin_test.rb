# == Schema Information
#
# Table name: checkins
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  goal_id           :integer
#  checkin_result    :integer          default(0)
#  contribute_amount :decimal(6, 2)
#  checkin_type      :string           default("regular")
#  checkin_note      :string
#  contribution_id   :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class CheckinTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
