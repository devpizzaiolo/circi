class PrintMemoReport < Rescpos::Report

  require 'rescpos'
  
  def initialize(messages)
    @messages = messages
  end
end