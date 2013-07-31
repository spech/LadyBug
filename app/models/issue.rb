class Issue < ActiveRecord::Base
	validates :title, :description, presence: true
end
