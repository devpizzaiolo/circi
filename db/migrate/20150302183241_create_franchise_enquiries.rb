class CreateFranchiseEnquiries < ActiveRecord::Migration
  def change
    create_table :franchise_enquiries do |t|
      t.string :first_name
      t.string :last_name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :province
      t.string :postal_code
      t.string :phone
      t.string :email
      t.string :preferred_territory
      t.string :how_did_you_hear_about_us
      t.string :how_soon

      t.timestamps
    end
  end
end
