module ScholarshipsHelper
  def gender_select_options
    genders = {}
    Scholarship::GENDERS.each do |gender|
      genders[I18n.t(gender)] = gender
    end
    genders.sort
  end

  def employment_select_options
    employment_options = {}
    Scholarship::EMPLOYMENT_STATI.each do |employment|
      employment_options[I18n.t(employment)] = employment
    end
    employment_options.sort
  end
end
