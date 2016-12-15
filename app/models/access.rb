class Access < ActiveRecord::Base
  belongs_to :table
  belongs_to :user

  validates :table_id, presence: true
  validates :user_id, presence: true
  validate :unique

  def unique
    if !Access.where(table_id: self.table_id, user_id: self.user_id)
              .where.not(id: self.id).blank?
      self.errors.add(:base, I18n.t(:access_not_unique))
    end
  end

end
