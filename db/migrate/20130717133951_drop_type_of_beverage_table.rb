class DropTypeOfBeverageTable < ActiveRecord::Migration
  def up
    drop_table :type_of_beverages
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
