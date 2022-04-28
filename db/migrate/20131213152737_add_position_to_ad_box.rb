class AddPositionToAdBox < ActiveRecord::Migration
  def change
    add_column :ad_boxes, :position, :integer, :default => 1
  end
end
