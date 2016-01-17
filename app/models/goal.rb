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

class Goal < ActiveRecord::Base
	# goal_status: 0 = incomplete, 1 = active, 2 = completed, 3 = inactive
	
	belongs_to :user
	has_many :checkins #, dependent: :destroy

	before_create :make_permalink

	validates :user_id, presence: true

	def reward_img
		return 'reward_img/' + self.permalink + '.png'	
	end

	def goal_total_contribution
		return self.checkins.sum(:contribute_amount)
		# .sum(:contribute_amount, :conditions => {:id => [4,5]})
	end

	def goal_last_checkin
		return self.checkins.maximum('created_at')
	end

	def goal_check_and_adjust_progress
		@goal_progress = self.goal_total_contribution
		
		if @goal_progress >= self.amount_needed and self.goal_status != 2
			self.update_attribute(:goal_status, 2)
			GoalMailer.goal_reward_reached(self).deliver_now
		elsif @goal_progress < self.amount_needed and self.goal_status = 2
			self.update_attribute(:goal_status, 1)
		end

		return self.goal_status
	end

	def goal_percent_progress
		deserve_total = self.goal_total_contribution
		if deserve_total >= self.amount_needed
			return 100
		else
			return (deserve_total/self.amount_needed*100).round
		end
	end

	def checkins_needed
		amt_left = self.amount_needed - self.goal_total_contribution
		checkin_left = (amt_left/deserve_amount).ceil

		return checkin_left
	end

	def goal_ready_to_activate? 
	    if self.short_description.blank?
	      	return false
	    # elsif self.long_description.blank?
	    #   return false
	    elsif self.reminder_frequency.blank?
	      	return false
	    elsif self.deserve_amount.blank?
	      	return false
	    elsif self.reward.blank?
	      	return false
	    elsif self.amount_needed.blank?
	      	return false
	    else
	    	return true
	    end
	end

	def set_active
		@other_active_goal = Goal.where('goal_status = 1 and user_id = ?', self.user_id)
	    
	    if !@other_active_goal.empty?
	        @other_active_goal.first.update_attribute(:goal_status, 3)
	    end

	    self.update_attribute(:goal_status, 1)
	end

	def self.reminder_frequency_choices
		return ['Once every morning', 'Once every weekday morning', 'Once every evening', 'Once every weekday evening']
		# ['2x on weekdays (1pm and 6pm)', '2x on weekdays (9am and 6pm)', 'Once every day', 'Once a day on weekdays', 'On Tuesdays and Thursdays', 'On Wednesdays', 'On Fridays']
	end

	private

		def make_permalink
	      self.permalink = loop do
		  	random_token = SecureRandom.hex(8)
		  	break random_token unless Goal.where(permalink: random_token).exists?
	      end
	 	end  
end
