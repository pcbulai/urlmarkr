class User < ActiveRecord::Base
  include LoginEngine::AuthenticatedUser
  # all logic has been moved into login_engine/lib/login_engine/authenticated_user.rb
  cattr_accessor :current_user
  # Used to be able to set a cookie
  attr_accessor :remember_me
end

