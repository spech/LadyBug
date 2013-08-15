module VersionsHelper

	def version_label(state)
		case state
			when :planned then "label label-success"
			when :ongoing then "label label-important"
			when :delivered then "label label-inverse"
		end
	end

end
