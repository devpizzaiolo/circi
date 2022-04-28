class Topping < ActiveRecord::Base
  attr_accessor :selection_info
  
  belongs_to :type_of_topping
  attr_accessible :active, :free_topping, :non_gluten_free, :name, :type_of_topping_id, :move_to_top, :move_to_end_of_description, :extra_free, :double_free, :count_as_double, :new_topping, :print_name, :half_price_topping
  
  after_update :expire_fragments
  after_create :expire_fragments

  def normal_free?
    self.free_topping
  end

  def light_free?
    self.normal_free?
  end
  
  private
    
    def expire_fragments
      
      # expire calzone caches
      ActionController::Base.new.expire_fragment('calzone_preset_selection')
      
      # expire pizza caches
      ActionController::Base.new.expire_fragment('pizza_presets')
      ActionController::Base.new.expire_fragment('pizza_presets_menu')
      ActionController::Base.new.expire_fragment('pizza_presets_nutritional')
      
    end
  
end
