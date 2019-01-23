class AuthenticateUser
  prepend SimpleCommand
  attr_accessor :email_id, :password
  
  def initialize(email_id, password) 
    @email_id = email_id
    @password = password
  end

  def call
    JsonWebToken.encode(user_id: user.id, email_id: user.email_id) if user
  end

  private

  def user
    user = User.find_by_email_id(email_id)
    return user if user && user.authenticate(password)
    errors.add :user_authentication, 'invalid credentials'
    nil
  end
end
