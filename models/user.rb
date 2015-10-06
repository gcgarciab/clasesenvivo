require 'bcrypt'

class User
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  include BCrypt

  field :name, type:String
  field :email, type:String
  field :password_hash, type:String
  field :token, type:String, default: -> { SecureRandom.uuid }

  field :about, type:String
  field :twitter, type:String
  field :status, type:Boolean, default: false

  validates_presence_of :name, :email, :password, :token, :about
  validates_uniqueness_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  # TODO: mejorar el metodo
  def self.login(email, password)
    user = User.where(email: email, status: true).first
    if user
      if user.password == password
        user
      else
        false
      end
    else
      false
    end
  end
  
  # TODO: mejorar el metodo
  def self.generate_new_token(id)
    user = User.find(id)
    if user
      user.token = SecureRandom.uuid
      user.save
    else
      false
    end
  end

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

end
