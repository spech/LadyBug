class UsersController < ApplicationController

	before_filter :find_user, except: [:index, :new, :create]
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
				format.html {redirect_to @user, flash: { success: "User succesfully created."}}
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

	def add_role
		@user.add_role params[:role], params[:project]
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
