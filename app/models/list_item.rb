class ListItem < ApplicationRecord
  belongs_to :list

  validates :short_name, presence: true

  enum completion_status: %i[started done deleted]
end
