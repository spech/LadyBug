require 'spec_helper'

describe Issue do

  	let(:issue) do
  		Issue.new(title: 'myTilte', description: 'myDescription')
	end


	it 'should create a new valid issue.' do
		expect(issue).to be_valid
  end

  	it 'should not create an issue without a title.' do
  		issue.title = nil
  		expect(issue).not_to be_valid
  	end

  	it 'should not create an issue without a description.' do
  		issue.description = nil
  		expect(issue).not_to be_valid
  	end


end
