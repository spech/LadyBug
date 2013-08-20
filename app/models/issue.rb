class Issue < ActiveRecord::Base

	has_many :notes
	belongs_to :project

	validates :title, :description, presence: true
	validates_uniqueness_of :title, scope: :project_id

	state_machine :initial => :new do
		state :new, value: 0
		state :analysed, value: 1
		state :assigned, value: 2
		state :updated, value: 3
		state :reviewed, value: 4
		state :validated, value: 5
		state :resolved, value: 6
		state :cancelled, value: 7
		state :closed, value: 8
		state :rejected, value: 9
		state :reopened, value: 10

		event :analyse do
			transition [:new, :reopened] => :analysed
		end

		state :analysed do
			validates :analysis, presence: true
		end

		event :assign do
			transition :analysed => :assigned
		end

		event :update do
			transition :assigned => :updated
		end

		event :review do
			transition :updated => :reviewed
		end

		event :validate do
			transition :reviewed => :validated
		end

		event :resolve do
			transition :validated => :resolved
		end

		event :close do
			transition :resolved => :closed
		end

		event :reopen do
			transition [:closed, :cancelled] => :reopened
		end

		event :cancel do
			transition all => :cancelled
		end

		event :reject do
			transition :analysed => :rejected
		end
  	end

	def next
	    Issue.where("id > ?", self.id).first || Issue.first
	end

	def prev
    	Issue.where("id < ?", self.id).last || Issue.last
	end
end
