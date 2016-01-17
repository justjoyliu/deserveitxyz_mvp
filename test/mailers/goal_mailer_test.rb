require 'test_helper'

class GoalMailerTest < ActionMailer::TestCase
  test "goal_reward_reached" do
    mail = GoalMailer.goal_reward_reached
    assert_equal "Goal reward reached", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
