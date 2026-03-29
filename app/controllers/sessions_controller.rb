class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
  end

  def create
    user = login(params[:login], params[:password])
    if user
      redirect_to root_url
    else
      flash.now[:alert] = "Неверный логин или пароль"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to new_session_url
  end
end
