class User < ActiveRecord::Base
  attr_accessor :password

  attr_accessible :email, :password_hash, :password_salt, :password, :password_confirmation

  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i

  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
  validates :password, :presence => true, :on => :create
  validates_length_of :password, in: 4..16, :on => :create
  validates :password, :confirmation => true #password_confirmation attr
  
  before_save :encrypt_password

  def self.authenticate email, password
    # user = self.find_by_email email
    user = User.find_by_email email
    user if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
  end

  private

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret password, password_salt
    end
  end
end
