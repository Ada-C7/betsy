class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def account
    # TODO: Update to session user once sessions are created
    @user = User.first
  end
end
