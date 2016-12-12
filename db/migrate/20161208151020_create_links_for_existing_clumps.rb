class CreateLinksForExistingClumps < ActiveRecord::Migration
  def change
    Clump.find_by(name_en: 'Debt & Borrowing').tap do |clump|
      clump.clump_links.create! do |link|
        link.text_en = 'Debt test'
        link.text_cy = 'Prawf dyled'
        link.url_en = '/en/tools/debt-test'
        link.url_cy = '/cy/tools/prawf-dyledion'
        link.style = 'tool'
      end
      clump.clump_links.create! do |link|
        link.text_en = 'Loan calculator'
        link.text_cy = 'Cyfrifiannell benthyciadau'
        link.url_en = '/en/tools/loan-calculator'
        link.url_cy = '/cy/tools/cyfrifiannell-benthyciadau'
        link.style = 'tool'
      end
      clump.clump_links.create! do |link|
        link.text_en = 'Credit card calculator'
        link.text_cy = 'Cyfrifiannell cardiau credyd'
        link.url_en = '/en/tools/credit-card-calculator'
        link.url_cy = '/cy/tools/cyfrifiannell-cerdyn-credyd'
        link.style = 'tool'
      end
    end

    Clump.find_by(name_en: 'Homes & Mortgages').tap do |clump|
      clump.clump_links.create! do |link|
        link.text_en = 'Mortgage calculator'
        link.text_cy = 'Cyfrifiannell Morgais'
        link.url_en = '/en/tools/mortgage-calculator'
        link.url_cy = '/cy/tools/cyfrifiannell-morgais'
        link.style = 'tool'
      end
      clump.clump_links.create! do |link|
        link.text_en = 'Mortgage affordability calculator'
        link.text_cy = 'Cyfrifiannell fforddiadwyedd morgais'
        link.url_en = '/en/tools/house-buying/mortgage-affordability-calculator'
        link.url_cy = '/cy/tools/prynu-ty/cyfrifiannell-fforddiadwyedd-morgais'
        link.style = 'tool'
      end
      clump.clump_links.create! do |link|
        link.text_en = 'Stamp Duty calculator'
        link.text_cy = 'Cyfrifiannell treth stamp'
        link.url_en = '/en/tools/house-buying/stamp-duty-calculator'
        link.url_cy = '/cy/tools/prynu-ty/cyfrifiannell-treth-stamp'
        link.style = 'tool'
      end
    end

    Clump.find_by(name_en: 'Managing Money').tap do |clump|
      clump.clump_links.create! do |link|
        link.text_en = 'Money Health Check'
        link.text_cy = 'Gwiriad Iechyd Arian'
        link.url_en = '/en/tools/health-check'
        link.url_cy = '/cy/tools/gwiriad-iechyd/start'
        link.style = 'tool'
      end
      clump.clump_links.create! do |link|
        link.text_en = 'Quick cash finder'
        link.text_cy = 'Canfod arian parod yn gyflym'
        link.url_en = '/en/tools/quick-cash-finder'
        link.url_cy = '/cy/tools/canfod-arian-parod-yn-gyflym'
        link.style = 'tool'
      end
    end

    Clump.find_by(name_en: 'Work, Benefits & Pension').tap do |clump|
      clump.clump_links.create! do |link|
        link.text_en = 'Pension calculator'
        link.text_cy = 'Cyfrifiannell pensiwn'
        link.url_en = '/en/tools/pension-calculator'
        link.url_cy = '/cy/tools/cyfrifiannell-pensiwn'
        link.style = 'tool'
      end
      clump.clump_links.create! do |link|
        link.text_en = 'Workplace pension contribution calculator'
        link.text_cy = 'Cyfrifiannell cyfraniadau pensiwn gweithle'
        link.url_en = '/en/tools/workplace-pension-contribution-calculator'
        link.url_cy = '/cy/tools/cyfrifiannell-cyfraniadau-pensiwn-gweithle'
        link.style = 'tool'
      end
      clump.clump_links.create! do |link|
        link.text_en = 'Redundancy pay calculator'
        link.text_cy = 'Cyfrifiannell tâl diswyddo'
        link.url_en = '/en/tools/redundancy-pay-calculator'
        link.url_cy = '/cy/tools/cyfrifiannell-tal-diswyddo'
        link.style = 'tool'
      end
      clump.clump_links.create! do |link|
        link.text_en = 'Tax credit calculator'
        link.text_cy = 'Credyd Treth Gwaith'
        link.url_en = '/en/articles/working-tax-credit'
        link.url_cy = '/cy/articles/credyd-treth-gwaith'
        link.style = 'tool'
      end
    end

    Clump.find_by(name_en: 'Family').tap do |clump|
      clump.clump_links.create! do |link|
        link.text_en = 'Baby cost calculator'
        link.text_cy = 'Cyfrifiannell costau babi'
        link.url_en = '/en/articles/baby-costs-calculator'
        link.url_cy = '/cy/articles/cyfrifiannell-costau-babi'
        link.style = 'tool'
      end
      clump.clump_links.create! do |link|
        link.text_en = 'Budget planner'
        link.text_cy = 'Cynlluniwr Cyllideb'
        link.url_en = '/en/tools/budget-planner'
        link.url_cy = '/cy/tools/cynllunydd-cyllideb'
        link.style = 'tool'
      end
      clump.clump_links.create! do |link|
        link.text_en = 'Christmas money planner'
        link.text_cy = 'Cynllunydd Ariannol y Nadolig'
        link.url_en = '/en/tools/christmas-money-planner'
        link.url_cy = '/cy/tools/cynllunydd-ariannol-y-nadolig'
        link.style = 'tool'
      end
    end

    Clump.find_by(name_en: 'Cars & Travel').tap do |clump|
      clump.clump_links.create! do |link|
        link.text_en = 'Car cost calculator'
        link.text_cy = 'Cyfrifiannell Costau Car'
        link.url_en = '/en/tools/car-costs-calculator'
        link.url_cy = '/cy/tools/cyfrifiannell-costau-car'
        link.style = 'tool'
      end
      clump.clump_links.create! do |link|
        link.text_en = 'Budget planner'
        link.text_cy = 'Cynlluniwr Cyllideb'
        link.url_en = '/en/tools/budget-planner'
        link.url_cy = '/cy/tools/cynllunydd-cyllideb'
        link.style = 'tool'
      end
      clump.clump_links.create! do |link|
        link.text_en = 'Credit card calculator'
        link.text_cy = 'Cyfrifiannell cardiau credyd'
        link.url_en = '/en/tools/credit-card-calculator'
        link.url_cy = '/cy/tools/cyfrifiannell-cerdyn-credyd'
        link.style = 'tool'
      end
    end

    Clump.find_by(name_en: 'Insurance').tap do |clump|
      clump.clump_links.create! do |link|
        link.text_en = 'Budget planner'
        link.text_cy = 'Cynlluniwr Cyllideb'
        link.url_en = '/en/tools/budget-planner'
        link.url_cy = '/cy/tools/cynllunydd-cyllideb'
        link.style = 'tool'
      end
    end
  end
end
