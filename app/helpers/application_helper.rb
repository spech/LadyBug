module ApplicationHelper

	def flash_class(level)
	    case level
	        when :notice then "alert alert-info"
	        when :success then "alert alert-success"
	        when :error then "alert alert-error"
	        when :alert then "alert alert-error"
	    end
	end

	def link_to_add_fields(name, f, type)
	  new_object = f.object.send "build_#{type}"
	  id = "new_#{type}"
	  fields = f.send("#{type}_fields", new_object, child_index: id) do |builder|
	    render('projects/' + type.to_s + "_fields", f: builder)
	  end
	  link_to(name, '#', class: "add_fields btn", data: {id: id, fields: fields.gsub("\n", "")})
	end

	
end
