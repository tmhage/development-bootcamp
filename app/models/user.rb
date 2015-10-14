class User < ActiveRecord::Base
  include Gravtastic
  gravtastic
  has_one :user_profile

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :first_name, :last_name, if: :persisted?
  accepts_nested_attributes_for :user_profile

  def full_name
    _full_name = [ first_name, last_name ].join(" ")
    return email unless _full_name.present?
    _full_name
  end
end
