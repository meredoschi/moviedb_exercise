# frozen_string_literal: true

# Cancancan
class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
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
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    class << self
      def site_administrator(_user)
        can :manage, :all
      end
    end

    class << self
      def visitor(_user)
        can :read, Movie
        can :read, Category
      end
    end

    class << self
      def member(user)
        can :read, [Movie, Category]
        can %i[read], Rating, user_id: user.id

        can :create, [Movie, Rating]

        #        can %i[update destroy], Movie # for testing
        can %i[update destroy], Movie, user_id: user.id
      end
    end

    if user.nil?
        then visitor(user)
    elsif user.admin? then site_administrator(user)
    else member(user)
    end
  end
end
