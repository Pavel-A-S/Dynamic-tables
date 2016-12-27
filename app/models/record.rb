class Record < ActiveRecord::Base

  before_save :to_utc
  belongs_to :table
  has_many :integer_cells, dependent: :delete_all
  has_many :decimal_cells, dependent: :delete_all
  has_many :text_cells, dependent: :delete_all

  def to_utc
    self.date = self.date - self.date.localtime.utc_offset
  end

end
