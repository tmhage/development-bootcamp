class UpdateScholarshipStati < ActiveRecord::Migration
  def change
    Scholarship.where(status: 'interview').update_all(status: 'interview planned')
    Scholarship.where(status: 'pending').update_all(status: 'planning interview')
    Scholarship.where(status: 'approved').update_all(status: 'send contract')
  end
end
