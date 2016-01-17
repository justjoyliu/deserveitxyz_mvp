class GoalsController < ApplicationController

	before_action :logged_in_only # , only: [:step1]

	def show
		@goal = current_user.goals.find_by_permalink(params[:permalink])

		if @goal.nil?
			flash[:warning] = 'Choose any of your own goals to view.'
			redirect_to user_path
		end
	end

	def goal_update
		@goal = current_user.goals.find_by_permalink(params[:permalink])
		
		if @goal.nil?
			flash[:warning] = 'Choose any of your own goals to edit.'
			redirect_to user_path
		else
			if !params[:goal][:short_description].blank?
				@goal.update_attributes(short_description: params[:goal][:short_description], long_description: params[:goal][:long_description])
			end

			if !params[:goal][:reminder_frequency].blank?
				@goal.update_attributes(reminder_frequency: params[:goal][:reminder_frequency])
			end

			deserve_amt = params[:goal][:deserve_amount].gsub(/\D/, '')
			if !deserve_amt.blank?
				@goal.update_attributes(deserve_amount: deserve_amt)
			end

			if !params[:goal][:reward].blank?
				@goal.update_attributes(reward: params[:goal][:reward])
			end
			
			needed_amt = params[:goal][:amount_needed].gsub(/\D/, '')
			if !needed_amt.blank?
				@goal.update_attributes(amount_needed: needed_amt)
				@goal.goal_check_and_adjust_progress
			end
		    
		    redirect_to goal_path(@goal.permalink)
		end
	end

	def goal_activate
		@goal = current_user.goals.find_by_permalink(params[:permalink])

		if @goal.nil?
			flash[:warning] = 'Choose any of your own goals to activate.'
			redirect_to user_path
		elsif @goal.goal_ready_to_activate?
			@goal.set_active
			if current_user.sms.present?
				redirect_to user_path
			else
				flash[:warning] = 'Last step! Let us know what number to text for check-in reminders.'
				redirect_to edit_user_path
			end
		else
			redirect_to goal_path(@goal.permalink)
		end
	end

	def step1
		@user = current_user
	    @new_goal = @user.goals.build
	end

	def step1_setup 
 		if params[:short_description] == 'Custom' or params[:short_description].blank?
			short_desc = params[:other_goal]
			long_desc = params[:goal_desc]
		else
			goal_setup = params[:short_description].split(/;\s/)
			short_desc = goal_setup[0]
			long_desc = goal_setup[1]
		end

		if short_desc.blank?
			flash[:warning] = 'Set a goal to proceed.'
			redirect_to step1_path
		else
			@goal = current_user.goals.build(:short_description => short_desc, :long_description => long_desc)
			if @goal.save
				redirect_to step2_path(@goal.permalink)
			else
				flash[:warning] = 'We had trouble creating this goal. Please try again.'
				redirect_to step1_path
			end
		end
	end

	def step2
		@goal = current_user.goals.find_by_permalink(params[:permalink])

		if @goal.nil?
			flash[:warning] = 'Set a goal to proceed.'
			redirect_to step1_path
		end
	end

	def step2_setup
		@goal = current_user.goals.find_by_permalink(params[:permalink])
		amt = params[:goal][:deserve_amount].gsub(/\D/, '')

		@goal.update_attributes(:reminder_frequency => params[:goal][:reminder_frequency], :deserve_amount => amt)
		
		if params[:goal][:reminder_frequency].blank? or amt.blank?
			flash[:warning] = 'Please answer both questions.'
			redirect_to step2_path(@goal.permalink)
		else 
			redirect_to step3_path(@goal.permalink)
		end
	end

	def step3
		@goal = current_user.goals.find_by_permalink(params[:permalink])

		if @goal.nil?
			flash[:warning] = 'Set a goal to proceed.'
			redirect_to step1_path
		end
	end

	def step3_setup
		@goal = current_user.goals.find_by_permalink(params[:permalink])
		amt = params[:goal][:amount_needed].gsub(/\D/, '')

		@goal.update_attributes(:reward => params[:goal][:reward], :amount_needed => amt)
		
		if params[:goal][:reward].blank? or amt.blank?
			flash[:warning] = 'Please tell us both what the reward is and approximately how much it costs.'
			redirect_to step3_path(@goal.permalink)
		else 
			# activate new goal and deactivate other active goal
			# goal_status: 0 = incomplete, 1 = active, 2 = completed, 3 = inactive
			@other_active_goal = current_user.goals.where('goal_status= ?', 1)
			
			if !@other_active_goal.empty?
				@other_active_goal.first.update_attribute(:goal_status, 3)
			end

			@goal.update_attribute(:goal_status, 1)

			if current_user.sms.present?
				flash[:success] = 'Your goal and reward is set! Start progressing on your goal and look forward to your next check-in.'
				redirect_to root_url
			else
				flash[:warning] = 'Last step! Let us know what number to text for check-in reminders.'
				redirect_to edit_user_path
			end
		end
	end

	private
		def logged_in_only
		  unless logged_in?
	        flash[:warning] = "Please log in."
	        redirect_to login_url
	      end
		end

		def goal_params
    		params.require(:goal).permit(:short_description, :long_description, :reminder_frequency, :deserve_amount, :reward, :amount_needed)
  		end
end
