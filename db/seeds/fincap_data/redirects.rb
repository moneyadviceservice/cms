[
  {
    source: '/document/WOuEzCsAAIaQ8tXy/financial-well-being-the-employee-view',
    destination: '/en/insights/financial-well-being-the-employee-view'
  },
  {
    source: '/document/WTVdRSkAAOsYaAQx/raising-household-saving',
    destination: '/en/reviews/raising-household-saving'
  },
  {
    source: '/document/WOYJaysAADA42rIr/looking-after-the-pennies',
    destination: '/en/evaluations/looking-after-the-pennies'
  },
  {
    source: '/young-adults',
    destination: '/en/lifestages/young-adults',
  },
  {
    source: '/en/news/old-news',
    destination: '/en/news/press-release-a-new-way-to-pay'
  }
].each do |attributes|
  Redirect.find_or_create_by(attributes.merge(redirect_type: 'permanent'))
end
