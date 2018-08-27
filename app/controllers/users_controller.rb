class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :destroy, :edit, :update, :following, :followers]
  before_action :admin_user, only: :destroy

  # GET /users
  # GET /users.json
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  # GET /users/1
  # GET /users/1.json
  def show
    set_user
    @posts = @user.posts.paginate(:page => params[:page])
    redirect_to root_url and return unless @user.activated?
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    set_user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
#        format.html { redirect_to @user, notice: 'User was successfully created.' }
#        format.json { render :show, status: :created, location: @user }
#        log_in @user
#        remember_user @user
#        flash.now[:success] = "Welcome to the Sample App!"
        @user.send_activation_email
        format.html { redirect_to root_url, notice: 'Please check your email to activate your account.' }
        format.json { render :action => 'show', status: :created, location: @user }
        flash[:info] = "Please check your email to activate your account."
      else
        format.html { render :action => 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
        flash.now[:danger] = "Invalid email/password combination."
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
        flash[:success] = "User was successfully updated."
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
        flash.now[:danger] = "User failed to update."
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
      flash[:success] = "User deleted"
    end
  end


  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      set_user
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def remember
      self.remember_token = User.new_token
      update_attribute(:remember_digest, User.digest(remember_token))
    end

end
