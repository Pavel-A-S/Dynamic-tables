class Table < ActiveRecord::Base

  has_many :coordinates, dependent: :delete_all
  has_many :cells, dependent: :delete_all
  has_many :records, dependent: :destroy
  has_many :accesses

  validates :name, presence: true, length: { maximum: 250 }

end
