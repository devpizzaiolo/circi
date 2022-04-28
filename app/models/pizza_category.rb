class PizzaCategory < ActiveRecord::Base
  
  attr_accessible :name, :page_title, :seo_title, :seo_keywords, :seo_metadescription
  has_many :pizza_presets
  
  before_save :create_slug

  def create_slug
    self.slug = name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end
  
end
