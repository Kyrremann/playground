class Note < ApplicationRecord
  belongs_to :user
  belongs_to :candidate

  default_scope -> { order('updated_at ASC') }
end
