require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "finding variant from selected option values" do
    # create product set up with various option types/values
    product = create_product

    # grab some option values to use
    small = find_option_value_by_name(
      product: product, option_type_name: "Size", option_value_name: "Small")
    red = find_option_value_by_name(
      product: product, option_type_name: "Color", option_value_name: "Red")
    cotton = find_option_value_by_name(
      product: product, option_type_name: "Material", option_value_name: "Cotton")

    # simulate customer picking small, red, cotton on a product form
    chosen_option_value_ids = [small.id, red.id, cotton.id]

    # find the variant that matches the selected option values
    variant = product.variants
      .joins(:option_values)
      .where(option_values: { id: chosen_option_value_ids })
      .group(:id)
      .having("count(variants.id) = ?", chosen_option_value_ids.count)
      .first

    assert_equal 3, variant.option_values.count
    assert variant.option_values.include? small
    assert variant.option_values.include? red
    assert variant.option_values.include? cotton
  end

  def create_product
    Product.create!(name: "Braves Shirt", sku: "braves-shirt", price: 10.95).tap do |product|
      product.option_types.create!(name: "Size").tap do |size|
        size.option_values.create!(name: "Small")
        size.option_values.create!(name: "Medium")
        size.option_values.create!(name: "Large")
      end

      product.option_types.create!(name: "Color").tap do |color|
        color.option_values.create!(name: "Red")
        color.option_values.create!(name: "Blue")
        color.option_values.create!(name: "Orange")
      end

      product.option_types.create!(name: "Material").tap do |material|
        material.option_values.create!(name: "Cotton")
        material.option_values.create!(name: "Poly")
      end

      # generates variants for all possible combinations of option types/values
      product.generate_variants
    end
  end

  def find_option_value_by_name(product:, option_type_name:, option_value_name:)
    product.option_types
      .find_by(name: option_type_name).option_values
      .find_by(name: option_value_name)
  end
end
