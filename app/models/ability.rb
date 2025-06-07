# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.member?
      can :read, Book, ['copies > 0']
    elsif user.librarian?
      can :manage, Book
    end
  end
end
