class PreferencesController < ApplicationController

  def index
	redirect_to :controller => 'bookmarks', :action => 'index'
  end

  def list
    if request.xhr?
    	@preferences = Preference.find :all, :conditions => "created_by = '#{current_user.id}'"
    	render :layout => false
    elsif
			redirect_to :controller => 'bookmarks', :action => 'index'
		end
  end

  def edit
  	if request.xhr?
  		id = params[:id]
    	@preference = Preference.find(id, :conditions => "created_by = '#{current_user.id}'")
    	render :layout => false
    elsif
			redirect_to :controller => 'bookmarks', :action => 'index'
		end
  end

  def update
  	if request.xhr?
    	id = params[:id]
    	@preference = Preference.find(id, :conditions => "created_by = '#{current_user.id}'")
    	if @preference.update_attributes(params[:preference])
      	render :partial => 'preference', :layout => false, :locals => { :hidden => true }
    	else
      	render :partial => 'form_errors', :layout => false, :status => 500
    	end
		elsif
			redirect_to :controller => 'bookmarks', :action => 'index'
		end
  end

end
