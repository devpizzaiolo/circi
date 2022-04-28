namespace :carrierwave do
  
  desc "Recreate Product Images"
  task :images => :environment do
    PizzaPreset.all.each do |image|
      unless image.pizza_image_flat.blank?
        image.pizza_image_flat.recreate_versions!
      end
      unless image.pizza_image_angled.blank?
        image.pizza_image_angled.recreate_versions!
      end
    end
    CalzonePreset.all.each do |image|
      unless image.calzone_image_flat.blank?
        image.calzone_image_flat.recreate_versions!
      end
      unless image.calzone_image_angled.blank?
        image.calzone_image_angled.recreate_versions!
      end
    end
  end
  
end