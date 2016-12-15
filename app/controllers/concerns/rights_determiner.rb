module RightsDeterminer
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
  end

  def must_be_administrator
    if !current_user.administrator?
      flash.now[:alert] = t(:not_allowed)
      render template: 'errors/403'
    end
  end

  def accessible?(table_id)
    if Access.find_by(table_id: table_id, user_id: current_user.id)
      return true
    else
      flash.now[:alert] = t(:not_allowed)
      render template: 'errors/403'
      return false
    end
  end
end
