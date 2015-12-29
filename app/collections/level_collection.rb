class LevelCollection < BaseCollection
  def self.collection
    [
      { id: 1, name: :beginner },
      { id: 2, name: :intermediate },
      { id: 3, name: :advanced },
      { id: 99, name: :frontend }
    ]
  end
end
