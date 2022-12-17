class List < ApplicationRecord
  belongs_to :user
  has_many :list_items

  validates :name, presence: true

  enum status: %i[visible hidden deleted]

  def self.with_list_items
    lists = List.where(status: :visible)
    lists.map { |list| list.attributes.merge({ list_items: list.list_items }) }
  end
end
