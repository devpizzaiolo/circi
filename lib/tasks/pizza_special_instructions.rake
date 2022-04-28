namespace :import do

  desc 'Import Pizza Special Instructions'
  task pizza_special_instructions: :environment do
    puts "####### Starting importing pizza special instructions ######"
    pizza_special_instructions = ["Regular", "Lightly Done", "Well Done"]
    pizza_special_instructions.each_with_index do |psi, index|
      new_psi = PizzaSpecialInstruction.create(
        name: psi,
        position: index + 1
      )
    end
    puts "####### Ended importing pizza special instructions ######"
  end

end