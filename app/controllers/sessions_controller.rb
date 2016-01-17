class SessionsController < ApplicationController
  def new
  end
  
  def create
	  user = User.find_by(email: params[:session][:email].downcase)
    if user 
      if user.password_digest.nil?
        UserMailer.account_activation(user).deliver_now
        flash[:warning] = "Seems like you have not set your password yet. We sent you an email with the link to do so. Afterwards, you can log into your account."
        render 'new'
      elsif user.authenticate(params[:session][:password])
        log_in user
        if user.goals.find_by_goal_status(1).present?
          redirect_to checkin_new_path
        else
          redirect_to user_path
        end
      else
      	UserMailer.account_activation(user).deliver_now
        flash[:warning] = 'The password did not match what we have on file. We sent you an email with the link to set a new password. In the meantime, if you remember your password, feel free to try again.'
        render 'new'
      end
    else
      flash[:warning] = 'We could not find an account with your email. Want to create a new account?'
      redirect_to root_url
    end
  end

  def destroy
  	log_out
    redirect_to root_url
  end
end
