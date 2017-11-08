class User < ApplicationRecord
  has_many :notes, :dependent => :destroy

  default_scope -> { order('name ASC') }
end
