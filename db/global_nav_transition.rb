##########################################################################
### global nav transition script
##########################################################################

category = ->(label) { Comfy::Cms::Category.find_by_label!(label) }
create_cat = ->(args) { Comfy::Cms::Category.create!(args) }
update_cat = ->(args) { Comfy::Cms::Category.where(label: args[:label]).update_all(args) }

create_or_update_category = lambda do |args|
  label = args.fetch(:label) { fail "key: label missing in #{args}"}
  (category[label] rescue nil) ? update_cat[args] : create_cat[args]
  category[label]
end

###########################################################################

dbf = category['births-deaths-and-family']

birth = create_or_update_category[
  site_id: 1,
  legacy_parent_id: dbf.id,
  parent_id: nil,
  label: 'births',
  categorized_type: "Comfy::Cms::Page",
  title_en: "Births",
  title_cy: "Births"
]
puts "birth : #{birth}"

death = create_or_update_category[
  site_id: 1,
  legacy_parent_id: dbf.id,
  parent_id: nil,
  label: 'deaths',
  categorized_type: "Comfy::Cms::Page",
  title_en: "Deaths",
  title_cy: "Deaths"
]
puts "death : #{death}"

family = create_or_update_category[
  site_id: 1,
  legacy_parent_id: dbf.id,
  parent_id: nil,
  label: 'family',
  categorized_type: "Comfy::Cms::Page",
  title_en: 'Family',
  title_cy: 'Family'
]
puts "family : #{family}"

Comfy::Cms::Category
  .where(id: [category['having-a-baby'].id, category['maternity-and-paternity-rights'].id])
  .update_all(parent_id: birth.id)

Comfy::Cms::Category
  .where(id: [category['when-someone-dies'].id])
  .update_all(parent_id: death.id)

Comfy::Cms::Category
  .where(id: [category['divorce-and-separation'].id, category['making-a-will'].id])
  .update_all(parent_id: family.id)


########################################################################
cad = category['care-and-disability']

care = create_or_update_category[
  site_id: 1,
  legacy_parent_id: cad.id,
  parent_id: nil,
  label: 'care',
  categorized_type: "Comfy::Cms::Page",
  title_en: 'Care',
  title_cy: 'Care'
]

disability = create_or_update_category[
  site_id: 1,
  legacy_parent_id: cad.id,
  parent_id: nil,
  label: 'disability',
  categorized_type: "Comfy::Cms::Page",
  title_en: 'Disability',
  title_cy: 'Disability'
]

Comfy::Cms::Category
  .where(id: [category['support-for-carers'].id, category['care-advice-and-help'].id, category['paying-for-care'].id])
  .update_all(parent_id: care.id)

Comfy::Cms::Category
  .where(id: [category['illness-and-disability'].id])
  .update_all(parent_id: disability.id)


######################################################################
## Home and Mortgages

ham = category['homes-and-mortgages']

homes = create_or_update_category[
  site_id: 1,
  legacy_parent_id: ham.id,
  parent_id: nil,
  label: 'homes',
  categorized_type: "Comfy::Cms::Page",
  title_en: 'Homes',
  title_cy: 'Homes'
]

mortgages = create_or_update_category[
  site_id: 1,
  legacy_parent_id: ham.id,
  parent_id: nil,
  label: 'mortgages',
  categorized_type: "Comfy::Cms::Page",
  title_en: 'Mortgages',
  title_cy: 'Mortgages'
]

Comfy::Cms::Category
  .where(id: [category['renting-and-letting'].id])
  .update_all(parent_id: homes.id)

Comfy::Cms::Category
  .where(id: [category['buying-a-home'].id, category['types-of-mortgage'].id, category['help-with-mortgages'].id])
  .update_all(parent_id: mortgages.id)

