class Issue < ActiveRecord::Base
	validates :title, :description, presence: true

	def next
	    Issue.where("id > ?", self.id).first || Issue.first
	end

	def prev
    	Issue.where("id < ?", self.id).last || Issue.last
	end
end
