class Bookmark < ActiveRecord::Base
	validates_format_of :url, :with => /^http(s?)\:\/\//, :message => "needs to begin with 'http'."
	validates_presence_of :name 
	acts_as_taggable
	belongs_to :created_by, :class_name => "User", :foreign_key => "created_by"
	belongs_to :updated_by, :class_name => "User", :foreign_key => "updated_by"
end
