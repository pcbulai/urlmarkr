class BookmarksController < ApplicationController

  def index
    #
    # Set number of tags in cloud based on options
    # 
    tags_in_cloud_array = Preference.find :all, :conditions => ['created_by = ?', current_user.id]
    tags_in_cloud = tags_in_cloud_array[0]
    if tags_in_cloud == nil
    	tags_in_cloud = 0
    elsif
    	tags_in_cloud = Integer(tags_in_cloud.tags_in_cloud)
    end
    if tags_in_cloud == 0
      @tagged_items = Bookmark.tags_count(:conditions => ['created_by = ?', current_user.id])
    elsif		
      @tagged_items = Bookmark.tags_count(:limit => tags_in_cloud, :conditions => ['created_by = ?', current_user.id])
    end
  end


  def return_to_main
    # If you have multiple scaffolds on the same view then you will want to change this to
    # to whatever controller/action shows all the views 
    # (ex: redirect_to :controller => 'AdminConsole', :action => 'index')
    redirect_to :action => 'index'
  end
  
  #
  # RSS Feed
  def rss
    if @params['tags'] == nil 
    	@bookmarks = Bookmark.find :all, :order => 'created_on DESC', :conditions => ['created_by = ?', current_user.id]
    elsif @params['tags'] == "all" 
    	@bookmarks = Bookmark.find :all, :order => 'created_on DESC', :conditions => ['created_by = ?', current_user.id]
    elsif
    	@bookmarks = Bookmark.find_tagged_with(:any => @params['tags'], :conditions => ['created_by = ?', current_user.id])
    end
    render_without_layout
  end

  def list
    #
    # Set number of items per page
    #
    items_per_page_array = Preference.find :all, :conditions => ['created_by = ?', current_user.id]
    items_per_page = items_per_page_array[0]
    if items_per_page == nil
    	items_per_page = 10
    elsif
    	items_per_page = Integer(items_per_page.bookmarks_per_page)
    end
    #
    # Render all bookmarks
    #
    if @params['do_search'] == "yes"
    	@tags = "all"
 	 	  page = (params[:page] ||= 1).to_i
 	   	offset = (page - 1) * items_per_page
 	   	search_term = '%'
 	   	search_term << @params['search_term']
 	   	search_term << '%'
  	  @bookmarks = Bookmark.find :all, :conditions => ['created_by = ? AND name LIKE ?', current_user.id, search_term], :order => 'created_on DESC'
  	  @total_bookmarks = @bookmarks.length
  	  @bookmarks_pages = Paginator.new(self, @bookmarks.length, items_per_page, page)
  	  @bookmarks = @bookmarks[offset..(offset + items_per_page - 1)]
    	render :layout => false
    elsif @params['tags'] == nil 
    	@tags = "all"
 	 	  page = (params[:page] ||= 1).to_i
 	   	offset = (page - 1) * items_per_page
  	  @bookmarks = Bookmark.find :all, :conditions => ['created_by = ?', current_user.id], :order => 'created_on DESC'
  	  @total_bookmarks = @bookmarks.length
  	  @bookmarks_pages = Paginator.new(self, @bookmarks.length, items_per_page, page)
  	  @bookmarks = @bookmarks[offset..(offset + items_per_page - 1)]
    	render :layout => false
    #
    # If tags param is set, render bookmarks based on tag
    #
    elsif
    	@tags = @params['tags']
 	 	  page = (params[:page] ||= 1).to_i
 	   	offset = (page - 1) * items_per_page
  	  @bookmarks = Bookmark.find_tagged_with(:any => @params['tags'], :conditions => ['created_by = ?', current_user.id], :order => 'created_on DESC')
  	  @total_bookmarks = @bookmarks.length
  	  @total_bookmarks_tag = " tagged '"
  	  @total_bookmarks_tag << @params['tags']
  	  @total_bookmarks_tag << "'"
  	  @bookmarks_pages = Paginator.new(self, @bookmarks.length, items_per_page, page)
  	  @bookmarks = @bookmarks[offset..(offset + items_per_page - 1)]
    	render :layout => false	
    end
  end
  
  def clear
    render :layout => false
  end

  def new
    @bookmark = Bookmark.new
    @tagged_items = Bookmark.tags_count(:limit => 5)
    if request.xhr?
      @temp_id = Time.new.to_i
      @headers['bookmark-id'] = @temp_id
      @headers['Content-Type'] = 'text/html; charset=utf-8'
    
      render :layout => false
    
      # If you want to send an error message:
      # render :inline => "Error text goes here", :layout => false, :status => 500
		elsif
    render :layout => 'new'
    end
  end
  
  def import
    render :layout => 'new'
  end
  
  def search
    render :layout => 'new'
  end
  
  def import_delicious
  	user = params[:delicious_username]
  	pass = params[:delicious_password]
		agent = 'url.markr v20060428'
		@delicious_recent_num = params[:delicious_recent_num]
		if @params["delicious_recent_yn"] == "yes"
				@xml = Net::HTTP.start('del.icio.us') { |http|
    		req = Net::HTTP::Get.new("/api/posts/recent?count=#{@delicious_recent_num}", {'User-Agent' => agent})
    		req.basic_auth(user, pass)
    		http.request(req).body
			}
		elsif
			@xml = Net::HTTP.start('del.icio.us') { |http|
    		req = Net::HTTP::Get.new('/api/posts/recent?count=5', {'User-Agent' => agent})
		    req.basic_auth(user, pass)
    		http.request(req).body
			}
		end
		REXML::Document.new(@xml).elements.each('posts/post') { |el|
		@b = Bookmark.new
		@b.url = el.attributes['href']
		@b.name = el.attributes['description']
		@b.description = ""
		@b.created_on = el.attributes['time']
		tags = el.attributes['tag']
		@b.tag(tags)
		@b.save
		}
		render :layout => false
  end
  
  def auto_complete_for_bookmark_tags
    search = params[:tags]
    searchName = search.split(' ').last.strip
    if search == searchName
  	@searchFirst == ""
    elsif search.split.size <= 2
  	@searchFirst = search.split(' ').first.strip
  	@searchFirst << " "
    elsif
  	ssize = ( search.length - searchName.length )
  	@searchFirst = search.first(ssize)
    end
    @tags = Tag.find(:all, :conditions => "name LIKE '#{searchName}%'") unless search.blank?
    render :partial => "livetags" 
  end

  def create
    @bookmark = Bookmark.new(params[:bookmark])
    if @bookmark.save
      @bookmark.tag(params[:tags])
      if request.xhr?                                                    
        @headers['bookmark-id'] = @bookmark.id
        @headers['Content-Type'] = 'text/html; charset=utf-8'
        render :partial => 'bookmark', :layout => false, :locals => { :hidden => true }
      else
        return_to_main
      end
    else
      render :partial => 'form_errors', :layout => false, :status => 500 if request.xhr?
      render :action => 'new' if not request.xhr?
    end
  end

  def edit
    if request.xhr?
    	id = params[:id]
    	@bookmark = Bookmark.find(id, :conditions => "created_by = '#{current_user.id}'")
    	render :layout => false if request.xhr?
    elsif
	    redirect_to :controller => 'bookmarks', :action => 'index'
		end
  end

  def update
    if request.xhr?
    	id = params[:id]
    	@bookmark = Bookmark.find(id, :conditions => "created_by = '#{current_user.id}'")
	    @bookmark.tag_names=(params[:tags])
  	  if @bookmark.update_attributes(params[:bookmark])
    	  render :partial => 'bookmark', :layout => false, :locals => { :hidden => true } if request.xhr?
      	return_to_main if not request.xhr?
	    else
  	    render :partial => 'form_errors', :layout => false, :status => 500 if request.xhr?
    	  render :action => 'edit' if not request.xhr?
	    end
	  elsif
	  	redirect_to :controller => 'bookmarks', :action => 'index'
		end
  end

  def destroy
    if request.xhr?
    	id = params[:id]
    	Bookmark.find(id, :conditions => "created_by = '#{current_user.id}'").destroy
	    render :nothing => true if request.xhr?
  	  return_to_main if not request.xhr?
  	elsif
	  	redirect_to :controller => 'bookmarks', :action => 'index'
		end
  end
end
