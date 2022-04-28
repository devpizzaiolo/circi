class Customer < ActiveRecord::Base
  
  after_create :send_to_cm
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :trackable, :validatable
  
  # virtual attributes
  attr_accessor :goto_pickup, :goto_delivery, :create_account

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  attr_accessible :active, :address_1, :address_2, :city, :first_name, :last_name, :mailing_list, :phone_number, :postal_code, :goto_delivery, :create_account, :goto_pickup, :original_customer
  
  
  
  has_many :orders
  
  has_many :addresses
  has_many :contact_phone_numbers
  
  
  # create first delivery address on creating the account
  after_create :generate_first_address_and_contact_phone_number
  
  
  
  # validations
  validates :address_1, :presence => true
  validates :city, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :phone_number, :presence => true
  validates :postal_code, :presence => true
  
  
  
  private
  
    def generate_first_address_and_contact_phone_number
      # @address = self.addresses.new(:address_1 => self.address_1, :address_2 => self.address_2, :city => self.city, :first_name => self.first_name, :last_name => self.last_name, :phone_number => self.phone_number, :postal_code => self.postal_code, :email => self.email)
#       @address.save
      
      # @contact_phone_number = self.contact_phone_numbers.new(:phone_number => self.phone_number)
      # @contact_phone_number.save
    end


    def send_to_cm
      if self.mailing_list?
      
        custom_fields = [ { :Key => 'last_name', :Value => self.last_name }, { :Key => 'address_1', :Value => self.address_1 }, { :Key => 'address_2', :Value => self.address_2 }, { :Key => 'city', :Value => self.city }, { :Key => 'postal_code', :Value => self.postal_code }, { :Key => 'source', :Value => 'customer-signup' }, { :Key => 'customer_id', :Value => self.id } ]
        @auth = {api_key: "4bcc3df4bb693659776b101a0e7b8474"}
        CreateSend::Subscriber.add(@auth, '6f84ecdb7fa9da94903e67728a8b8a95', self.email, self.first_name, custom_fields, true)
      
      end
    end
  
  
end
