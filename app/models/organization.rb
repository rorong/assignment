class Organization < ApplicationRecord
  belongs_to :admin, class_name: "User"
  has_many :organization_memberships, dependent: :destroy
  has_many :users, through: :organization_memberships

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
end
