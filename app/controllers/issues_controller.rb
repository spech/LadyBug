class IssuesController < ApplicationController

	before_filter :find_issue, except: [:index, :new, :create]

	def index
		@issues = Issue.all
	end	

	def new
		@issue = Issue.new
	end

	def create
		@issue = Issue.new(issue_params)
		respond_to do |format|
			if @issue.save
				format.html {redirect_to @issue, :flash => { :success => "Issue succesfully created." } }
				format.json {head :no_content}
			else
				format.html {render action: 'new'}
				format.json { render json: @issue.errors, status: :unprocessable_entity }
			end

		end
	end

	def show
		@note = Note.new
		@note.issue_id = @issue.id
	end

	def edit
	end

	def update
	    respond_to do |format|
	      if @issue.update(issue_params)
	      	@issue.fire_state_event(params[:issue][:state_event]) if params[:issue][:state_event]
	        format.html { redirect_to @issue, :flash => { :success => 'Issue was successfully updated.' }}
	        format.json { head :no_content }
	      else
	        format.html { render action: 'edit' }
	        format.json { render json: @issue.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def destroy
		@issue.notes.destroy_all
		@issue.destroy

		flash[:error]= "Issue '#{@issue.title}' Deleted!"

		redirect_to issues_path 
	end

	private
	def issue_params
		params.require(:issue).permit(:title, :description)
	end

	def find_issue
		@issue = Issue.find(params[:id])
	end

end
