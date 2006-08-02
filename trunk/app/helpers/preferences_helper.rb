module PreferencesHelper

  def num_columns
    Preference.content_columns.length + 1 
  end
  
  # This can be moved into application_helper.rb
  def loading_indicator_tag(scope,id)
    "<img src=\"/images/indicator.gif\" style=\"display: none;\" id=\"#{scope}-#{id}-loading-indicator\" alt=\"loading indicator\" class=\"loading-indicator\" />"
  end

end
