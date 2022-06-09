class Issue < ApplicationRecord
  belongs_to :user

  validates_presence_of :title

  scope :filter_by_id, -> (id) { where id: id }
  scope :filter_by_title, -> (title) { where("title Like ?", title) }
  scope :filter_by_description, -> (description) { where("description Like ?", description) }
end
