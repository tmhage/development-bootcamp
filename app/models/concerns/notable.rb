module Notable
  extend ActiveSupport::Concern

  included do
    has_many :notes, as: :notable
    accepts_nested_attributes_for :notes, reject_if: :all_blank
  end
end
