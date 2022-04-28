class CreateProductCombos < ActiveRecord::Migration
  def change
    if !ActiveRecord::Base.connection.table_exists? 'product_combos'
      create_table :product_combos do |t|
        t.string  :title
        t.string  :banner
        t.integer :no_of_pizza
        t.integer :pizza_size_id
        t.integer :no_of_toppings_on_each_pizza
        t.string  :combo_base_price
        t.string  :paid_extra_topping_price
        t.string  :description
        t.integer :no_of_free_additional_items
        t.string  :categories_of_additional_items
        t.string  :beverages_additional_items
        t.string  :dipping_sauces_aditional_items
        t.string  :salads_aditional_items
        t.string  :garlic_breads_aditional_items
        t.boolean :is_active, default: false
        t.timestamps
      end
    end
  end
end


