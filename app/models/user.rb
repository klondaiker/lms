class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :login, presence: true, uniqueness: true
  validates :password, presence: true, if: :new_record?
end
