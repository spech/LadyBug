class VersionsController < ApplicationController

	def create
  		@version = Version.new(version_params)
  		@version.project_id = params[:project_id]

 		if @version.save
			redirect_to edit_project_path(@version.project_id)
			flash[:success] = "Version Created"
		else
			@project = Project.find(params[:project_id])
			render 'projects/edit'
		end
	end

	def update
		@version = Version.find(params[:id])
		case params[:commit] 
		when "change version state" then
			if params[:version][:state_event] == 'deliver'
				@issues_not_closed = all_issue_not_closed
				if @issues_not_closed.empty? and @version.fire_state_event(params[:version][:state_event])
						redirect_to edit_project_path(@version.project), flash: {success: 'Version state updated.'}
				else
					@project = Project.find(params[:project_id])
					flash[:error] = "#{@issues_not_closed.count} issue(s) assigned to version #{@version.number} are not closed"
					render 'projects/edit'
				end
			else
				if @version.fire_state_event(params[:version][:state_event])
					redirect_to edit_project_path(@version.project), flash: {success: 'Version state updated.'}
				end
			end
		else
			@project = Project.find(params[:project_id])
			render 'projects/edit'
		end
	end


	def destroy
		@version = Version.find(params[:id])
		if @version.delivered?
			flash[:error]= "cannot delete delivered versions!"
			@project = Project.find(params[:project_id])
			render 'projects/edit'
		elsif assigned_issues?
			flash[:error]= "cannot delete versions with assigned issues!"
			@project = Project.find(params[:project_id])
			render 'projects/edit'
		else
			@version.destroy

			flash[:error]= "Version Deleted!"

			redirect_to project_path(@version.project)
		end
	end

	private

	def version_params
		params.require(:version).permit(:number)
	end

	def all_issue_not_closed
		issues = Issue.where("project_id = ? and target_version = ?", @version.project_id, @version.id)
		a = issues.map do |issue|
			if not issue.closed?
				issue
			end
		end
	end

	def assigned_issues?
		not Issue.where("project_id = ? and target_version = ?", @version.project_id, @version.id).empty?
	end

end
