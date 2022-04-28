namespace :update do
  desc 'Update Calzone Presets metadata'
  task calzone_presets_metadata: :environment do
    puts "####### Starting updating metadata ######"
    calzone_presets = CalzonePreset.find(:all)
    calzone_presets.each do |calzone_preset|
      case calzone_preset.slug.try(:strip)
        when "baked-calzone"
          puts "####### Starting updating metadata for calzone_preset: #{calzone_preset.slug.strip} ########"
          calzone_preset.seo_title = "Pizzaiolo | Toronto and GTA's Gourmet Pizzeria | Baked Calzones"
          calzone_preset.seo_metadescription = "Not just Pizza, but also Calzones! If traditional pizza isn't your thing, come try one of Pizzaiolo's fresh baked Calzones!"
          calzone_preset.seo_keywords = "Pizzaiolo, Calzones, Baked Pizza, Takeout, Delivery, Pizza, Toronto's Best Calzone"
          puts "####### Ending updating metadata for calzone_preset: #{calzone_preset.slug.strip} ########"
      end
      calzone_preset.save
    end
    puts "####### Ending updating metadata ######"
  end
end