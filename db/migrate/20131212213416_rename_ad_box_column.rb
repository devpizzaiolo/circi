class RenameAdBoxColumn < ActiveRecord::Migration
  def up
    rename_column :ad_boxes, :ad_box_image, :pod
  end

  def down
    rename_column :ad_boxes, :pod, :ad_box_image
  end
end
