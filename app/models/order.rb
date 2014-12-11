class Order < ActiveRecord::Base
  has_many :items, class_name: "LineItem"

  validates :number, uniqueness: true
  before_create :set_number

  def total
    Money.new items.sum(:total_cents)
  end

  private

  def set_number
    while !self.number || Order.exists?(number: self.number.to_s)
      self.number = create_number
    end
  end

  def create_number
    (SecureRandom.random_number(9000000) + 1000000).to_s
  end
end
