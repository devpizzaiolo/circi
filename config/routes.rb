PizzaioloCa::Application.routes.draw do

  get '/pages/community_involvement', to: redirect('/pages/community_programs', status: 301)
  get '/customer_services/', to: redirect('/customer_services/new', status: 301)
  get '/customer_reviews/' => 'customer_services#new', :as => :customer_new_review
  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  match 'orders/email_test' => 'orders#email_test', :as => :email_test
  match 'locations/clear_location' => 'locations#clear_location', :as => :locations_clear_location
  resources :locations

  get 'late-night-locations', to: "locations#late_night_index", as: "late_night_locations"
  
  resources :franchise_enquiries, :only => [:create]
  
  resources :customer_services, :only => [:index, :new, :create, :show]
  
  #resources :pizza_contest_votes, :only => [:index, :new, :create, :show]
  
  resources :orders_for_pickup, :only => [:index]
  
  
  resources :orders_for_delivery
  
  
  
  resources :admins, :only => [:index]

  namespace :api do
    namespace :v1 do
      resources :orders, only: [:show] do
        member do
          post :acknowledge
        end
      end
      resources :menu
    end
  end
  
  
  # ADMIN routes
  
  match "admins/yesterdays_orders/download" => "admins/yesterdays_orders#download", :as => :download_yesterdays_orders
  match "admins/yesterdays_orders/download_date" => "admins/yesterdays_orders#download_date", :as => :download_date_orders
  match "admins/order_printer_status/:id/send_test_to_printer" => "admins/order_printer_status#send_test_to_printer", :as => :admins_order_printer_status_send_test_to_printer
  
  namespace :admins do
    resources :admins
    resources :pizza_presets, param: :slug
    resources :calzone_presets
    resources :franchise_locations
    resources :salads
    resources :garlic_breads
    resources :cannolis
    resources :beverages
    resources :toppings
    resources :flyers
    resources :yesterdays_orders
    resources :todays_orders
    resources :ad_boxes
    resources :discount_codes
    resources :discount_code_filters
    resources :order_printer_status, :only => [:index]
  end
  
  
  
  
  # CUSTOMER routes
  
  
  
  
  resources :customers, :only => [:index]  
  namespace :customers do
    resources :customers
    resources :orders
  end
  
  namespace :franchise_locations do
    resources :printer_tests
    resources :kml_views, :only => [:show, :index]  
  end


  
  # create a new order form an old one...
  match "customers/orders/:id/new_order_from_old" => "customers/orders#new_order_from_old", :as => :customers_orders_new_order_from_old
  match "customers/orders/:id/remove_address" => "customers/orders#remove_address", :as => :customers_orders_remove_address
  
  
  
  
  # set location to use for ordering
  match 'locations/:id/set_location' => 'locations#set_location', :as => "locations_set_location"
  
  match 'order_items/live_calculate' => 'order_items#live_calculate', :as => :order_items_live_calculate
  match 'order_items/deal_live_calculate' => 'order_items#deal_live_calculate', :as => :order_items_deal_live_calculate
  
  match 'orders/live_calculate_additional_items' => 'orders#live_calculate_additional_items', :as => :orders_live_calculate_additional_items
  match 'orders/live_calculate_additional_for_combo_items' => 'orders#live_calculate_additional_for_combo_items', :as => :orders_live_calculate_additional_for_combo_items
  
  match 'orders/pickup' => 'orders#pickup', :as => :orders_pickup
  
  # only used for testing internally
  match 'orders/print_order' => 'orders#print_order', :as => :orders_print_order
  
  match 'orders/delivery' => 'orders#delivery', :as => :orders_delivery
  match 'orders/order-online' => 'orders#index', :as => :order_online
  match 'orders/menu' => 'orders#index', :as => :index
  match 'orders' => 'orders#index', :as => :orders_index
  match 'orders/pizza/:slug' => 'orders#index', :as => :orders_slug
  match 'orders/calzone/:calzone_slug' => 'orders#index', :as => :orders_calzone
  # match 'orders/deals/:deals_slug' => 'orders#index', :as => :orders_deals
  match 'orders/delicious_events' => 'orders#catering', :as => :orders_catering
  match 'order_items/pizza_size_prices' => 'order_items#pizza_size_prices', :as => :pizza_size_prices
  
  match 'orders/pickup_address' => 'orders#pickup_address', :as => :orders_pickup_address
  match 'orders/delivery_address' => 'orders#delivery_address', :as => :orders_delivery_address
  
  match 'orders/generate_customer' => 'orders#generate_customer', :as => :orders_generate_customer
  
  match 'orders/add_delivery_address' => 'orders#add_delivery_address', :as => :orders_add_delivery_address
  match 'orders/add_pickup_address' => 'orders#add_pickup_address', :as => :orders_add_pickup_address
  
  match 'orders/define_delivery_time' => 'orders#define_delivery_time', :as => :orders_define_delivery_time
  match 'orders/define_pickup_time' => 'orders#define_pickup_time', :as => :orders_define_pickup_time
  
  
  
  match 'orders/choose_pickup_location' => 'orders#choose_pickup_location', :as => :orders_choose_pickup_location
  match 'orders/:id/set_pickup_location' => 'orders#set_pickup_location', :as => :orders_set_pickup_location
  
  
  match 'orders/deals/:slug' => 'orders#create_deal', :as => :orders_slug_deal
  
  match 'orders/update_order_with_delivery_address' => 'orders#update_order_with_delivery_address', :as => :orders_update_order_with_delivery_address

  match 'orders/update_order_with_pickup_address' => 'orders#update_order_with_pickup_address', :as => :orders_update_order_with_pickup_address
  
  match 'orders/check_delivery_times_and_goto_summary' => 'orders#check_delivery_times_and_goto_summary', :as => :orders_check_delivery_times_and_goto_summary

  match 'orders/order_asap' => 'orders#order_asap', :as => :orders_order_asap

  match 'orders/order_asap_check' => 'orders#order_asap_check', :as => :orders_order_asap_check
  
  # order summary before committing
  match 'orders/summary' => 'orders#summary', :as => :orders_summary
  
  # apply discount code on summay page
  match 'orders/:order_id/apply_discount_code' => 'orders#apply_discount_code', :as => :orders_apply_discount_code

  # remove discount code from summay page
  match 'orders/:order_id/remove_discount_code' => 'orders#remove_discount_code', :as => :orders_remove_discount_code

  #order thanks for ordering
  match 'orders/thanks' => 'orders#thanks', :as => :orders_thanks
  
  # set the customer delivery time
  match 'orders/set_delivery_time' => 'orders#set_delivery_time', :as => :orders_set_delivery_time
  
  # set the order to be delivered ASAP
  match 'orders/set_delivery_time_asap' => 'orders#set_delivery_time_asap', :as => :orders_set_delivery_time_asap
  
  
  # submit the order and go to the thankyou page...
  match 'orders/submit_order' => 'orders#submit_order', :as => :orders_submit_order
  
  # submit the order and go to the thankyou page...
  match 'orders/thankyou' => 'orders#thankyou', :as => :orders_thankyou

  # check whether printer online or not
  match 'orders/printer_status' => 'orders#printer_status', :as => :orders_printer_status
  
  match 'orders/:product_type/:id/add_item_from_menu' => 'orders#add_item_from_menu', :as => :orders_add_item_from_menu
  
  match 'orders/set_percentage_tip' => 'orders#set_percentage_tip', :as => :orders_set_percentage_tip
  match 'orders/clear_tip' => 'orders#clear_tip', :as => :orders_clear_tip

  match 'orders/details' => 'orders#details', :as => :details
  match 'orders/complete_meal' => 'orders#complete_meal', :as => :complete_meal
  match 'orders/specials' => 'orders#specials', :as => :specials
  match 'orders/additional_items' => 'orders#additional_items', :as => :additional_items
  resources :orders, except: [:show]

  match 'orders/get_customer_details' => 'orders#get_customer_details', :as => :get_customer_details
  
  match 'orders/add_additional_to_order' => 'orders#add_additional_to_order', :as => :add_additional_to_order
  match 'orders/:item_type/:item/remove_additional' => 'orders#remove_additional', :as => :orders_remove_additional
  match 'orders/cancel_add_additional_to_order' => 'orders#cancel_add_additional_to_order', :as => :orders_cancel_add_additional_to_order
  match 'orders/:slug/categories' => 'orders#categories', :as => :categories


  
  match 'orders/get_delivery_times' => 'orders#get_delivery_times', :as => :orders_get_delivery_times
  match 'orders/:id/update_order_additional_quantity_details' => 'orders#update_order_additional_quantity_details', :as => :order_update_order_additional_quantity_details
  match 'orders/:id/update_deal_quantity' => 'orders#update_deal_quantity', :as => :orders_update_deal_quantity
  
  
  
  resources :order_items

  match 'order_items/:id/update_quantity' => 'order_items#update_quantity', :as => :otder_item_update_quantity
  match 'order_items/:id/update_quantity_details' => 'order_items#update_quantity_details', :as => :order_item_update_quantity_details
  match 'order_items/:id/change_pizza_size_details' => 'order_items#change_pizza_size_details', :as => :order_item_change_pizza_size_details
  
  match 'order_items/add_or_update' => 'order_items#add_or_update', :as => :add_or_update_order_item
  
  match 'orders/add_product' => 'orders#add_product', :as => :add_product
  
  root :to => 'home#index'
  
  
  
  
  # devise login routes
  devise_for :customers, :controllers => {:sessions => "customers/sessions", :registrations => "customers/registrations"}
  devise_for :admins
  
  
  # sidekiq monitoring
  require 'sidekiq/web'
  
  # config/routes.rb
  authenticate :admin do
    mount Sidekiq::Web => '/sidekiq'
  end


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  
end
