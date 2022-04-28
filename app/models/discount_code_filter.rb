class DiscountCodeFilter < ActiveRecord::Base
  attr_accessible :id, :filter_type, :email, :toppings, :franchise_location_id, :discount_code_id, :active

  belongs_to :franchise_location
  belongs_to :discount_code

  before_save :remove_empty_topping

  validates :email, presence: true, if: Proc.new { |filter| filter.filter_type == "email" }
  validates :franchise_location_id, presence: true, if: Proc.new { |filter| filter.filter_type == "franchise_location" }
  validate  :toppings_filter_type?
  validate  :check_exitsting_filter

  HUMANIZED_ATTRIBUTES = {
    :franchise_location_id => "Franchise Location",
    :discount_code_id => "Discount_Code"
  }

  def toppings_filter_type?
    if self.filter_type === "toppings" && self.toppings.kind_of?(Array)
      if self.toppings.size > 1
        return true
      else
        errors.add(:filter_type, "of #{self.filter_type.try(:titleize)} must select atleast one tooping.")
        return false
      end
    else
      return true
    end
  end

  def toppings_name
    if self.toppings.blank?
      return ""
    else
      Topping.where(id: self.toppings.split(',')).pluck(:name).join(', ')
    end
  end

  def check_exitsting_filter
    if self.discount_code_id.present?
      discount_code = self.discount_code
      filter_count = discount_code.discount_code_filters.where(filter_type: self.filter_type).count

      if new_record?
        if filter_count === 0
          return true
        else
          errors.add(:filter_type, "of #{self.filter_type.try(:titleize)} can't be add more then one on discount code #{discount_code.code}")
        end
      else
        if filter_count > 1
          errors.add(:filter_type, "of #{self.filter_type.try(:titleize)} can't be add more then one on discount code #{discount_code.code}")
        else
          return true
        end
      end

    end
  end

  def remove_empty_topping
    if self.toppings.kind_of?(Array)
      if self.toppings.size == 1
        self.toppings = nil
      else
        self.toppings = self.toppings.reject(&:blank?).join(',')
      end
    end
  end

  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

end
