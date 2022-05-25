class Api::UserController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_user, only: [:show, :update, :destroy]


  def index
    users = User.paginate(page: params[:page], per_page: 3)
    render json: { status: 200, users: users }
  end

  def create
    User.create(user_params)
    render json: { status: 200, message: "User created sucessfully" } 
  end

  def show
    render json: {status: 200, user: @user}
  end

  def update
    @user.update(user_params)
    render json: {status: 200, message: "User updated sucessfully"}
  end

  def destroy
    @user.destroy
    render json: {status: 200, message: "User deleted sucessfully" }
  end

  def typeahead
    @users = User.where(
            "lower(firstName) LIKE ? OR lower(lastName) LIKE ? OR lower(email) LIKE ?",
            "%#{params[:input]}%", "%#{params[:input]}%", "%#{params[:input]}%"
            )
            #@users = User.where('lower(firstname) LIKE :input OR lower(lastname) LIKE :input OR lower(email) LIKE :input', input: "%#{params[:input]}%")
    render json: {status: 200, users: @users}
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:firstName, :lastName, :email)
  end

end
