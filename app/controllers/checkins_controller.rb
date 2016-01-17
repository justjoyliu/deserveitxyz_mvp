class CheckinsController < ApplicationController
	before_action :logged_in_only
  	
  	def new
  		@active_goal = current_user.goals.find_by_goal_status(1)
  		
  		if @active_goal.nil?
  			flash[:warning] = 'Set a goal to make progress towards a reward.'
			redirect_to step1_path
  		else
  			# @goal_question = @active_goal.short_description.split(' ', 2)
    		@goal_question = @active_goal.short_description

    		# ['2x on weekdays (1pm and 6pm)', '2x on weekdays (9am and 6pm)', 'Once every day', 'Once a day on weekdays', 'On Tuesdays and Thursdays', 'On Wednesdays', 'On Fridays']
    		if @active_goal.reminder_frequency.include? 'On '
    			@time_reminder = ''
    		elsif @active_goal.reminder_frequency.include? 'Once'
    			@time_reminder = ' today'
    		else
    			@time_reminder = Time.now.localtime.hour < 14 ? ' this morning' : ' this afternoon'
    		end

  			@new_checkin = @active_goal.checkins.build
  		end
  	end

  	def manual_checkin
  		@active_goal = current_user.goals.find_by_goal_status(1)
  		
  		if @active_goal.nil?
 			goal_count = current_user.goals.where('goal_status in (0,3)').count
 			if goal_count > 0
  				flash[:warning] = 'You must have an active goal in order to record big progress.'
  				redirect_to user_path
  			else
				flash[:warning] = 'Set a goal in order to record progress.'
				redirect_to step1_path
			end
  		else
  			@new_checkin = @active_goal.checkins.build
  		end
  	end

	def record_checkin 
 		@active_goal = current_user.goals.find_by_goal_status(1)

 		if @active_goal.nil?
  			flash[:warning] = 'Set a goal to make progress towards a reward.'
			redirect_to step1_path
  		elsif params[:result] == "manual"
  			add_amt = params[:checkin][:contribute_amount].gsub(/\D/, '')
			if !add_amt.blank?
				@new_checkin = @active_goal.checkins.build(
	  				:checkin_type => 'manual',
	  				:checkin_note => params[:checkin][:checkin_note],
	  				:checkin_result => 1, 
	  				:user_id => current_user.id, 
	  				:contribute_amount => add_amt
	  				)	

				if @new_checkin.save
					redirect_to checkin_yes_path(@active_goal.permalink)
				else
					flash[:warning] = 'We had trouble recording this checkin. Please try again.'
					redirect_to manual_checkin_path
				end
			else
				flash[:warning] = 'You must pick a $ amount to record checkin.'
				redirect_to manual_checkin_path
			end
  		else
  			if params[:result] == '1' #yes
  				@new_checkin = @active_goal.checkins.build(:checkin_result => 1, :user_id => current_user.id, :contribute_amount => @active_goal.deserve_amount)	
  			else
  				@new_checkin = @active_goal.checkins.build(:checkin_result => 2, :user_id => current_user.id, :contribute_amount => 0)
  			end

  			if @new_checkin.save
				if @new_checkin.checkin_result == 2
					redirect_to checkin_no_path(@active_goal.permalink)
				else
					redirect_to checkin_yes_path(@active_goal.permalink)
				end			
			else
				flash[:warning] = 'We had trouble recording this checkin. Please try again.'
				redirect_to checkin_new_path
			end
		end
	end

	def checkin_yes
		@goal = current_user.goals.find_by_permalink(params[:permalink])
		@checkin = @goal.checkins.last
		@goal_progress = @goal.goal_total_contribution
		@percent_progress = @goal.goal_percent_progress
		
		if @goal_progress >= @goal.amount_needed
			@goal.goal_check_and_adjust_progress
		end
	end

	def checkin_no
		@goal = current_user.goals.find_by_permalink(params[:permalink])
	end

	private
		def logged_in_only
		  unless logged_in?
	        flash[:warning] = "Please log in to proceed."
	        redirect_to login_url
	      end
		end

		def checkin_params
    		params.require(:checkin).permit(:checkin_result)
  		end
end
