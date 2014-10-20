require_relative '../section'

module UI::Sections
  class Tag < UI::Section
    element :value, 'span'
    element :close, '.close'
    element :input, 'input'
  end
end
