class CreatePostCodes < ActiveRecord::Migration
  def change
    create_table :post_codes do |t|
      t.string :postcode
      t.decimal :latitude, :default => 0, :precision => 10, :scale => 6
      t.decimal :longitude, :default => 0, :precision => 10, :scale => 6

      t.timestamps
      
    end
    add_index :post_codes, :postcode
  end
end
