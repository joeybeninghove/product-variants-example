class OptionType < ApplicationRecord
  belongs_to :product
  has_many :option_values, dependent: :destroy
end
