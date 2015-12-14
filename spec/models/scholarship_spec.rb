require 'rails_helper'

describe Scholarship do
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:phone) }
  it { is_expected.to validate_presence_of(:gender) }
  it { is_expected.to validate_presence_of(:birth_date) }
  it { is_expected.to validate_presence_of(:education_level) }
  it { is_expected.to validate_presence_of(:employment_status) }
  it { is_expected.to validate_presence_of(:reason) }
  it { is_expected.to validate_presence_of(:future_plans) }

  it { is_expected.to validate_acceptance_of(:full_program) }
  it { is_expected.to validate_acceptance_of(:traineeship) }

  it { is_expected.to validate_inclusion_of(:gender).in_array(Scholarship::GENDERS) }
  it { is_expected.to validate_inclusion_of(:status).in_array(Scholarship::STATI) }
  it { is_expected.to validate_inclusion_of(:employment_status).in_array(Scholarship::EMPLOYMENT_STATI) }
end
