class NotesController < ApplicationController

	before_filter :authenticate_user!

	def create
  		@note = Note.new(note_params)
  		@note.issue_id = params[:issue_id]
  		@note.user_id = current_user.id

 		@note.save

 		flash[:success]= "Note created!"

  		redirect_to project_issue_path(@note.issue.project, @note.issue)
	end

	def destroy
		@note = Note.find(params[:id])
		@note.destroy

		flash[:error]= "Note Deleted!"

		redirect_to project_issue_path(@note.issue.project, @note.issue)
	end


	private
	def note_params
  		params.require(:note).permit(:body)
	end
end
