class SeedStudentsToMailingList < ActiveRecord::Migration
  def change
    return true unless Rails.env.production?
    Order.all.each do |order|
      order.students.each do |student|
        add_to_list(student)
      end
    end
  end

  def add_to_list(student)
    gb = Gibbon::API.new
    gb.lists.subscribe({
      id: MailingLists::PARTICIPANTS,
      email: {
        email: student.email
      },
      double_optin: false,
      update_existing: true,
      merge_vars: {
        FNAME: student.first_name,
        LNAME: student.last_name
      }
    })
    gb.lists.subscribe({
      id: MailingLists::STUDENTS,
      email: {
        email: student.email
      },
      double_optin: false,
      update_existing: true,
      merge_vars: {
        FNAME: student.first_name,
        LNAME: student.last_name
      }
    })
  rescue Gibbon::MailChimpError => e
    logger.error "Could not add #{student.email} to students mailing list: #{e.message}"
  end
end
