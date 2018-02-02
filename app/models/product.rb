class Product < ApplicationRecord
  has_many :option_types, dependent: :destroy

  has_one :master,
    -> { where is_master: true },
    class_name: "Variant",
    inverse_of: :product,
    dependent: :destroy

  has_many :variants,
    -> { where is_master: false },
    inverse_of: :product,
    dependent: :destroy

  [:sku, :price, :price_cents].each do |method_name|
    delegate method_name, :"#{method_name}=", to: :find_or_build_master
  end

  def find_or_build_master
    master || build_master
  end

  def generate_variants
    option_type_value_groupings = {}

    option_types.each do |option_type|
      option_type_value_groupings[option_type.id] =
        option_type.option_values.map(&:id)
    end

    all_value_ids = option_type_value_groupings.values
    all_value_ids =
      all_value_ids.inject(all_value_ids.shift) do |memo, value|
        memo.product(value).map(&:flatten)
    end

    all_value_ids.each do |value_ids|
      variants.create(option_value_ids: value_ids, price: master.price)
    end
  end
end
