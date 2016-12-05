class CreateInitialClumps < ActiveRecord::Migration
  def change
    Clump.create! do |clump|
      clump.ordinal = 1
      clump.name_en = 'Debt & Borrowing'
      clump.name_cy = 'Dyled a benthyca'
      clump.description_en = 'Taking control of debt, getting free debt advice, and how to borrow affordably'
      clump.description_cy = 'Cymryd rheolaeth o ddyled, cael cyngor am ddim ar ddyledion, a sut i fenthyg fforddiadwy'

      clump.clumpings.build do |clumping|
        clumping.ordinal = 1
        clumping.category = Comfy::Cms::Category.find_by(label: 'debt-and-borrowing')
      end
    end

    Clump.create! do |clump|
      clump.ordinal = 2
      clump.name_en = 'Homes & Mortgages'
      clump.name_cy = 'Cymorth gyda morgeisi'
      clump.description_en = 'Everything you need to know about buying a home and choosing the right mortgage'
      clump.description_cy = 'Popeth sydd angen i chi ei wybod am brynu cartref a dewis y morgais cywir'

      clump.clumpings.build do |clumping|
        clumping.ordinal = 1
        clumping.category = Comfy::Cms::Category.find_by(label: 'homes-and-mortgages')
      end
    end

    Clump.create! do |clump|
      clump.ordinal = 3
      clump.name_en = 'Managing Money'
      clump.name_cy = 'Rheoli arian'
      clump.description_en = 'Advice on running a bank account, planning your finances, and cutting costs'
      clump.description_cy = 'Cyngor ar redeg cyfrif banc, cynllunio eich sefyllfa ariannol, a thorri costau'

      clump.clumpings.build do |clumping|
        clumping.ordinal = 1
        clumping.category = Comfy::Cms::Category.find_by(label: 'budgeting-and-managing-money')
      end

      clump.clumpings.build do |clumping|
        clumping.ordinal = 2
        clumping.category = Comfy::Cms::Category.find_by(label: 'saving-and-investing')
      end
    end

    Clump.create! do |clump|
      clump.ordinal = 4
      clump.name_en = 'Work, Benefits & Pension'
      clump.name_cy = 'Gwaith, Budddaliadau a Pensiwn'
      clump.description_en = 'Find out what benefits you\'re entitled to and learn about Universal Credit'
      clump.description_cy = 'Cael gwybod pa fudd-daliadau mae gennych hawl iddo a dysgu am Gredyd Cynhwysol'

      clump.clumpings.build do |clumping|
        clumping.ordinal = 1
        clumping.category = Comfy::Cms::Category.find_by(label: 'pensions-and-retirement')
      end

      clump.clumpings.build do |clumping|
        clumping.ordinal = 2
        clumping.category = Comfy::Cms::Category.find_by(label: 'benefits')
      end
    end

    Clump.create! do |clump|
      clump.ordinal = 5
      clump.name_en = 'Family'
      clump.name_cy = 'Teulu'
      clump.description_en = 'Having a baby, making a will, and dealing with divorce and separation'
      clump.description_cy = 'Cael babi, gwneud ewyllys, a delio â ysgaru a gwahanu'

      clump.clumpings.build do |clumping|
        clumping.ordinal = 1
        clumping.category = Comfy::Cms::Category.find_by(label: 'births-deaths-and-family')
      end

      clump.clumpings.build do |clumping|
        clumping.ordinal = 2
        clumping.category = Comfy::Cms::Category.find_by(label: 'care-and-disability')
      end
    end

    Clump.create! do |clump|
      clump.ordinal = 6
      clump.name_en = 'Cars & Travel'
      clump.name_cy = 'Ceir a theithio'
      clump.description_en = 'Help with buying, running and selling a car, buying foreign currency, and sending money abroad'
      clump.description_cy = 'Help gyda phrynu, rhedeg a gwerthu car, prynu arian tramor, ac anfon arian dramor'

      clump.clumpings.build do |clumping|
        clumping.ordinal = 1
        clumping.category = Comfy::Cms::Category.find_by(label: 'cars-and-travel')
      end
    end

    Clump.create! do |clump|
      clump.ordinal = 7
      clump.name_en = 'Insurance'
      clump.name_cy = 'Yswiriant'
      clump.description_en = 'Help and advice on protecting your family and getting the right home and car insurance'
      clump.description_cy = 'Cymorth a chyngor ar ddiogelu eich teulu a chael y yswiriant cartref a car cywir'

      clump.clumpings.build do |clumping|
        clumping.ordinal = 1
        clumping.category = Comfy::Cms::Category.find_by(label: 'insurance')
      end
    end
  end
end
