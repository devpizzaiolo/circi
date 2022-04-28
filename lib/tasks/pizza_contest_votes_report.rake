namespace :pizza_contest_votes_report do

  desc 'export'
  task :export => :environment do
    reports_enabled?
    file_name = "pizza_contest_votes_report_#{Time.now.strftime("%m_%d_%Y")}.csv"
    pizza_contest_votes = PizzaContestVote.all
    CSV.open(Rails.root + "tmp/#{file_name}", "wb") do |csv|
      csv << ["First Name", "Last Name", "email", "phone", "Pizza Name","created_at"]
      pizza_contest_votes.each do |pizza_contest_vote|
        csv << [pizza_contest_vote.first_name, pizza_contest_vote.last_name, pizza_contest_vote.email,pizza_contest_vote.phone, pizza_contest_vote.pizza_name, pizza_contest_vote.created_at]
      end
    end
    OrderMailer.send_customers_report(file_name).deliver
  end

end

def reports_enabled?
  if !ENV['REPORTS_ENABLED']
    puts "reports are not enabled on this image"
    return 
  end
end


# nohup bundle exec rake pizza_contest_votes_report:export --trace > /tmp/order.out 2>&1 &

