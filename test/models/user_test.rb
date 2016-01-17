# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  last_name       :string
#  email           :string
#  sms             :string
#  permalink       :string
#  activation_flag :boolean          default(FALSE)
#  activation_code :string
#  password_digest :string
#  admin           :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  remember_token  :string
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
