class Issue < ActiveRecord::Base

	has_many :notes
	belongs_to :project

	validates :title, :description, :product_version, presence: true
	validates_uniqueness_of :title, scope: :project_id

	SEVERITY = [:critical, :evolution, :minor, :cosmetic]
	IMPACT = [:specification, :design, :code, :unit_test, :integration, :validation]

	state_machine :initial => :new do
		state :new, value: 0
		state :reopened, value: 1
		state :analysed, value: 2
		state :assigned, value: 3
		state :corrected, value: 4
		state :reviewed, value: 5
		state :validated, value: 6
		state :closed, value: 7

		state :cancelled, value: -1


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


		event :close do
			transition :validated => :closed
		end

		event :reopen do
			transition [:closed, :cancelled] => :reopened
		end

		event :cancel do
			transition all - [:corrected,:reviewed,:validated,:closed]=> :cancelled
		end


  	end

  	def self.ransackable_attributes(auth_object = nil)
    	super - ['project_id']
  	end

	def next
	    Issue.where("id > ? and project_id = ?", self.id, self.project_id).first
	end

	def prev
    	Issue.where("id < ? and project_id = ?", self.id, self.project_id).last
	end
end
