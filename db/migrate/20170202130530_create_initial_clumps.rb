class CreateInitialClumps < ActiveRecord::Migration
  def change
    Clump.create! do |clump|
      clump.ordinal = 1
      clump.name_en = 'Debt & Borrowing'
      clump.name_cy = 'Dyled a benthyca'
      clump.description_en = 'Taking control of debt, free debt advice, improving your credit score and low-cost borrowing'
      clump.description_cy = 'Rhoi trefn ar ddyledion, cyngor am ddim ar ddyledion, gwella’ch sgôr credyd a benthyca am gost isel'

      clump.clumpings.build do |clumping|
        clumping.ordinal = 1
        clumping.category = Comfy::Cms::Category.find_by(label: 'debt-and-borrowing')
      end

      clump.clump_links.build do |link|
        link.text_en = 'Debt Test'
        link.text_cy = 'Prawf dyled'
        link.url_en = '/en/tools/debt-test'
        link.url_cy = '/cy/tools/prawf-dyledion'
        link.style = 'tool'
      end
      clump.clump_links.build do |link|
        link.text_en = 'Loan Calculator'
        link.text_cy = 'Cyfrifiannell benthyciadau'
        link.url_en = '/en/tools/loan-calculator'
        link.url_cy = '/cy/tools/cyfrifiannell-benthyciadau'
        link.style = 'tool'
      end
      clump.clump_links.build do |link|
        link.text_en = 'Credit Card Calculator'
        link.text_cy = 'Cyfrifiannell cardiau credyd'
        link.url_en = '/en/tools/credit-card-calculator'
        link.url_cy = '/cy/tools/cyfrifiannell-cerdyn-credyd'
        link.style = 'tool'
      end
      clump.clump_links.build
    end

    Clump.create! do |clump|
      clump.ordinal = 2
      clump.name_en = 'Homes & Mortgages'
      clump.name_cy = 'Cartrefi a morgeisi'
      clump.description_en = 'Renting, buying a home and choosing the right mortgage'
      clump.description_cy = 'Rhentu, prynu cartref a dewis y morgais cywir'

      clump.clumpings.build do |clumping|
        clumping.ordinal = 1
        clumping.category = Comfy::Cms::Category.find_by(label: 'homes')
      end
      clump.clumpings.build do |clumping|
        clumping.ordinal = 2
        clumping.category = Comfy::Cms::Category.find_by(label: 'mortgages')
      end

      clump.clump_links.build do |link|
        link.text_en = 'Mortgage Calculator'
        link.text_cy = 'Cyfrifiannell Morgais'
        link.url_en = '/en/tools/mortgage-calculator'
        link.url_cy = '/cy/tools/cyfrifiannell-morgais'
        link.style = 'tool'
      end
      clump.clump_links.build do |link|
        link.text_en = 'Mortgage Affordability Calculator'
        link.text_cy = 'Cyfrifiannell fforddiadwyedd morgais '
        link.url_en = '/en/tools/house-buying/mortgage-affordability-calculator'
        link.url_cy = '/cy/tools/prynu-ty/cyfrifiannell-fforddiadwyedd-morgais'
        link.style = 'tool'
      end
      clump.clump_links.build do |link|
        link.text_en = 'Stamp Duty Calculator'
        link.text_cy = 'Cyfrifiannell treth stamp'
        link.url_en = '/en/tools/house-buying/stamp-duty-calculator'
        link.url_cy = '/cy/tools/prynu-ty/cyfrifiannell-treth-stamp'
        link.style = 'tool'
      end
      clump.clump_links.build
    end

    Clump.create! do |clump|
      clump.ordinal = 3
      clump.name_en = 'Budgeting & Saving'
      clump.name_cy = 'Cyllidebu a Chynilo'
      clump.description_en = 'Running a bank account, planning your finances, cutting costs, saving money and getting started with investing'
      clump.description_cy = 'Rhedeg cyfrif banc, cynllunio’ch materion ariannol, cwtogi ar gostau, arbed arian a rhoi cychwyn ar fuddsoddi'

      clump.clumpings.build do |clumping|
        clumping.ordinal = 1
        clumping.category = Comfy::Cms::Category.find_by(label: 'budgeting-and-managing-money')
      end
      clump.clumpings.build do |clumping|
        clumping.ordinal = 2
        clumping.category = Comfy::Cms::Category.find_by(label: 'saving-and-investing')
      end

      clump.clump_links.build do |link|
        link.text_en = 'Budget Planner'
        link.text_cy = 'Cynlluniwr Cyllideb'
        link.url_en = '/en/tools/budget-planner'
        link.url_cy = '/cy/tools/cynllunydd-cyllideb'
        link.style = 'tool'
      end
      clump.clump_links.build do |link|
        link.text_en = 'Money Health Check'
        link.text_cy = 'Gwiriad Iechyd Arian'
        link.url_en = '/en/tools/health-check'
        link.url_cy = '/cy/tools/gwiriad-iechyd'
        link.style = 'tool'
      end
      clump.clump_links.build do |link|
        link.text_en = 'Savings Calculator'
        link.text_cy = 'Cyfrifiannell Cynilo'
        link.url_en = '/en/tools/savings-calculator'
        link.url_cy = '/cy/tools/cyfrifiannell-cynilo'
        link.style = 'tool'
      end
      clump.clump_links.build
    end

    Clump.create! do |clump|
      clump.ordinal = 4
      clump.name_en = 'Work & Benefits'
      clump.name_cy = 'Gwaith a Buddion'
      clump.description_en = 'Understanding your employment rights, dealing with redundancy, benefit entitlements and Universal Credit'
      clump.description_cy = 'Deall eich hawliau cyflogaeth, delio â cholli swydd, hawliadau budd-daliadau a Chredyd Cynhwysol'

      clump.clumpings.build do |clumping|
        clumping.ordinal = 1
        clumping.category = Comfy::Cms::Category.find_by(label: 'work-and-redundancy')
      end
      clump.clumpings.build do |clumping|
        clumping.ordinal = 2
        clumping.category = Comfy::Cms::Category.find_by(label: 'benefits')
      end

      clump.clump_links.build do |link|
        link.text_en = 'Redundancy Pay Calculator'
        link.text_cy = 'Cyfrifiannell tâl diswyddo'
        link.url_en = '/en/tools/redundancy-pay-calculator'
        link.url_cy = '/cy/tools/cyfrifiannell-tal-diswyddo'
        link.style = 'tool'
      end
      clump.clump_links.build do |link|
        link.text_en = 'Budget Planner'
        link.text_cy = 'Cynlluniwr Cyllideb'
        link.url_en = '/en/tools/budget-planner'
        link.url_cy = '/cy/tools/cynllunydd-cyllideb'
        link.style = 'tool'
      end
      clump.clump_links.build
      clump.clump_links.build
    end

    Clump.create! do |clump|
      clump.ordinal = 5
      clump.name_en = 'Retirement'
      clump.name_cy = 'Ymddeoliad'
      clump.description_en = 'Planning your retirement, automatic enrolment, types of pension and retirement income'
      clump.description_cy = 'Cynllunio’ch ymddeoliad, cofrestru awtomatig, mathau o bensiwn ac incwm ymddeol'

      clump.clumpings.build do |clumping|
        clumping.ordinal = 1
        clumping.category = Comfy::Cms::Category.find_by(label: 'pensions-and-retirement')
      end

      clump.clump_links.build do |link|
        link.text_en = 'Pensions Calculator'
        link.text_cy = 'Cyfrifiannell pensiwn'
        link.url_en = '/en/tools/pension-calculator'
        link.url_cy = '/cy/tools/cyfrifiannell-pensiwn'
        link.style = 'tool'
      end
      clump.clump_links.build do |link|
        link.text_en = 'Workplace Pensions Contribution Calculator'
        link.text_cy = 'Cyfrifiannell cyfraniadau pensiwn gweithle'
        link.url_en = '/en/tools/workplace-pension-contribution-calculator'
        link.url_cy = '/cy/tools/cyfrifiannell-cyfraniadau-pensiwn-gweithle'
        link.style = 'tool'
      end
      clump.clump_links.build do |link|
        link.text_en = 'Retirement Advisor Directory'
        link.text_cy = 'Cyfeirlyfr Cynghorydd Ymddeoliad'
        link.url_en = 'https://directory.moneyadviceservice.org.uk/en'
        link.url_cy = 'https://directory.moneyadviceservice.org.uk/cy'
        link.style = 'tool'
      end
      clump.clump_links.build do |link|
        link.text_en = 'Annuities Comparison Table'
        link.text_cy = 'Cymharu blwydd-daliadau'
        link.url_en = '/en/tools/annuities'
        link.url_cy = '/cy/tools/annuities'
        link.style = 'tool'
      end
    end

    Clump.create! do |clump|
      clump.ordinal = 6
      clump.name_en = 'Family'
      clump.name_cy = 'Teulu'
      clump.description_en = 'Having a baby, divorce and separation, what to do when someone’s died, choosing and paying for care services'
      clump.description_cy = 'Cael babi, ysgaru a gwahanu, beth i’w wneud pan fydd rhywun wedi marw, dewis a thalu am wasanaethau gofal'

      clump.clumpings.build do |clumping|
        clumping.ordinal = 1
        clumping.category = Comfy::Cms::Category.find_by(label: 'births')
      end
      clump.clumpings.build do |clumping|
        clumping.ordinal = 2
        clumping.category = Comfy::Cms::Category.find_by(label: 'deaths')
      end
      clump.clumpings.build do |clumping|
        clumping.ordinal = 3
        clumping.category = Comfy::Cms::Category.find_by(label: 'family')
      end
      clump.clumpings.build do |clumping|
        clumping.ordinal = 4
        clumping.category = Comfy::Cms::Category.find_by(label: 'care')
      end
      clump.clumpings.build do |clumping|
        clumping.ordinal = 5
        clumping.category = Comfy::Cms::Category.find_by(label: 'disability')
      end

      clump.clump_links.build do |link|
        link.text_en = 'Baby Cost Calculator'
        link.text_cy = 'Cyfrifiannell costau babi'
        link.url_en = '/en/articles/baby-costs-calculator'
        link.url_cy = '/cy/articles/cyfrifiannell-costau-babi'
        link.style = 'tool'
      end
      clump.clump_links.build do |link|
        link.text_en = 'Baby Money Timeline'
        link.text_cy = 'llinell amser arian babi'
        link.url_en = '/en/tools/baby-money-timeline'
        link.url_cy = '/cy/tools/llinell-amser-arian-babi'
        link.style = 'tool'
      end
      clump.clump_links.build do |link|
        link.text_en = 'Christmas Money Planner'
        link.text_cy = 'Cynllunydd Ariannol y Nadolig'
        link.url_en = '/en/tools/christmas-money-planner'
        link.url_cy = '/cy/tools/cynllunydd-ariannol-y-nadolig'
        link.style = 'tool'
      end
      clump.clump_links.build
    end

    Clump.create! do |clump|
      clump.ordinal = 7
      clump.name_en = 'Cars & Travel'
      clump.name_cy = 'Ceir a theithio'
      clump.description_en = 'Buying, running and selling a car, buying holiday money and sending money abroad'
      clump.description_cy = 'Prynu, rhedeg a gwerthu car, prynu arian tramor, ac anfon arian dramor'

      clump.clumpings.build do |clumping|
        clumping.ordinal = 1
        clumping.category = Comfy::Cms::Category.find_by(label: 'cars')
      end
      clump.clumpings.build do |clumping|
        clumping.ordinal = 2
        clumping.category = Comfy::Cms::Category.find_by(label: 'travel')
      end

      clump.clump_links.build do |link|
        link.text_en = 'Car Costs Calculator'
        link.text_cy = 'Cyfrifiannell Costau Car'
        link.url_en = '/en/tools/car-costs-calculator'
        link.url_cy = '/cy/tools/cyfrifiannell-costau-car'
        link.style = 'tool'
      end
      clump.clump_links.build do |link|
        link.text_en = 'Budget Planner'
        link.text_cy = 'Cynlluniwr Cyllideb'
        link.url_en = '/en/tools/budget-planner'
        link.url_cy = '/cy/tools/cynllunydd-cyllideb'
        link.style = 'tool'
      end
      clump.clump_links.build
      clump.clump_links.build
    end

    Clump.create! do |clump|
      clump.ordinal = 8
      clump.name_en = 'Insurance'
      clump.name_cy = 'Yswiriant'
      clump.description_en = 'Protecting your home and family with the right insurance policies'
      clump.description_cy = 'Amddiffyn eich cartref a’ch teulu gyda’r polisïau yswiriant cywir'

      clump.clumpings.build do |clumping|
        clumping.ordinal = 1
        clumping.category = Comfy::Cms::Category.find_by(label: 'insurance')
      end

      clump.clump_links.build do |link|
        link.text_en = 'Budget Planner'
        link.text_cy = 'Cynlluniwr Cyllideb'
        link.url_en = '/en/tools/budget-planner'
        link.url_cy = '/cy/tools/cynllunydd-cyllideb'
        link.style = 'tool'
      end
      clump.clump_links.build
      clump.clump_links.build
      clump.clump_links.build
    end
  end
end
