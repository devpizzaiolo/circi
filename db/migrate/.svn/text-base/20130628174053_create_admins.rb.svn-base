class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|

      # overall access to the system
      t.boolean :active, :default => true

      # identifying info.
      t.string :first_name
      t.string :last_name

      # privs.
      t.boolean :edit_products, :default => false
      t.boolean :view_stats, :default => false
      t.boolean :view_customers, :default => false
      t.boolean :edit_admins, :default => false

      t.timestamps
      
    end
  end
end
