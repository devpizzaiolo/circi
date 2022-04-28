class ProductCombo < ActiveRecord::Base
  attr_accessible :title, :banner, :no_of_pizza, :pizza_size_id, :no_of_toppings_on_each_pizza, :combo_base_price, :paid_extra_topping_price, :description, :no_of_free_additional_items, :categories_of_additional_items, :beverages_additional_items, :dipping_sauces_aditional_items, :salads_aditional_items, 
                  :garlic_breads_aditional_items, :is_active, :slug, :first_pizza_base_price, :second_pizza_base_price, :third_pizza_base_price, :first_pizza_freeze_toopings, :second_pizza_freeze_toopings, :third_pizza_freeze_toopings

  before_save :check_and_set_slug


  private 
  def check_and_set_slug
    if self.slug.blank?
      self.slug = self.title.parameterize
    end
  end
end
