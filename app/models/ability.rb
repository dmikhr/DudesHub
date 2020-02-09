# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    return unless user
    user_abilities
  end

  def user_abilities
    # can :manage, Repo, user: user
    can [:index, :refresh, :monitor,
         :not_monitor, :add_to_monitored,
         :remove_from_monitored], Repo, user: user
  end
end
