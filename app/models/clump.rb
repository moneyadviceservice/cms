class Clump < ActiveHash::Base
  self.data = [
    {
      id: 1,
      name_en: 'Debt & Borrowing',
      name_cy: 'Dyled a benthyca',
      category_labels: [
        'debt-and-borrowing'
      ]
    },
    {
      id: 2,
      name_en: 'Homes & Mortgages',
      name_cy: 'Cymorth gyda morgeisi',
      category_labels: [
        'homes-and-mortgages'
      ]
    },
    {
      id: 3,
      name_en: 'Managing Money',
      name_cy: 'Rheoli arian',
      category_labels: [
        'budgeting-and-managing-money',
        'saving-and-investing'
      ]
    },
    {
      id: 4,
      name_en: 'Work, Benefits & Pension',
      name_cy: 'Gwaith, Budddaliadau a Pensiwn',
      category_labels: [
        'pensions-and-retirement',
        'benefits'
      ]
    },
    {
      id: 5,
      name_en: 'Family',
      name_cy: 'Teulu',
      category_labels: [
        'births-deaths-and-family',
        'care-and-disability'
      ]
    },
    {
      id: 6,
      name_en: 'Cars & Travel',
      name_cy: 'Ceir a theithio',
      category_labels: [
        'cars-and-travel'
      ]
    },
    {
      id: 7,
      name_en: 'Insurance',
      name_cy: 'Yswiriant',
      category_labels: [
        'insurance'
      ]
    }
  ]

  def categories
    category_labels.collect { |l| Comfy::Cms::Category.find_by(label: l) }
  end

  def read_attribute_for_serialization(n)
    attributes[n]
  end
end
