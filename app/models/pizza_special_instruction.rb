class PizzaSpecialInstruction < ActiveRecord::Base
  attr_accessible :active, :slug, :name, :position

  before_save :create_or_update_slug

  scope :active, lambda{ where(:active => true) }

  private
    def create_or_update_slug
      if self.slug.nil?
        self.slug = self.name.try(:parameterize)
      end
    end
end
