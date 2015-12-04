class LevelCollection
  def self.collection
    [
      { id: 1, name: :beginner },
      { id: 2, name: :intermediate },
      { id: 3, name: :advanced },
      { id: 99, name: :frontend }
    ]
  end

  def self.all
    collection.map { |level| new(level) }
  end

  def self.find(id)
    all.select { |level| level.id == id }.first
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
