class User < ActiveRecord::Base
  attr_accessor :password

  attr_accessible :email, :password_hash, :password_salt

  validates :email, :presence => true, :uniqueness => true
  validates :password, :presence => true, :on => :create
  
  before_save :encrypt_password

  private

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret password, password_salt
    end
  end
end
