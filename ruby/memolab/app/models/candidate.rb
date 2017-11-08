class Candidate < ApplicationRecord
  has_many :notes, :dependent => :destroy

  validates :name, presence: true

  default_scope -> { order('name ASC') }
end
