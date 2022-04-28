class AddFiledCountAsDoubleInTopping < ActiveRecord::Migration
  def up
    #add_column :toppings, :count_as_double, :boolean
    unless column_exists? :toppings, :count_as_double
      add_column :toppings, :count_as_double, :boolean
    end
  end
  
end
