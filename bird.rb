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
  validate  :verified_continents

  index({ name: 'text' })

  scope :family, -> (family) { where(family: family) }
  scope :name, -> (name) { where(name: name) }
  scope :only_visible, ->{  where(visible: true) }



  def verified_continents
    errors.add(:continents, 'Continent should be string only') unless self.continents.all? {|i| i.is_a?(String) }
    errors.add(:continents, 'Continent should be contain atleast one item') if self.continents.size.zero?
    errors.add(:continents, 'Continent should have uniq items') if self.continents.size != self.continents.uniq.size
  end
end
