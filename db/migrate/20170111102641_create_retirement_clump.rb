class CreateRetirementClump < ActiveRecord::Migration
  def change
    # first rename the existing 'Work, Benefits & Pension' clump (keeping descriptions as is)
    work_benefits_and_pensions = Clump.find_by!(name_en: 'Work, Benefits & Pension')
    work_benefits_and_pensions.update_attributes(name_en: 'Work & Benefits', name_cy: 'Gwaith a Budd-daliadau')

    # update ordinal of subsequent clumps to make a gap for the new clump
    Clump.where('ordinal > ?', work_benefits_and_pensions.ordinal).each do |clump|
      clump.update_attribute(:ordinal, clump.ordinal + 1)
    end

    # add new 'Retirement' clump containing the 'Pensions & Retirement' category
    retirement = Clump.create! do |clump|
      clump.ordinal = work_benefits_and_pensions.ordinal + 1
      clump.name_en = 'Retirement'
      clump.name_cy = 'Ymddeol'
      clump.description_en = 'Retirement advice, types of pension and retirement income, and information on automatic enrolment'
      clump.description_cy = 'Cyngor ymddeol, fathau o bensiynau ac incwm ymddeol, a gwybodaeth am gofrestru awtomatig'
    end

    # now move the pensions-and-retirement category to the new clump
    Comfy::Cms::Category.find_by!(label: 'pensions-and-retirement').clumping.update_attribute(:clump_id, retirement.id)
  end
end
