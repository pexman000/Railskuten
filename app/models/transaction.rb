class Transaction < ApplicationRecord
  belongs_to :buyer
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_save :calculate_total_price

  private

  def calculate_total_price
    self.total_price = product.price * quantity
  end
end
