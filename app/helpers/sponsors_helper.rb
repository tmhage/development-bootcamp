module SponsorsHelper
  def cache_key_for_sponsors
    count          = Sponsor.count
    max_updated_at = Sponsor.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "sponsors/all-#{count}-#{max_updated_at}"
  end

  def sponsor_plans_collection
    Sponsor.plans.map do |key, plan|
      ["#{plan[:name]} #{number_to_currency(plan[:price])}", key]
    end
  end

  def package_price(plan)
    number_to_currency(Sponsor.plans[plan][:price])
  end
end
