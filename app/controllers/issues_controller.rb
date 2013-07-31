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

		if @issue.save
			redirect_to issue_path(@issue), notice: "Issue #{@issue.title} successfully Created."
		else
			redirect_to new_issue_path
		end
	end

	def show
	end

	def edit
	end

	def update
		@issue.update(issue_params)

		flash.notice = "Issue '#{@issue.title}' Updated!"

  		redirect_to issue_path(@issue)
	end

	def destroy
		@issue.destroy

		flash.notice = "Article '#{@issue.title}' Deleted!"

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
