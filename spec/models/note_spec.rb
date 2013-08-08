require 'spec_helper'

describe Note do
  let(:note) do
  	note = Note.new(body: "yeah", issue_id: 1)
  end

  it 'should create a new valid note.' do
	expect(note).to be_valid
  end

  it 'should not create note withut body.' do
  	note.body = nil
	expect(note).not_to be_valid
  end

  it 'should not create a note without issue' do
	note.issue_id = nil
	expect(note).not_to be_valid
  end


end
