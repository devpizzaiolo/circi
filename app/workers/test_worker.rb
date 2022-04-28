class TestWorker
  include Sidekiq::Worker

  def perform(callback)
    puts "Hey #{callback}"
  end
end