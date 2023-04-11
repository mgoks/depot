class Product < ApplicationRecord
  before_destroy :ensure_not_referenced_by_any_line_item
  has_many :line_items
  validates :title, :description, :image_url, presence: true
  validates :title, uniqueness: true, length: {
    minimum: 10,
    too_short: "title has to be at least %{count} characters long"
  }
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\z}i,
    message: 'must be a URL for GIF, JPG, or PNG image.'
  }
  validates :price, numericality: {greater_than_or_equal_to: 0.01}

  private
    # Ensure there are no line items referencing this product.
    def ensure_not_referenced_by_any_line_item
      unless line_items.empty?
        errors.add(:base, 'Line items present')
        throw :abort
      end
    end
end
