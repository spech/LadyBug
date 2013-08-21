module VersionsHelper

	def version_label(state)
		case state
			when :planned then "badge badge-success"
			when :ongoing then "badge badge-important"
			when :delivered then "badge badge-inverse"
		end
	end

end
