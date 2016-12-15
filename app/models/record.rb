class Record < ActiveRecord::Base

  belongs_to :table
  has_many :integer_cells, dependent: :delete_all
  has_many :decimal_cells, dependent: :delete_all
  has_many :text_cells, dependent: :delete_all

end
