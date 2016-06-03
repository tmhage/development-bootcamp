module KpiSeries
  extend ActiveSupport::Concern

  def self.weekly
    all_kpis = {}
    models.each do |model|
      data = model.weekly_kpis
      data.each do |d|
        all_kpis[d[:date]] ||= {}
        all_kpis[d[:date]].merge! d
      end
    end
    all_kpis.sort.reverse
  end

  def self.models
    [
      Scholarship,
      Order,
      Post,
      Review,
    ]
  end

  module ClassMethods
    def weekly_kpis
      kpi_period(per: :week)
    end

    def monthly_kpis
      kpi_period(per: :month)
    end

    def kpi_period(per: :week)
      result_object_from(ActiveRecord::Base.connection.execute(
        "SELECT COUNT(*), date_trunc('#{per}', created_at) AS date
      FROM #{table_name}
      GROUP BY date_trunc('#{per}', created_at)
      ORDER BY date_trunc('#{per}', created_at) DESC"
      ))
    end

    def result_object_from(data)
      data.to_a.map do |d|
        {
          date: DateTime.parse(d['date']).end_of_week,
          table_name => d['count']
        }
      end
    end
  end
end
