class BaseCollection
  def self.collection
    raise "Define in child class"
  end

  def self.all
    collection.map { |item| new(item) }
  end

  def self.find(id)
    find_all(id).first
  end

  def self.find_all(*ids)
    keys = ids.flatten.map do |key|
      if all.first.id.is_a?(Symbol) && key.respond_to?(:to_sym)
        key.to_sym
      else
        key
      end
    end
    all.select { |item| keys.include?(item.id) }
  end

  def initialize(attrs = {})
    @attrs = attrs
  end

  def id
    @attrs[:id]
  end

  def name
    @attrs[:name]
  end
end
