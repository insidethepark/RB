class UsersController < ApplicationController
  # skip_before_filter  :verify_authenticity_token, only: [:create, :login]

  def create
    @user = User.new(first: params["first"],
                     last: params["last"],
                     email: params["email"],
                     password: params["password"])

    @user.ensure_auth_token
    if @user.save
      render "create.json.jbuilder", status: :created

    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by!(email: params["email"])
    if @user.authenticate(params["password"])
      render json: { user: @user.as_json(only: [:email, :auth_token]) },
          status: :ok
    else
      render json: { message: "INVALID EMAIL OR PASSWORD."},
          status: :unauthorized
    end
  end

  def edit
    @user = User.find(params["id"])
    render :edit, locals: {user: @user}
  end

  def update
    right_now = DateTime.now
    @user = User.find(params["id"])
    @user.update(first: params["first"],
                last: params["last"],
                email: params["email"],
                password: params["password"])
    @user.updated_at = right_now
    render "create.json.jbuilder", status: :ok
  end

  def destroy
    @user = User.find_by(email: params["email"])
    if @user.authenticate(params["password"])
      @user.destroy
        render plain: "USER DESTROYED",
        status: :accepted
    else
      render json: { error: "UNAUTHORIZED" },
        status: :unauthorized
    end
  end
end
