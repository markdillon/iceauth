class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include ActiveModel::SecurePassword
  
  has_secure_password
  
  attr_accessible :provider, :uid, :username, :name, :email, :password, :password_confirmation, :deleted_at
    
  # Defined fields
  field :username, :type => String
  field :email, :type => String
  field :name, :type => String
  field :password_digest, :type => String
  field :admin, :type => Boolean, :default => false

  # DB indexes (always use background to avoid locking)
  index :username, :unique => true, :background => true
  index :email, :unique => true, :background => true

  # Validations
  validates :name,
            :presence => true, 
            :length => { :maximum => 30 }
  validates :username,
            :presence => true,
            :length => { :maximum => 20 }, 
            :format => { :with => /^[A-Za-z\d_]+$/ },
            :uniqueness => { :case_sensitive => false }
  validates :email, 
            :presence => true,
            :format => { :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
            :uniqueness => { :case_sensitive => false }
  validates :password,
            :length       => { :within => 6..40 },
            :allow_blank => true
  
  def salt
    BCrypt::Password.new(password_digest).salt unless password_digest.blank?
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = User.where(:_id => id).first
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def toggle_admin!
    self.admin = !admin
    save :validate => false
  end
  
end
