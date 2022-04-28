class UpdateDippingSaucesPrices < ActiveRecord::Migration
  def up
    @dipping_sauces = DippingSauce.find(:all)
    @dipping_sauces.each do |dipping_sauce|
      dipping_sauce.price = 0.89
      dipping_sauce.save
    end
  end

  def down
    @dipping_sauces = DippingSauce.find(:all)
    @dipping_sauces.each do |dipping_sauce|
      dipping_sauce.price = 0.85
      dipping_sauce.save
    end
  end
end
