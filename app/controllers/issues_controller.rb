class IssuesController < ApplicationController

	before_filter :find_issue, except: [:index, :new, :create, :search]
	before_filter :define_note, only: [:show, :update]
	before_filter :define_project
	before_filter :authenticate_user!
	
	def index
		@issues = @project.issues
	end	

	def new
		@issue = Issue.new
	end

	def create
		@issue = Issue.new(issue_params)
		@issue.project_id = @project.id
		respond_to do |format|
			if @issue.save
				format.html {redirect_to project_issue_path(@issue.project, @issue), :flash => { :success => "Issue succesfully created." } }
				format.json {head :no_content}
			else
				format.html { render action: 'new'}
				format.json { render json: @issue.errors, status: :unprocessable_entity }
			end
		end
	end

	def show
		@productversion = Version.find(@issue.product_version)
		@targetversion = Version.find(@issue.target_version) if @issue.target_version
	end

	def search
		@search = @project.issues.search(params[:q])
		@project_issues = @search.result.page(params[:page]).per(25)
		@search.build_condition if @search.conditions.empty?
  		@search.build_sort if @search.sorts.empty?
		render 'projects/show'
	end

	def edit
	end

	def update
		case params[:commit]
		when "change issue state" then
			if @issue.fire_state_event(params[:issue][:state_event]) 
			  	respond_update_success
			else
			  	respond_update_error 'show'
			end
	    else
	    	if @issue.update(issue_params)
	      		@issue.fire_state_event(params[:issue][:state_event]) if params[:issue][:state_event]
		    	respond_update_success 
		  	else
		    	respond_update_error 'edit'
		  	end
		end
	end

	def destroy
		if @issue.state >= 4 #:corrected
			flash[:error]= "cannot deleted Issue '#{@issue.title}' because it is already corrected!"
			redirect_to project_issue_path(@project, @issue)
		else
			@issue.notes.destroy_all
			@issue.destroy

			flash[:error]= "Issue '#{@issue.title}' Deleted!"

			redirect_to project_issues_path(@project) 
		end
	end

	private
	def issue_params
		params.require(:issue).permit(:title, :description, 
			:analysis, :product_version, :target_version,
			:severity, :impact, :correction,
			:review_ref, :validation_ref)
	end

	def find_issue
		@issue = Issue.find(params[:id])
	end

	def define_note
		@note = Note.new
		@note.issue_id = @issue.id
	end

	def define_project
		@project = Project.find(params[:project_id])
	end

	def respond_update_success
	  respond_to do |format|
	    format.html { redirect_to project_issue_path(@project, @issue), :flash => { :success => 'Issue state was successfully updated.' }}
	    format.json { head :no_content }
	  end 
	end

	def respond_update_error path
	  respond_to do |format|
	  	format.html { render action: path }
	    format.json { render json: @issue.errors, status: :unprocessable_entity }
	  end
	end

end
