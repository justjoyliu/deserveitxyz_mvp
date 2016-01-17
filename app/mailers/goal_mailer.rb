class GoalMailer < ApplicationMailer

  def goal_reward_reached(goal)
    @goal = goal
    @user = User.find(@goal.user_id)
    
    mail to: @user.email, subject: "Congrats! You deserved your reward"
  end
end
