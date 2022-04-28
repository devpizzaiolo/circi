class MethodOfPayment < ActiveRecord::Base
  attr_accessible :active, :name, :position

  has_many :orders

  before_save :create_slug

  scope :active, lambda{ where(:active => true) }

  def create_slug
    self.slug = name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')  if self.slug.nil?
  end
end
