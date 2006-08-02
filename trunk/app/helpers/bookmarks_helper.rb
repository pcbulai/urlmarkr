module BookmarksHelper
	
  def tag_cloud(tag_cloud, category_list)
    max, min = 0, 0
    tag_cloud.each_value do |count|
      max = count if count > max
      min = count if count < min
    end

    divisor = ((max - min) / category_list.size) + 1

    tag_cloud.each do |tag, count|
      yield tag, category_list[(count - min) / divisor] 
    end
  end

  def num_columns
    Bookmark.content_columns.length + 1 
  end
  
  # This can be moved into application_helper.rb
  def loading_indicator_tag(scope,id)
    "<img src=\"/images/indicator.gif\" style=\"display: none;\" id=\"#{scope}-#{id}-loading-indicator\" alt=\"loading indicator\" class=\"loading-indicator\" />"
  end
	  def pagination_links_remote(paginator, options={})
    update = options.delete(:update)

    str = pagination_links(paginator, options)
    if str != nil
      str.gsub(/href="([^"]*)"/) do
        url = $1
        "href=\"#\" onclick=\"new Ajax.Updater('" + update + "', '" + url +
        "', {asynchronous:true, evalScripts:true}); return false;\"" 
      end
    end
  end
end
