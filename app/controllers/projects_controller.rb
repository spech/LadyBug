class ProjectsController < ApplicationController

	before_filter :find_project, except: [:index, :new, :create]
	before_filter :define_version, only: [:show, :update, :edit]
	before_filter :authenticate_user!

	def index
		@projects = Project.all
	end

	def new
		@project = Project.new
	end

	def create
		@project = Project.new(project_params)
		respond_to do |format|
			if @project.save
				format.html {redirect_to @project, flash: { success: "Project succesfully created."}}
				format.json {head :no_content}
			else
				format.html {render action: 'new'}
				format.json { render json: @project.errors, status: :unprocessable_entity }
			end

		end
	end

	def show
		@search = @project.issues.search(params[:q])
		@project_issues = @project.issues.page(params[:page]).per(25)
		@search.build_condition if @search.conditions.empty?
  		@search.build_sort if @search.sorts.empty?
	end

	def edit
	end

	def update
		respond_to do |format|
		    if @project.update(project_params)
		    	format.html { redirect_to @project, notice: 'project was successfully updated.' }
		        format.json { head :no_content }
		    else
		        format.html { render action: 'edit' }
		        format.json { render json: @project.errors, status: :unprocessable_entity }
		    end
	    end
	end

	def destroy
		@project.versions.destroy_all
		@project.destroy

		flash[:error] = "Project #{@project.name} Deleted!"

		redirect_to projects_path 
	end

	private	
	def project_params
		params.require(:project).permit(:name, :description)
	end

	def find_project
		@project = Project.find(params[:id])
	end

	def define_version
		@version = Version.new
		@version.project_id = @project.id
	end
end
