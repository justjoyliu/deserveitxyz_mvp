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

class Checkin < ActiveRecord::Base
	# checkin_result 0 = 'no (not logged)', 1 = 'yes', 2 = 'no'
	# checkin_type: regular, manual

	belongs_to :goal
	belongs_to :user

	validates :user_id, presence: true
	validates :goal_id, presence: true

	def self.send_checkin_sms
	    twilio_client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
	    
	    need_to_send_users = User.where('sms is not null')

	    need_to_send_users.each do |user|
	    	goal = user.active_goal
	      	checkin_message = "Did you " + goal.short_description.downcase + " today? Check-in with DeserveIt.XYZ on your progress for a " + goal.reward + ": " + ENV['HOST_URL_STRING'] + "checkin"
	      	twilio_client.messages.create(
	            to: user.sms,
	            from: ENV['TWILIO_PHONE_NUMBER'],
	            body: "#{checkin_message}"
	          )
	    end
	end
end
