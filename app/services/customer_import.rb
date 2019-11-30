module UserImport
  def self.update(filepath)
    count = 0
    CSV.foreach(filepath) do |row|
      if count != 0 && row[0].present?
        first_name = row[1].present? ? row[1].strip : "Customer"
        last_name = row[2].present? ? row[2].strip : "."
        display_name = row[3].present? ? row[3].strip : "."
        email = row[4].present? ? row[4].downcase.strip : ""
        phone = row[5].present? ? "+91#{row[5].strip}" : ""
        gender = row[6].present? ? row[6].downcase.strip : ""
        if gender != "male" && gender != "female"
          gender = "other"
        end
        marital_status = (row[6].present? && row[6] == 'Y') ? true : false
        dob = row[7].present? ? Date.parse(row[7]) : nil
        role = 'user'
        department = row[8].present? ? row[8].strip : ""
        job_title = row[9].present? ? row[9].strip : ""
        manager_name = row[10].present? ? row[10].strip : ""
        manager_email = row[11].present? ? row[11].strip : ""
        manager_phone = row[12].present? ? row[12].strip : ""
        is_active = true
        
        query = []
        query << {email: email} if email.present?
        query << {phone: phone} if phone.present?
        customer = User.or(query).first
        if customer.present?
          puts "Found #{customer.id}"
        else
          user = User.new({
            first_name: first_name,
            last_name: last_name,
            display_name: display_name,
            phone: phone,
            email: email,
            gender: gender,
            marital_status: marital_status,
            dob: dob,
            role: role,
            department: department,
            job_title: job_title,
            manager_name: manager_name,
            manager_email: manager_email,
            manager_phone: manager_phone,
            is_active: is_active
          })
          # unless user.valid?
          #   puts "#{user.errors.full_messages} #{user.lead_id} #{user.name} #{user.email} #{user.phone}"
          # end
          user.skip_confirmation_notification!
          if user.save
            puts "#{user.lead_id} #{user.name} #{user.email} #{user.phone}"
            user.confirm
          end
        end
      end
      count += 1
    end
  end
end
