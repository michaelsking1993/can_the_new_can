class Word < ApplicationRecord
  validates_uniqueness_of :word, :scope => :frequency
end
