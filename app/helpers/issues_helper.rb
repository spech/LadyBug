module IssuesHelper

	def state_label(state)
		case state
			when :new then "label label-important"
			when :analysed then "label label-info"
			when :assigned then "label label-warning"
			when :corrected then "label label-warning"
			when :reviewed then "label label-warning"
			when :validated then "label label-info"
			when :resolved then "label label-success"
			when :cancelled then "label"
			when :closed then "label label-inverse"
			when :rejected then "label"
			when :reopened then "label label-important" 
		end
	end

	def progress(state)
		case state
			when :new then "10%"
			when :analysed then "30%"
			when :assigned then "50%"
			when :corrected then "60%"
			when :reviewed then "70%"
			when :validated then "80%"
			when :resolved then "90%"
			when :cancelled then "0%"
			when :closed then "100%"
			when :rejected then "0%"
			when :reopened then "10%" 
		end
	end

	def delivered_version(project)
		project.versions.select do |version|
			if version.delivered?
				version.number
			end
		end
	end

	def planned_ongoing_version(project)
		project.versions.select do |version|
			version.number if version.planned? or version.ongoing?
		end
	end

	def version_badge(state)
		case state
			when :planned then "badge badge-success"
			when :ongoing then "badge badge-important"
			when :delivered then "badge badge-inverse"
		end
	end

end
