class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], user: user
    can :destroy, [Question, Answer], user: user
    can [:rate_up, :rate_down, :rate_revoke], [Question, Answer]
    cannot [:rate_up, :rate_down, :rate_revoke], [Question, Answer], user: user

    can :destroy, Attachment do |a|
        user.author_of?(a.attachable)
    end

    can :set_best, Answer do |a|
        user.author_of?(a.question) && !user.author_of?(a)
    end
  end
end
