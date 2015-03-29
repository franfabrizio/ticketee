class Ticket < ActiveRecord::Base
  belongs_to :project
  belongs_to :author, class_name: "User"
  belongs_to :state
  validates :title, presence: true
  validates :description, presence: true, length: { minimum: 10 }
  has_many :assets, dependent: :destroy
  accepts_nested_attributes_for :assets, reject_if: :all_blank
  has_many :comments, dependent: :destroy
  attr_accessor :tag_names
  has_and_belongs_to_many :tags, uniq: true

  before_create :assign_default_state

  searcher do
    label :tag, from: :tags, field: "name"
    label :state, from: :state, field: "name"
  end

  def tag_names=(names)
    @tag_names = names
    names.split(",").each do |name|
      self.tags << Tag.find_or_initialize_by(name: name)
    end
  end

  private

  def assign_default_state
    self.state ||= State.default
  end
end
