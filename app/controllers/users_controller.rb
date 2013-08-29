class UsersController < ApplicationController

	before_filter :authenticate_user!
	before_filter :find_user, except: [:index, :new, :create, :add_role, :remove_role]
	before_filter :define_role, only: [:index]

	def index
		@search = User.search(params[:q])
		@users = @search.result.page(params[:page])
	end

	def show
	end

	def create
		@user = User.new(user_params)
		respond_to do |format|
			if @user.save
				format.html {redirect_to users_path, flash: { success: "User succesfully created."}}
				format.json {head :no_content}
			else
				format.html {render action: 'new'}
				format.json { render json: @project.errors, status: :unprocessable_entity }
			end

		end
	end

	def edit
	end

	def new
		@user = User.new
	end

	def remove_role
		@user = User.find(params[:user_id])
		@project = Project.find(params[:project_id]) if not params[:project_id].empty?
		@user.remove_role params[:role], @project
		flash[:alert] = 'Role has been removed from user.'
		redirect_to users_path
	end

	def add_role
		@user = User.find(params[:user_id])
		@project = Project.find(params[:project_id])
		if @user.has_role? params[:role] or @user.has_role? params[:role], @project
			flash[:alert] = 'role already assigned to user.'
		else
			case params[:role]
			when :admin
				@user.add_role params[:role]
			else
				@user.add_role params[:role], @project
			end
			flash[:success] = 'role successfully added to user.'
		end

		redirect_to users_path 
	end

	private
	def find_user
		@user = User.find(params[:id])
	end

	def user_params
		params.require(:user).permit(:email, :password)
	end

	def define_role
		@role = Role.new
	end

end
