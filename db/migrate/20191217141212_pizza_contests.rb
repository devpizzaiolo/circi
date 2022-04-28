class PizzaContests < ActiveRecord::Migration
  def change
    create_table :pizza_contests do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :pizza_name
      t.timestamps
    end
  end 
end