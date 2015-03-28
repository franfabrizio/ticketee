class Ticket < ActiveRecord::Base
  belongs_to :project
  belongs_to :author, class_name: "User"
  belongs_to :state
  validates :title, presence: true
  validates :description, presence: true, length: { minimum: 10 }
  has_many :assets, dependent: :destroy
  accepts_nested_attributes_for :assets, reject_if: :all_blank
  has_many :comments, dependent: :destroy

  before_create :assign_default_state

  private

  def assign_default_state
    self.state ||= State.default
  end
end
