class Repo < ApplicationRecord
  belongs_to :user

  validates :full_name, :repo_id, presence: true
  validates :repo_id, numericality: { only_integer: true }
  validates_uniqueness_of :repo_id
end
