class CreateCateringGroupSizes < ActiveRecord::Migration
  def change
    create_table :catering_group_sizes do |t|
      t.string :name
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
