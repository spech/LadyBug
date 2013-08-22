class Issue < ActiveRecord::Base

	has_many :notes
	belongs_to :project

	validates :title, :description, :product_version, presence: true
	validates_uniqueness_of :title, scope: :project_id

	SEVERITY = [:critical, :evolution, :minor, :cosmetic]
	IMPACT = [:specification, :design, :code, :unit_test, :integration, :validation]

	state_machine :initial => :new do
		state :new, value: 0
		state :analysed, value: 1
		state :assigned, value: 2
		state :corrected, value: 3
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
			validates :analysis, :impact, presence: true
		end

		event :assign do
			transition :analysed => :assigned
		end

		state :assigned do 
			validates :target_version, presence: true
		end

		event :correct do
			transition :assigned => :corrected
		end

		state :corrected do
			validates :correction, presence: true
		end

		event :review do
			transition :corrected => :reviewed
		end

		state :reviewed do
			validates :review_ref, presence:true
		end

		event :validate do
			transition :reviewed => :validated
		end

		state :validated do
			validates :validation_ref, presence: true
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
	    Issue.where("id > ? and project_id = ?", self.id, self.project_id).first
	end

	def prev
    	Issue.where("id < ? and project_id = ?", self.id, self.project_id).last
	end
end
