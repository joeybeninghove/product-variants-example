class Variant < ApplicationRecord
  belongs_to :product
  has_many :option_value_variants, dependent: :destroy
  has_many :option_values, through: :option_value_variants

  monetize :price_cents

  validates_uniqueness_of :sku, allow_blank: true
  validate :uniqueness_of_option_values

  private

  def uniqueness_of_option_values
    other_variants = product.variants.where.not(id: self.id)

    other_variants.each do |variant|
      if variant.option_values.sort == self.option_values.sort
        errors.add(:option_values, "already exist on a variant")
      end
    end

    if option_values.uniq.length != option_values.length
      errors.add(:option_values, "must be unique")
    end
  end
end
