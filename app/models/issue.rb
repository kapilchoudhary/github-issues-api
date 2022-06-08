class Issue < ApplicationRecord
  belongs_to :user

  scope :filter_by_id, -> (id) { where id: id }
end
