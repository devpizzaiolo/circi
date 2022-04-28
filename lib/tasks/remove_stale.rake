namespace :remove_stale do
  
  desc "Remove unordered orders more than 2 weeks old"
  task :orders => :environment do
    @orders = Order.where("ordered = ? AND updated_at < ?", false, Time.now - 2.weeks)
    @orders.delete_all
  end
  
end