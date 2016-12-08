class ClumpLink < ActiveRecord::Base

  belongs_to :clump

  validates :text_en, presence: true, unless: :empty?
  validates :text_cy, presence: true, unless: :empty?
  validates :url_en, presence: true, unless: :empty?
  validates :url_cy, presence: true, unless: :empty?
  validates :style, presence: true, unless: :empty?

  def empty?
    [text_en, text_cy, url_en, url_cy, style].all?(&:blank?)
  end

end
