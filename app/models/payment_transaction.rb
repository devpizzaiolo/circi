class PaymentTransaction < ActiveRecord::Base
  
  belongs_to :order

  attr_accessible :transaction_id, :transaction_date, :status, :card_type, :last_four_digits,
                  :remarks, :amount, :order_id, :franchise_location_id, :postal_code, :address_1,
                  :address_2, :email, :phone_number, :city, :province, :country, :first_name, :last_name
end
