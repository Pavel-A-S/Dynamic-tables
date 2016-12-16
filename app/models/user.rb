class User < ActiveRecord::Base

  has_many :accesses, dependent: :delete_all
  has_many :tables, through: :accesses

  enum role: [:foreman, :cfo, :administrator]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
         :validatable # :registerable
end
