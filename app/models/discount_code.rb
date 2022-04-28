class DiscountCode < ActiveRecord::Base
  attr_accessible :promotion_name, :code, :value, :discount_type, :used_order_id, :active, :one_time_use, :expired_at, :one_time_used_at, :exclude_deals
  attr_accessible :discount_code_filters, :discount_code_filters_attributes
  
  before_save :generate_code

  has_many :discount_code_filters
  has_many :orders
  
  accepts_nested_attributes_for :discount_code_filters, :allow_destroy => true, :reject_if => :all_blank

  validates :discount_type, presence: true
  validates :value, presence: true

  def filters
    if self.discount_code_filters.count > 0
      filter_names = ""
      self.discount_code_filters.each do |filter|
        if filter.filter_type === "email"
          filter_names = filter_names + " Email: #{filter.email} <br/>" 
        elsif filter.filter_type === "franchise_location"
          filter_names = filter_names + " Franchise Location: #{filter.try(:franchise_location).try(:address)} <br/>"
        elsif filter.filter_type === "toppings"
          filter_names = filter_names + " Toppings: #{toppings_name(filter.toppings)} <br/>" 
        end
      end
      filter_names
    else
      ""
    end
  end

  def toppings_name(topping_ids)
    if topping_ids.blank?
      return "N/A"
    else
      Topping.where(id: topping_ids.split(',')).pluck(:name).join(', ')
    end
  end

  def generate_code
    if self.code.blank?
      source = Array('A'..'Z') #+ Array(0..9)
      self.code = Array.new(10) { source.sample }.join
    end
  end

end
