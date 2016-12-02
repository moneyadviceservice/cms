###########################################
## helpers
###########################################
def category(label)
  Comfy::Cms::Category.find_by_label!(label) 
end

def create_or_update(args)
  current = category(args[:label])
  if current
    current.update_attributes(args)
  else
    current = Comfy::Cms::Category.create!(args)
  end
  current
end

def assign_categories_to_clump(clump_name_en, *categories)
  clump = Clump.find_by_name_en!(clump_name_en)
  Clumping.where(clump_id: clump.id).delete_all
  categories.each_with_index do |cat, idx|
    Clumping.create(clump_id: clump.id, category_id: cat.id, ordinal: (idx + 1))
  end
end
###########################################


###########################################
## Births, Deaths and Family
###########################################
dbf = Comfy::Cms::Category.find_by_label!('births-deaths-and-family')
dbf.update_attributes(navigation: false) # remove from navigation

birth = create_or_update(
  site_id: 1,
  legacy_parent_id: dbf.id,
  parent_id: nil,
  label: 'births',
  categorized_type: 'Comfy::Cms::Page',
  title_en: 'Births',
  title_cy: 'Genedigaethau'
)
puts 'created birth category'

n = Comfy::Cms::Category
  .where(id: [category('having-a-baby').id, category('maternity-and-paternity-rights').id])
  .update_all(parent_id: birth.id)
puts "birth has #{n} sub categories: having-a-baby and maternity-and-paternity-rights"

death = create_or_update(
  site_id: 1,
  legacy_parent_id: dbf.id,
  parent_id: nil,
  label: 'deaths',
  categorized_type: 'Comfy::Cms::Page',
  title_en: 'Deaths',
  title_cy: 'Marwolaethau'
)
puts 'created death category'

n = Comfy::Cms::Category
  .where(id: [category('when-someone-dies').id])
  .update_all(parent_id: death.id)
puts "death has #{n} sub categories: when-someone-dies"

family = create_or_update(
  site_id: 1,
  legacy_parent_id: dbf.id,
  parent_id: nil,
  label: 'family',
  categorized_type: 'Comfy::Cms::Page',
  title_en: 'Family',
  title_cy: 'Theulu'
)
puts 'created family category'

n = Comfy::Cms::Category
  .where(id: [category('divorce-and-separation').id, category('making-a-will').id])
  .update_all(parent_id: family.id)
puts "family has #{n} sub categories: divorce-and-separation and making-a-will"


###########################################
## Care and Disability
###########################################
cad = category('care-and-disability')
cad.update_attributes(navigation: false) # remove from navigation

care = create_or_update(
  site_id: 1,
  legacy_parent_id: cad.id,
  parent_id: nil,
  label: 'care',
  categorized_type: 'Comfy::Cms::Page',
  title_en: 'Care',
  title_cy: 'Gofal'
)
puts 'created care category'
n = Comfy::Cms::Category
  .where(id: [category('support-for-carers').id, category('care-advice-and-help').id, category('paying-for-care').id])
  .update_all(parent_id: care.id)
puts "care has #{n} sub categories: support-for-carers, care-advice-and-help and paying-for-care"

disability = create_or_update(
  site_id: 1,
  legacy_parent_id: cad.id,
  parent_id: nil,
  label: 'disability',
  categorized_type: 'Comfy::Cms::Page',
  title_en: 'Disability',
  title_cy: 'Anabledd'
)
puts 'created disability category'

n = Comfy::Cms::Category
  .where(id: [category('illness-and-disability').id])
  .update_all(parent_id: disability.id)
puts "disability has #{n} sub categories: illness-and-disability"
###########################################


###########################################
## Home and Mortgages
###########################################
ham = category('homes-and-mortgages')
ham.update_attributes(navigation: false) # remove from navigation

homes = create_or_update(
  site_id: 1,
  legacy_parent_id: ham.id,
  parent_id: nil,
  label: 'homes',
  categorized_type: 'Comfy::Cms::Page',
  title_en: 'Homes',
  title_cy: 'Cartrefi'
)
puts 'created homes category'

n = Comfy::Cms::Category
  .where(id: [category('renting-and-letting').id])
  .update_all(parent_id: homes.id)
puts "homes has #{n} sub categories: renting-and-letting"

mortgages = create_or_update(
  site_id: 1,
  legacy_parent_id: ham.id,
  parent_id: nil,
  label: 'mortgages',
  categorized_type: 'Comfy::Cms::Page',
  title_en: 'Mortgages',
  title_cy: 'Morgeisi'
)
puts 'created mortgages category'

n = Comfy::Cms::Category
  .where(id: [category('buying-a-home').id, category('types-of-mortgage').id, category('help-with-mortgages').id])
  .update_all(parent_id: mortgages.id)
puts "mortgages has #{n} sub categories: buying-a-home, types-of-mortgage and help-with-mortgages"
###########################################



###########################################
## Cars and Travel
###########################################
cnt = Comfy::Cms::Category.find_by_label!('cars-and-travel')
cnt.update_attributes(navigation: false) # remove from navigation

travel = create_or_update(
  site_id: 1,
  legacy_parent_id: cnt.id,
  parent_id: nil,
  label: 'travel',
  categorized_type: 'Comfy::Cms::Page',
  title_en: 'Travel',
  title_cy: 'Theithio'
)
puts 'created travel category'

n = Comfy::Cms::Category
  .where(id: [category('travel-money-and-sending-money-abroad').id])
  .update_all(parent_id: travel.id)
puts "travel has #{n} sub categories: travel-money-and-sending-money-abroad"

cars = create_or_update(
  site_id: 1,
  legacy_parent_id: cnt.id,
  parent_id: nil,
  label: 'cars',
  categorized_type: 'Comfy::Cms::Page',
  title_en: 'Cars',
  title_cy: 'Ceir'
)
puts 'created cars category'


n = Comfy::Cms::Category
  .where(id: [category('running-a-car').id, category('how-to-buy-a-car').id, category('selling-your-car').id])
  .update_all(parent_id: cars.id)
puts "cars has #{n} sub categories: running-a-car, how-to-buy-a-car and selling-your-car"
###########################################


###########################################
## Assign categories to clump
###########################################
if Clump.count > 1
  assign_categories_to_clump('Homes & Mortgages',
                             homes,
                             mortgages)

  assign_categories_to_clump('Work, Benefits & Pension',
                             category('pensions-and-retirement'),
                             category('work-and-redundancy'), 
                             category('benefits'))

  assign_categories_to_clump('Family',
                             birth,
                             death,
                             family,
                             care,
                             disability)

  assign_categories_to_clump('Cars & Travel',
                             travel,
                             cars)
  puts 'Clumps grouping updated'
else
  puts 'You have to create the `Clumps` in order to assigns new categories'
end
###########################################
