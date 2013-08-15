class Project < ActiveRecord::Base
	has_many :issues
	has_many :versions
	validates :name, presence: true, uniqueness: true
	validates :description, presence: true
end
