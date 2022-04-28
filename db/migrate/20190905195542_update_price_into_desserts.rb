class UpdatePriceIntoDesserts < ActiveRecord::Migration
  def up
    @desserts = Dessert.where(:active => true)
    @desserts.each do |dessert|
      case dessert.name
       when "Assorted Italian Pastries"
        dessert.price = 2.99
      when "Assorted Pastries"
        dessert.price = 1.99
      when "Fruit Platter"
        dessert.price = 39.99
      end
      dessert.save
    end
  end

  def down
    @desserts = Dessert.where(:active => true)
    @desserts.each do |dessert|
      case dessert.name
       when "Assorted Italian Pastries"
        dessert.price = 2.95
      when "Assorted Pastries"
        dessert.price = 1.95
      when "Fruit Platter"
        dessert.price = 39.95
      end
      dessert.save
    end
  end
end
