class PrintTestReport < Rescpos::Report
  
  require 'rescpos'
  
  def initialize
    @time = Time.now.to_formatted_s(:long)
  end
  
  
end