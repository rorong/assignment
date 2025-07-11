class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.persisted?
      can :read, Organization

      # Age-based restrictions
      if user.minor?
        puts "DEBUG: User is minor"
        if user.needs_parental_consent?
          puts "DEBUG: User needs parental consent - restricting access"
          # Very restricted access
          cannot :create, Organization
          cannot :join, Organization
          cannot :update, Organization
          cannot :destroy, Organization
        else
          puts "DEBUG: User has parental consent - allowing join"
          # Limited access with parental consent
          can :join, Organization
          cannot :create, Organization  # Still can't create orgs
          cannot :update, Organization  # Can't update orgs
          cannot :destroy, Organization # Can't destroy orgs
        end
      else
        puts "DEBUG: User is adult"
        # Full adult access
        can :create, Organization
        can :join, Organization
        can :manage, Organization, admin: user
      end
    end
  end
end