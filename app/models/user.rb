class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :timeoutable,
         :recoverable, :rememberable, :validatable, :confirmable

   has_many :notes


   ROLES = [:admin, :project_manager, :integrator, :developper, :quality]

end
