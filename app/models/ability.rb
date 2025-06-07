# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.member?
      can :read, Book, ['copies > 0'] # Members can read books that have copies available
    elsif user.librarian?
      can :manage, Book
    end
  end
end
