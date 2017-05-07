class Word < ApplicationRecord
  validates_uniqueness_of :word, :scope => :frequency
  has_many :inflections, class_name: "Word", foreign_key: "base_word_id"

  belongs_to :base_word, class_name: "Word"
end
