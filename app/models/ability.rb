class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
       if user.admin?
         can :manage, :all
       else
         can :read, :all
         can :filter, :all
         can :create, :all
         can :upvote, :all
         can :downvote, :all
         can :update, Post,  :author => user.email
         can :destroy, Post,  :author => user.email
         can :destroy, Comment,  :author => user.email
         can [:destroy, :approve, :reject], Comment do |c|
           Post.find(c.post_id).author == user.email
         end
         can :create, Comment, :comment_type => 'visible'
         can :create, Comment, :comment_type => 'moderated'
       end
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
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
