class Version < ActiveRecord::Base

	belongs_to :project

	validates :number, presence: true
	validates_uniqueness_of :number, scope: :project_id

	state_machine :initial => :planned do
		state :planned, value: 0
		state :ongoing, value: 1
		state :delivered, value: 2

		event :go do
			transition :planned => :ongoing
		end

		event :postpone do
			transition :ongoing => :planned
		end

		event :deliver do
			transition :ongoing => :delivered
		end

	end
end
