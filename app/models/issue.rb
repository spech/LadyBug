class Issue < ActiveRecord::Base
	validates :title, :description, presence: true

	def next
	    Issue.where("id > ?", self.id).first
	end

	def prev
    	Issue.where("id < ?", self.id).last
	end
end
