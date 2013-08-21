module IssuesHelper

	def state_label(state)
		case state
			when :new then "label label-important"
			when :analysed then "label label-info"
			when :assigned then "label label-warning"
			when :updated then "label label-warning"
			when :reviewed then "label label-warning"
			when :validated then "label label-info"
			when :resolved then "label label-success"
			when :cancelled then "label"
			when :closed then "label label-inverse"
			when :rejected then "label"
			when :reopened then "label label-important" 
		end
	end

	def delivered_version(project)
		project.versions.select do |version|
			version.number if version.delivered?
		end
	end

	def planned_ongoing_version(project)
		project.versions.select do |version|
			version.number if version.planned? or version.ongoing?
		end
	end

end
