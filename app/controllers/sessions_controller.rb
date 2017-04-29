class SessionsController < ApplicationController
    def new; end

    def login
        user = User.find_by(username: params[:username])
        if user
            session[:user_id] = user.id
            flash[:result_text] = "Welcome back,  #{user.username}"
            redirect_to root_path
        else
            flash[:result_text] = 'Could not log in' #this is kinda buggy : (
            # flash[:messages] = user.errors.messages
            render 'new', status: :bad_request
        end
    end

    def create
        auth_hash = request.env['omniauth.auth']

        user = User.find_by(oauth_uid: auth_hash[:uid], oauth_provider: params[:provider])

        if user.nil?
            user = User.from_github(auth_hash)
            if user.save
                session[:user_id] = user.id
                flash[:message] = "Successfully logged in as new user #{user.username}"
            else
                flash[:message] = 'Could not log in'
                user.errors.messages.each do |_field, problem|
                    flash[:field] = problem.join(', ')
                end
            end

        else
            session[:user_id] = user.id
            flash[:message] = "Welcome back, #{user.username}"
        end

        redirect_to root_path
    end

    def logout
        session[:user_id] = nil
        flash[:result_text] = 'Successfully logged out'
        redirect_to root_path
    end
end
