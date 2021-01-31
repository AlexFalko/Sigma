class ChecklistPolicy < ApplicationPolicy

  
  def index?
    return true if @user.present?
  end

  def create?
    user.present?
  end

  def update?
    # return true if user.present? && user == article.user
  end

  def destroy?
    # return true if user.present? && user == article.user
  end

  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end
   
end