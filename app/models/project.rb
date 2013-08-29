class Project < ActiveRecord::Base

	resourcify			#rolify

	after_save :create_initial_version

	has_many :issues
	has_many :versions
	validates :name, presence: true, uniqueness: true
	validates :description, presence: true

	private

	def create_initial_version
		v = Version.new
		v.number = "0.0.0" 
		v.project_id = Project.last.id
		v.save
		v.deliver
	end


end
