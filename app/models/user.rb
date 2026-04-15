class User < ApplicationRecord
  has_secure_password
  has_many :cloths, dependent: :destroy
  has_many :locations, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  before_save { self.email = email.downcase }
end
