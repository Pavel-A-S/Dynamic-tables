class DecimalCell < ActiveRecord::Base

  belongs_to :record

  validates :data, numericality: { greater_than: -1, less_than: 900000000 }

end
