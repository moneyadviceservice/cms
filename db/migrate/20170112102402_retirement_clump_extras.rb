class RetirementClumpExtras < ActiveRecord::Migration
  def change
    work_and_benefits = Clump.find_by!(name_en: 'Work & Benefits')
    retirement = Clump.find_by!(name_en: 'Retirement')

    # First move retirement related links from the clump that used to be 'Work, Benefits & Pensions' to the 'Retirement' clump
    work_and_benefits.clump_links.find_by!(text_en: 'Pension calculator').update_attribute(:clump_id, retirement.id)
    work_and_benefits.clump_links.find_by!(text_en: 'Workplace pension contribution calculator').update_attribute(:clump_id, retirement.id)

    # Now create replacement/missing empty clump links for these clumps
    2.times { work_and_benefits.clump_links.create! }
    2.times { retirement.clump_links.create! }
  end
end
