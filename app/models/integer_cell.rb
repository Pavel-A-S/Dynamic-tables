class IntegerCell < ActiveRecord::Base

  belongs_to :record

  validates :data, numericality: { greater_than: -1000000, less_than: 1000000 }

end
