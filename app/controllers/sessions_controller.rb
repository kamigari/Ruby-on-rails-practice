class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    #Log the user in and redirect to the user's show page
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] ? remember_user(user) : forget(user)
        redirect_back_or user
      else
        message = "Account not activated. "
        message += "Check your email for activation link."
        flash.now[:warning] = message
        redirect_to root_url
      end
    #Create an error message
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  # Forgets a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

end
