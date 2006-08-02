# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
    include LoginEngine
    helper :user
    model :user

    before_filter :login_required
    before_filter do |c|
    	User.current_user = User.find(c.session[:user].id) unless c.session[:user].nil?
    end
end
