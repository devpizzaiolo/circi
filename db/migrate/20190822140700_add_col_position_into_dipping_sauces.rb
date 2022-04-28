class AddColPositionIntoDippingSauces < ActiveRecord::Migration
  def change
    add_column :dipping_sauces, :position, :integer, :default => 0
    DippingSauce.all.each do |dipping_sauce|
      case dipping_sauce.name 
      when "Cheddar Chipotle"
        dipping_sauce.position = 2
      when "Creamy Garlic"
        dipping_sauce.position = 3
      when "Marinara"
        dipping_sauce.position = 1
      when "Ranch"
        dipping_sauce.position = 4
      end
      dipping_sauce.save
    end
  end
end


