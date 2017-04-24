class UsersController < ApplicationController
  before_action :require_login, except: :index

  def index
    @users = User.all
  end

  def show; end

  def update; end

  def create; end

  def new; end

  def edit; end

  def products; end

  def orders; end
end
