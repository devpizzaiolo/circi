require 'csv'

ActiveRecord::Base.establish_connection

CSV.foreach(Rails.root.join("db", "data", "original_customers_1.csv"), {headers: :first_row}) do |row|
  
  if row[4] == "user" && !row[1].blank? && row[1].blank? !="" && !row[3].blank? && row[3] != "" && !row[7].blank? && row[7] != ""
    
    if row[3].count("@") != 1 then
      email_valid = false
    elsif row[3] =~ /^.*@.*(.com|.org|.net)$/ then
      email_valid = true
    else
      email_valid = false
    end
    
    # Look for existing
    unless email_valid == false || Customer.exists?(:email => row[3].downcase.delete(' '))
      
      name_arr = row[1].split(' ')
      
      if name_arr.length > 1 && !row[7].blank? && row[7] != ""
        
        first_name = name_arr.first
        name_arr.delete_at(0)
        last_name = name_arr.join(" ")
        
        email = row[3].downcase.delete(' ')
        puts email
        postal_code = row[7].upcase.delete(' ')
        puts postal_code
        
        email = ActiveRecord::Base.connection.quote(email)
        first_name = ActiveRecord::Base.connection.quote(first_name)
        last_name = ActiveRecord::Base.connection.quote(last_name)
        address_1 = ActiveRecord::Base.connection.quote(row[5])
        address_2 = ActiveRecord::Base.connection.quote(row[6])
        postal_code = ActiveRecord::Base.connection.quote(postal_code)
        phone_number = ActiveRecord::Base.connection.quote(row[8])
        
        created_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
        
        # @c = Customer.new(:first_name => first_name, :last_name => last_name, :email => email, :password => 'iu24h5ihioufho', :address_1 => row[5], :address_2 => row[6], :postal_code => postal_code, :phone_number => row[8], :original_customer => true, :mailing_list => true, :city => "Please Update")
        # @c.save(:validation => false)

        sql = "INSERT INTO customers (first_name, last_name, email, encrypted_password, address_1, address_2, postal_code, phone_number, original_customer, mailing_list, city, created_at, updated_at) VALUES (#{first_name}, #{last_name}, #{email}, 'iu24h5ihioufho', #{address_1}, #{address_2}, #{postal_code}, #{phone_number}, '1', '1', 'Please Update', '#{created_at}', '#{created_at}')"
        
        res = ActiveRecord::Base.connection.execute(sql)
        bar_id = ActiveRecord::Base.connection.last_inserted_id(res)
        
      else
        last_name = ""
      end
      
    else
      puts "Customer already in the database"
    end
    
  end
  
end

# def is_a_valid_email?(email)
#   # Check the number of '@' signs.
#   if email.count("@") != 1 then
#     return false
# 
#   # We can now check the email using a simple regex.
#   # You can replace the TLD's at the end with the TLD's you wish
#   # to accept.
#   elsif email =~ /^.*@.*(.com|.org|.net|.ca)$/ then
#     return true
#   else
#     return false
#   end
# end
