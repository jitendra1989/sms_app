module ApplicationHelper
	def tooltip(content, options = {}, html_options = {}, *parameters_for_method_reference)
	html_options[:title] = options[:tooltip]
	html_options[:class] = html_options[:class] || 'tooltip'
	content_tag("span", content, html_options)
	end
  
  def date_format(mg_school_id)
    @date_format=MgSchool.find_by(:id=>mg_school_id).date_format
    return @date_format
  end
	
end
