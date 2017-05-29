# Models
class Bird
  include Mongoid::Document
  field :name, type: String
  field :family, type: String
  field :continents, type: Array
  field :added, type: String, default: -> { Date.today }
  field :visible, type: Boolean, default: -> { false }
  validates :name, presence: true
  validates :family, presence: true
  validates :continents, presence: true
  validate  :verified_continents_type
  validate  :verified_continents_size
  validate  :verified_continents_uniqueness
  #index :name
  scope :family, ->(family) { where(family: family) }
  scope :name, ->(name) { where(name: name) }
  scope :only_visible, -> { where(visible: true) }

  def verified_continents_type
    return if continents.all? { |i| i.is_a?(String) }
    errors.add(:continents, 'Continent should be string only')
  end

  def verified_continents_size
    return unless continents.size.zero?
    errors.add(:continents, 'Continent should be contain atleast one item')
  end

  def verified_continents_uniqueness
    return unless continents.size != continents.uniq.size
    errors.add(:continents, 'Continent should have uniq items')
  end
end
