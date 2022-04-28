# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20210804082013) do

  create_table "ad_boxes", :force => true do |t|
    t.string   "name"
    t.string   "url_link"
    t.string   "pod"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.boolean  "active",     :default => true
    t.integer  "position",   :default => 1
  end

  create_table "addresses", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "postal_code"
    t.string   "phone_number"
    t.integer  "customer_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "is_deleted",   :default => false
  end

  add_index "addresses", ["customer_id"], :name => "index_addresses_on_customer_id"

  create_table "admins", :force => true do |t|
    t.boolean  "active",                            :default => true
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "edit_products",                     :default => false
    t.boolean  "view_stats",                        :default => false
    t.boolean  "view_customers",                    :default => false
    t.boolean  "edit_admins",                       :default => false
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "email",                             :default => "",    :null => false
    t.string   "encrypted_password",                :default => "",    :null => false
    t.integer  "sign_in_count",                     :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                   :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.boolean  "receive_order_confirmation_emails", :default => false
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["unlock_token"], :name => "index_admins_on_unlock_token", :unique => true

  create_table "beverages", :force => true do |t|
    t.string   "name"
    t.boolean  "active",                                                    :default => true
    t.datetime "created_at",                                                                   :null => false
    t.datetime "updated_at",                                                                   :null => false
    t.boolean  "pop_and_spring_water",                                      :default => false
    t.boolean  "bottles_and_premium_drinks",                                :default => false
    t.decimal  "price",                      :precision => 10, :scale => 2, :default => 0.0
    t.string   "product_image"
    t.boolean  "pop_and_juice"
    t.boolean  "water"
    t.boolean  "premium_drinks"
    t.integer  "sort_order"
    t.integer  "sort_order_for_combos"
    t.string   "extra_info"
  end

  create_table "calzone_presets", :force => true do |t|
    t.text     "product_info"
    t.string   "product_name"
    t.boolean  "active",                                              :default => false
    t.string   "calzone_image_flat"
    t.string   "calzone_image_angled"
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
    t.text     "description"
    t.decimal  "topping_price",        :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "price",                :precision => 10, :scale => 2, :default => 0.0
    t.boolean  "nut_free",                                            :default => false
    t.decimal  "normal_topping_price", :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "extra_topping_price",  :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "double_topping_price", :precision => 10, :scale => 2, :default => 0.0
    t.text     "seo_title"
    t.text     "seo_metadescription"
    t.text     "seo_keywords"
    t.string   "slug"
  end

  create_table "cannolis", :force => true do |t|
    t.string   "name"
    t.boolean  "active",                                       :default => true
    t.decimal  "price",         :precision => 10, :scale => 2, :default => 0.0
    t.string   "description"
    t.string   "product_image"
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
  end

  create_table "catering_group_sizes", :force => true do |t|
    t.string   "name"
    t.boolean  "active",     :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "constants", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contact_phone_numbers", :force => true do |t|
    t.string   "phone_number"
    t.integer  "customer_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "contact_phone_numbers", ["customer_id"], :name => "index_contact_phone_numbers_on_customer_id"

  create_table "customer_services", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "telephone"
    t.text     "comment"
    t.boolean  "pickup"
    t.integer  "franchise_location_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
  end

  add_index "customer_services", ["franchise_location_id"], :name => "index_customer_services_on_franchise_location_id"

  create_table "customers", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "postal_code"
    t.string   "phone_number"
    t.boolean  "active",                 :default => true
    t.boolean  "mailing_list",           :default => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "original_customer",      :default => false
  end

  add_index "customers", ["email"], :name => "index_customers_on_email", :unique => true
  add_index "customers", ["reset_password_token"], :name => "index_customers_on_reset_password_token", :unique => true

  create_table "delivery_pickup_times", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "desserts", :force => true do |t|
    t.string   "name"
    t.boolean  "active",                                        :default => true
    t.decimal  "price",          :precision => 10, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.boolean  "multiple_of_12",                                :default => false
    t.string   "description"
    t.boolean  "show_each",                                     :default => true
  end

  create_table "dipping_sauces", :force => true do |t|
    t.string   "name"
    t.boolean  "active",                                               :default => true
    t.decimal  "price",                 :precision => 10, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
    t.string   "description"
    t.integer  "position",                                             :default => 0
    t.integer  "sort_order_for_combos"
  end

  create_table "discount_code_filters", :force => true do |t|
    t.string   "filter_type"
    t.string   "email"
    t.string   "toppings"
    t.integer  "franchise_location_id"
    t.integer  "discount_code_id"
    t.boolean  "active",                :default => true
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "discount_codes", :force => true do |t|
    t.string   "promotion_name"
    t.string   "code"
    t.string   "value"
    t.string   "discount_type"
    t.integer  "used_order_id"
    t.boolean  "active",           :default => true
    t.boolean  "one_time_use",     :default => false
    t.datetime "expired_at"
    t.datetime "one_time_used_at"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.boolean  "exclude_deals",    :default => false
  end

  create_table "flyers", :force => true do |t|
    t.boolean  "active"
    t.string   "filename",   :default => "1"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "name"
  end

  create_table "franchise_enquiries", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "province"
    t.string   "postal_code"
    t.string   "phone"
    t.string   "email"
    t.string   "preferred_territory"
    t.string   "how_did_you_hear_about_us"
    t.string   "how_soon"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "franchise_locations", :force => true do |t|
    t.string   "address"
    t.string   "address_details"
    t.string   "phone"
    t.string   "area_name"
    t.time     "mon_open"
    t.time     "mon_closed"
    t.time     "tue_open"
    t.time     "tue_closed"
    t.time     "wed_open"
    t.time     "wed_closed"
    t.time     "thu_open"
    t.time     "thu_closed"
    t.time     "fri_open"
    t.time     "fri_closed"
    t.time     "sat_open"
    t.time     "sat_closed"
    t.time     "sun_open"
    t.time     "sun_closed"
    t.decimal  "latitude",                             :precision => 15, :scale => 10
    t.decimal  "longitude",                            :precision => 15, :scale => 10
    t.boolean  "active",                                                               :default => true
    t.datetime "created_at",                                                                                       :null => false
    t.datetime "updated_at",                                                                                       :null => false
    t.string   "google_maps_url"
    t.string   "kmlfilename"
    t.time     "delivery_mon_open"
    t.time     "delivery_mon_closed"
    t.time     "delivery_tue_open"
    t.time     "delivery_tue_closed"
    t.time     "delivery_wed_open"
    t.time     "delivery_wed_closed"
    t.time     "delivery_thu_open"
    t.time     "delivery_thu_closed"
    t.time     "delivery_fri_open"
    t.time     "delivery_fri_closed"
    t.time     "delivery_sat_open"
    t.time     "delivery_sat_closed"
    t.time     "delivery_sun_open"
    t.time     "delivery_sun_closed"
    t.boolean  "order_online",                                                         :default => true
    t.string   "kmlfilename_b"
    t.string   "printer_ip",                                                           :default => "192.168.0.29"
    t.string   "printer_port",                                                         :default => "9100"
    t.string   "kml"
    t.string   "kml_b"
    t.boolean  "receive_order_confirmation_emails",                                    :default => false
    t.string   "email"
    t.string   "slug"
    t.text     "seo_title"
    t.text     "seo_metadescription"
    t.boolean  "mon_full_day_close",                                                   :default => false
    t.boolean  "tue_full_day_close",                                                   :default => false
    t.boolean  "wed_full_day_close",                                                   :default => false
    t.boolean  "thu_full_day_close",                                                   :default => false
    t.boolean  "fri_full_day_close",                                                   :default => false
    t.boolean  "sat_full_day_close",                                                   :default => false
    t.boolean  "sun_full_day_close",                                                   :default => false
    t.string   "store_id"
    t.string   "api_key"
    t.boolean  "enable_pos_orders"
    t.boolean  "enable_printer_orders",                                                :default => true
    t.string   "encrypted_bambora_dev_merchant_id"
    t.string   "encrypted_bambora_dev_merchant_id_iv"
    t.string   "encrypted_bambora_dev_api_key"
    t.string   "encrypted_bambora_dev_api_key_iv"
    t.string   "encrypted_bambora_pro_merchant_id"
    t.string   "encrypted_bambora_pro_merchant_id_iv"
    t.string   "encrypted_bambora_pro_api_key"
    t.string   "encrypted_bambora_pro_api_key_iv"
    t.boolean  "enable_online_payments",                                               :default => false
    t.string   "bambora_env",                                                          :default => "production"
    t.string   "postal_code"
    t.string   "province"
    t.string   "city"
    t.text     "seo_keywords"
  end

  add_index "franchise_locations", ["slug"], :name => "index_franchise_locations_on_slug", :unique => true

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "garlic_breads", :force => true do |t|
    t.string   "name"
    t.boolean  "active",                                               :default => true
    t.decimal  "price",                 :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "price_one_to_five",     :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "price_six_to_nineteen", :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "price_twenty_plus",     :precision => 10, :scale => 2, :default => 0.0
    t.string   "description"
    t.string   "product_image"
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
    t.string   "extra_info"
  end

  create_table "method_of_payments", :force => true do |t|
    t.string   "name"
    t.boolean  "active",     :default => true
    t.integer  "position"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "disclaimer"
    t.string   "slug"
  end

  add_index "method_of_payments", ["slug"], :name => "index_method_of_payments_on_slug", :unique => true

  create_table "order_items", :force => true do |t|
    t.string   "product_type"
    t.string   "product_name"
    t.text     "product_info"
    t.integer  "order_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "quantity",       :default => "1"
    t.boolean  "is_catering",    :default => false
    t.string   "deal_id"
    t.integer  "pizza_position"
  end

  add_index "order_items", ["order_id"], :name => "index_order_items_on_order_id"

  create_table "orders", :force => true do |t|
    t.integer  "customer_id"
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
    t.text     "special_instructions"
    t.text     "order_additional"
    t.boolean  "ordered",                                                :default => false
    t.datetime "ordered_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "postal_code"
    t.string   "phone_number"
    t.boolean  "for_pickup",                                             :default => false
    t.string   "delivery_first_name"
    t.string   "delivery_last_name"
    t.string   "delivery_email"
    t.string   "delivery_address_1"
    t.string   "delivery_address_2"
    t.string   "delivery_postal_code"
    t.string   "delivery_phone_number"
    t.string   "contact_phone_number"
    t.string   "city"
    t.string   "delivery_city"
    t.integer  "address_id"
    t.integer  "franchise_location_id"
    t.datetime "to_be_ready_at"
    t.string   "payment_method"
    t.integer  "contact_phone_number_id"
    t.integer  "method_of_payment_id"
    t.boolean  "sent_to_printer",                                        :default => false
    t.boolean  "email_sent",                                             :default => false
    t.datetime "sent_to_pos_at"
    t.datetime "acknowledged_by_pos_at"
    t.boolean  "is_asap",                                                :default => false
    t.string   "tip_type"
    t.string   "tip_percentage"
    t.float    "tip_amount",                                             :default => 0.0
    t.string   "discount_promo_code"
    t.integer  "discount_code_id"
    t.decimal  "discount_dollar_value",   :precision => 15, :scale => 2, :default => 0.0,   :null => false
  end

  add_index "orders", ["address_id"], :name => "index_orders_on_address_id"
  add_index "orders", ["contact_phone_number_id"], :name => "index_orders_on_contact_phone_number_id"
  add_index "orders", ["customer_id"], :name => "index_orders_on_customer_id"
  add_index "orders", ["franchise_location_id"], :name => "index_orders_on_franchise_location_id"
  add_index "orders", ["method_of_payment_id"], :name => "index_orders_on_method_of_payment_id"

  create_table "payment_transactions", :force => true do |t|
    t.string   "transaction_id"
    t.datetime "transaction_date"
    t.string   "status"
    t.string   "card_type"
    t.string   "last_four_digits"
    t.string   "remarks"
    t.string   "amount"
    t.integer  "order_id"
    t.integer  "franchise_location_id"
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
    t.string   "postal_code"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "province"
    t.string   "country"
    t.string   "discount_code"
    t.integer  "discount_code_id"
    t.decimal  "discount_dollar_value", :precision => 15, :scale => 2, :default => 0.0, :null => false
  end

  create_table "pizza_categories", :force => true do |t|
    t.string   "name"
    t.boolean  "active",              :default => true
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "product_image"
    t.string   "image_ref"
    t.boolean  "direct_edit",         :default => false
    t.string   "slug"
    t.string   "page_title"
    t.text     "seo_title"
    t.text     "seo_metadescription"
    t.text     "seo_keywords"
  end

  create_table "pizza_contest_votes", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "pizza_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pizza_crust_styles", :force => true do |t|
    t.string   "name"
    t.boolean  "active",            :default => true
    t.integer  "position",          :default => 0
    t.boolean  "deep_dish_pricing", :default => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "slug"
  end

  create_table "pizza_crusts", :force => true do |t|
    t.string   "name"
    t.boolean  "active",     :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "pizza_presets", :force => true do |t|
    t.text     "product_info"
    t.string   "product_name"
    t.boolean  "active",                  :default => true
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "pizza_category_id"
    t.string   "pizza_image_flat"
    t.string   "pizza_image_angled"
    t.string   "image_flat_file_name"
    t.string   "image_flat_content_type"
    t.integer  "image_flat_file_size"
    t.datetime "image_flat_updated_at"
    t.boolean  "pizzaiolo_favourites",    :default => false
    t.boolean  "spicy",                   :default => false
    t.boolean  "customer_favourites",     :default => false
    t.boolean  "vegan",                   :default => false
    t.boolean  "health_check",            :default => false
    t.text     "description"
    t.boolean  "show_images",             :default => true
    t.boolean  "nut_free",                :default => false
    t.boolean  "gluten_free_only",        :default => false
    t.string   "calories"
    t.boolean  "is_product_combo",        :default => false
    t.integer  "product_combo_id"
    t.boolean  "is_10_inches",            :default => false
    t.integer  "category_id"
    t.boolean  "is_new_pizza"
    t.integer  "sort"
    t.string   "slug"
    t.text     "seo_title"
    t.text     "seo_metadescription"
    t.text     "seo_keywords"
  end

  add_index "pizza_presets", ["pizza_category_id"], :name => "index_pizza_presets_on_pizza_category_id"

  create_table "pizza_sizes", :force => true do |t|
    t.string   "name"
    t.boolean  "active",                                                :default => true
    t.decimal  "topping_price",          :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "deep_dish_option_price", :precision => 10, :scale => 2, :default => 0.0
    t.boolean  "has_deep_dish_option",                                  :default => true
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
    t.decimal  "price",                  :precision => 10, :scale => 2, :default => 0.0
    t.string   "abbr_name"
    t.string   "num_slices"
    t.boolean  "top_of_the_list",                                       :default => false
    t.boolean  "gluten_free",                                           :default => false
    t.string   "external_name"
    t.integer  "position",                                              :default => 0
    t.decimal  "normal_topping_price",   :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "extra_topping_price",    :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "double_topping_price",   :precision => 10, :scale => 2, :default => 0.0
    t.boolean  "is_catering",                                           :default => false
  end

  create_table "pizza_special_instructions", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.boolean  "active",     :default => true
    t.integer  "position",   :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "post_codes", :force => true do |t|
    t.string   "postcode"
    t.decimal  "latitude",   :precision => 10, :scale => 6, :default => 0.0
    t.decimal  "longitude",  :precision => 10, :scale => 6, :default => 0.0
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  add_index "post_codes", ["postcode"], :name => "index_post_codes_on_postcode"

  create_table "product_combos", :force => true do |t|
    t.string   "title"
    t.string   "banner"
    t.integer  "no_of_pizza"
    t.integer  "pizza_size_id"
    t.integer  "no_of_toppings_on_each_pizza"
    t.string   "combo_base_price"
    t.string   "paid_extra_topping_price"
    t.string   "description"
    t.integer  "no_of_free_additional_items"
    t.string   "categories_of_additional_items"
    t.string   "beverages_additional_items"
    t.string   "dipping_sauces_aditional_items"
    t.string   "salads_aditional_items"
    t.string   "garlic_breads_aditional_items"
    t.boolean  "is_active",                      :default => false
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.string   "slug"
    t.string   "first_pizza_freeze_toopings"
    t.string   "second_pizza_freeze_toopings"
    t.string   "third_pizza_freeze_toopings"
    t.string   "first_pizza_base_price"
    t.string   "second_pizza_base_price"
    t.string   "third_pizza_base_price"
    t.text     "seo_title"
    t.text     "seo_metadescription"
    t.text     "seo_keywords"
  end

  create_table "salads", :force => true do |t|
    t.string   "name"
    t.boolean  "active",                                               :default => true
    t.datetime "created_at",                                                              :null => false
    t.datetime "updated_at",                                                              :null => false
    t.decimal  "price_one_to_five",     :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "price_six_to_nineteen", :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "price_twenty_plus",     :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "price",                 :precision => 10, :scale => 2, :default => 0.0
    t.string   "product_image"
    t.text     "description"
    t.boolean  "is_catering_product",                                  :default => false
    t.string   "salad_type"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "simple_captcha_data", ["key"], :name => "idx_key"

  create_table "survey_emails", :force => true do |t|
    t.string   "email"
    t.datetime "customer_survey_email_exported_at"
    t.string   "week_and_year"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], :name => "taggings_idx", :unique => true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.integer "taggings_count", :default => 0
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "toppings", :force => true do |t|
    t.integer  "type_of_topping_id"
    t.string   "name"
    t.boolean  "active",                     :default => true
    t.boolean  "free_topping",               :default => false
    t.boolean  "non_gluten_free",            :default => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.boolean  "move_to_top",                :default => false
    t.boolean  "move_to_end_of_description", :default => false
    t.boolean  "extra_free",                 :default => false
    t.boolean  "double_free",                :default => false
    t.boolean  "count_as_double"
    t.boolean  "new_topping"
    t.string   "print_name"
    t.boolean  "half_price_topping",         :default => false
  end

  add_index "toppings", ["type_of_topping_id"], :name => "index_toppings_on_type_of_topping_id"

  create_table "type_of_toppings", :force => true do |t|
    t.string   "name"
    t.boolean  "active",            :default => true
    t.boolean  "preference_light",  :default => true
    t.boolean  "preference_extra",  :default => true
    t.boolean  "preference_double", :default => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "preference_normal", :default => true
    t.integer  "position",          :default => 0
  end

  create_table "utensils", :force => true do |t|
    t.string   "name"
    t.boolean  "active",     :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

end
