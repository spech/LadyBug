class VersionsController < ApplicationController


	def create
  		@version = Version.new(version_params)
  		@version.project_id = params[:project_id]

 		if @version.save
			redirect_to project_path(@version.project_id)
			flash[:success] = "Version Created"
		else
			render @version.project
		end
	end

	def update
		@version = Version.find(params[:id])
		if (params[:version][:state_event])
			if @version.fire_state_event(params[:version][:state_event])
				redirect_to @version.project, flash: {success: 'Version state updated.'}
			else
				render action: 'projects/show', id: version.project
			end
		end
	end


	def destroy
		@version = Version.find(params[:id])
		@version.destroy

		flash[:error]= "Version Deleted!"

		redirect_to project_path(@version.project)
	end

	private

	def version_params
		params.require(:version).permit(:number)
	end

end
