class UsersController < ApplicationController
	before_filter :logged_in_only, only: [:show, :edit, :update]

	def create
		existing_user = User.find_by_email(params[:user][:email])
	  	if existing_user.present?
	  		flash[:warning] = 'We noticed that you registered before. We sent instructions to access your goals via email.'
	  		UserMailer.account_activation(existing_user).deliver_now
	  		redirect_to login_url
	  	else
	  		@user = User.new(user_params)
		    if @user.save
		      	log_in @user
		    	flash[:success] = "Glad to have you with us! Set your goal to get started."
		      	redirect_to step1_path
		    end
	  	end
	end

	def show
		@goals = current_user.goals

		if @goals.empty?
			flash[:warning] = "You haven't set a goal yet. Take the first step towards achieving a goal by setting one up."
			redirect_to step1_path
		else
			@active_goal = current_user.goals.find_by_goal_status(1)
			@inactive_goal = current_user.goals.where('goal_status in (0,3)')
			@completed_goal = current_user.goals.where('goal_status = 2')
		end
	end

  	def set_password
	  	@user = User.find_by_permalink(params[:permalink])
	  	@code = params[:activation_code]
  	end

	def set_password_attempt
	  	@user = User.find_by_permalink(params[:permalink])

	    if @user.activation_code == params[:activation_code]
	    	@user.update_attributes(user_params)
	    	@user.activation_code = SecureRandom.hex(2)
	    	@user.save
	      	flash[:success] = "Your password is set."
		    log_in @user
	      	redirect_to root_url
	    else
	    	flash[:warning] = "The link has expired. We sent you an email with a new set password link. Please give that one a try."
	      	redirect_to login_path
	    end
	end

	def edit
		@user = current_user
	end

	def update
		email_for_update = params[:user][:email].downcase
		existing_email = User.find_by_email(email_for_update)
		if !existing_email.present? 
			current_user.update_attribute(:email, email_for_update)
		end

		sms_for_update = params[:user][:sms].gsub(/\D/, '')
		existing_sms = User.find_by_sms(sms_for_update)
		if !existing_sms.present? 
			current_user.update_attribute(:sms, sms_for_update)
		end

		current_user.update_attribute(:name, params[:user][:name])

		redirect_to edit_user_path
	end

  private

	def user_params
	    params.require(:user).permit(:name, :last_name, :email, :sms, :activation_flag, :password, :password_confirmation)
	end

	def logged_in_only
		unless logged_in?
	      flash[:warning] = "Please log in to proceed."
	      redirect_to login_url
	    end
	end
end
