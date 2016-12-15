class TextCell < ActiveRecord::Base

  belongs_to :record

  validates :data, presence: true, length: { maximum: 250 }

end
