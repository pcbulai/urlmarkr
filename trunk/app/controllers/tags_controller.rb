class TagsController < ApplicationController

  def index
	redirect_to :controller => 'bookmarks', :action => 'index'
  end

  def return_to_main
    # If you have multiple scaffolds on the same view then you will want to change this to
    # to whatever controller/action shows all the views 
    # (ex: redirect_to :controller => 'AdminConsole', :action => 'index')
    redirect_to :controller => 'bookmarks', :action => 'index'
  end

  def create
    @tag = Tag.new(params[:tag])
    if @tag.save
      if request.xhr?                                                    
        @headers['tag-id'] = @tag.id
        @headers['Content-Type'] = 'text/html; charset=utf-8'
        render :partial => 'tag', :layout => false, :locals => { :hidden => true }
      else
        return_to_main
      end
    else
      render :partial => 'form_errors', :layout => false, :status => 500 if request.xhr?
      render :action => 'new' if not request.xhr?
    end
  end


  def update
    @tag = Tag.find(params[:id])
    if @tag.update_attributes(params[:tag])
      render :partial => 'tag', :layout => false, :locals => { :hidden => true } if request.xhr?
      return_to_main if not request.xhr?
    else
      render :partial => 'form_errors', :layout => false, :status => 500 if request.xhr?
      render :action => 'edit' if not request.xhr?
    end
  end

end
