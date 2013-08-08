class Note < ActiveRecord::Base
	validates :body, :issue_id, presence: true
 	belongs_to :issue
end
