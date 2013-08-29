class Version < ActiveRecord::Base

	belongs_to :project

	validates :number, presence: true
	validates_uniqueness_of :number, scope: :project_id

	state_machine :initial => :planned do
		state :planned, value: 0
		state :delivered, value: 2

		event :deliver do
			transition :planned => :delivered
		end


	end
end
