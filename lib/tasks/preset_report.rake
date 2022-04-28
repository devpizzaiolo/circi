namespace :reports do

  desc "All Pizzas Name"
  task :pizza_names => :environment do
    file_name = "pizza_names_report_#{Time.now.strftime("%m_%d_%Y")}.csv"
    CSV.open(Rails.root + "tmp/#{file_name}", "wb") do |csv|
      # setting up header start
      heading = ["Pizza Name"]
      csv << heading

      pizza_names = []
      PizzaPreset.all.each do |pp|
        csv << [pp.product_name]
      end
    end
    OrderMailer.send_pizza_name_report(file_name).deliver
  end

  desc "Pizza presets reports by SKUs"
  task :pizza_presets => :environment do
    franchise_locations = FranchiseLocation.all;nil
    file_name = "pizza_preset_report_#{Time.now.strftime("%m_%d_%Y")}.csv"
    start_date = Time.parse("1-10-2018").beginning_of_day
    end_date = Time.parse("5-10-2019").end_of_day

    franchise_mapping = {}
    franchise_locations.each do |f|
      franchise_mapping[f.id.to_s] = f.address
    end

    CSV.open(Rails.root + "tmp/#{file_name}", "wb") do |csv|

      # setting up header start
      heading = ["Pizza Preset Name", "Number of units sold", "Number of units sold(customized)"] + franchise_mapping.sort.map {|x| x[1]}
      csv << heading
      # setting up header end
      # order_ids = Order.where(ordered: true, ordered_at: start_date..end_date).pluck(:id)
      order_items = OrderItem.includes(:order).where(
        orders: {
          ordered_at: start_date..end_date,
          ordered: true
        }
      );nil

      pizza_preset_mapping = {}
      PizzaPreset.all.each do |pp|
        pizza_preset_mapping[pp.id.to_s] = pp.product_name
      end;nil
      pizza_orders = []

      order_items.find_each do |oi|
        pizza_orders << OpenStruct.new({
          store_address: franchise_mapping[oi.order.franchise_location_id.to_s],
          pizza_preset_name: pizza_preset_mapping[oi.product_info["pizza_preset_id"].to_s],
          quantity: oi.quantity,
          custom: false
        })
      end;nil
      pizza_presets_sold_by_store = {}
      #{
      #  "Bianca" => {
      #    total: 100
      #    "416 Bloor Street": 10
      #  }
      #}

      pizza_orders.each do |pizza_order|
        if !pizza_presets_sold_by_store[pizza_order.pizza_preset_name]
          pizza_presets_sold_by_store[pizza_order.pizza_preset_name] ||= {
            'total' => 0,
            'customized' => 0
          }
          franchise_mapping.values.each do |fn|
            pizza_presets_sold_by_store[pizza_order.pizza_preset_name][fn] = 0
          end
        end
        qty = pizza_order.quantity.to_i === 0 ? 1 : pizza_order.quantity.to_i
        pizza_presets_sold_by_store[pizza_order.pizza_preset_name]['total'] += qty
        pizza_presets_sold_by_store[pizza_order.pizza_preset_name]['customized'] += qty if pizza_order.custom
        if pizza_order.store_address
          pizza_presets_sold_by_store[pizza_order.pizza_preset_name][pizza_order.store_address] += qty
        end

      end  

      pizza_presets_sold_by_store.each do |r|
        data = []
        data.push(r[0])
        data.push(r[1]['total'])
        data.push(r[1]['customized'])
        franchise_name = franchise_mapping.sort.map {|x| x[1]}
        franchise_name.each do |f|
          data.push(r[1][f])
        end
        csv << data
      end
    end

    OrderMailer.send_pizza_preset_report(file_name).deliver
  end

end