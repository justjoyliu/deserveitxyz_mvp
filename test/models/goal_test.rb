# == Schema Information
#
# Table name: goals
#
#  id                 :integer          not null, primary key
#  permalink          :string
#  user_id            :integer
#  goal_type          :string
#  short_description  :string
#  long_description   :text
#  reminder_frequency :string
#  deserve_amount     :decimal(6, 2)
#  reward_type        :string
#  reward             :string
#  reward_link        :string
#  amount_needed      :decimal(, )
#  goal_status        :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class GoalTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
