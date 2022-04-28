class PizzaContestVote < ActiveRecord::Base
 
  attr_accessible :first_name, :last_name, :email, :phone, :pizza_name
  
  PIZZA_NAME = ['FRANKIE_VALLI', 'HONEY_HEAT', 'VEGAN_GODMOTHER', 'CHICKEN_CHIPOTLE', 'TANDOORI_VEG', 'PESTO_RICOTTA']

  validates_inclusion_of :pizza_name, :in => PIZZA_NAME
end
