# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.member?
      can :read, Book, ['copies > 0']
      can :create, Borrow
      can :read, Borrow, user_id: user.id
    end

    if user.librarian?
      can :manage, Book
    end

    false
  end
end
