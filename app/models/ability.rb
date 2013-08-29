class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #  user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    user ||=User.new
    if user.has_role? :admin
        can :manage, :all
    else
        can [:read, :update], Project, id: Project.with_role(:project_manager, user).map(&:id)
        can [:create,:read, :update, :assign], Issue, project_id: Project.with_role(:project_manager, user).map(&:id)

        can [:read], Project, id: Project.with_role(:developper).map(&:id)
        can [:create, :read, :update], Issue, project_id: Project.with_role(:developper, user).map(&:id)
        can [:read], Project, id: Project.with_role(:quality).map(&:id)
        can [:read, :close], Issue, project_id: Project.with_role(:integrator, user).map(&:id)
    end
  end
end
