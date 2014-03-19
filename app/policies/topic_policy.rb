class TopicPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present? && user.role?(:admin)
  end

  def update?
    user.present? && user.role?(:admin)
  end

end