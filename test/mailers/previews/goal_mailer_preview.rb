# Preview all emails at http://localhost:3000/rails/mailers/goal_mailer
class GoalMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/goal_mailer/goal_reward_reached
  def goal_reward_reached
    GoalMailer.goal_reward_reached
  end

end
