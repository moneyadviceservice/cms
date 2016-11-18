class CreateInitialClumps < ActiveRecord::Migration
  def change
    Clump.create! do |clump|
      clump.ordinal = 1
      clump.name_en = 'Debt & Borrowing'
      clump.name_cy = 'Dyled a benthyca'
      clump.description_en = 'Bacon ipsum dolor amet cupim ground round t-bone boudin bacon chicken rump turducken jerky.'
      clump.description_cy = 'Veggies es bonus vobis, proinde vos postulo essum magis kohlrabi welsh onion daikon amaranth tatsoi tomatillo melon azuki bean garlic.'

      clump.clumpings.build do |clumping|
        clumping.ordinal = 1
        clumping.category = Comfy::Cms::Category.find_by(label: 'debt-and-borrowing')
      end
    end

    Clump.create! do |clump|
      clump.ordinal = 2
      clump.name_en = 'Homes & Mortgages'
      clump.name_cy = 'Cymorth gyda morgeisi'
      clump.description_en = 'Bacon ipsum dolor amet cupim ground round t-bone boudin bacon chicken rump turducken jerky.'
      clump.description_cy = 'Veggies es bonus vobis, proinde vos postulo essum magis kohlrabi welsh onion daikon amaranth tatsoi tomatillo melon azuki bean garlic.'

      clump.clumpings.build do |clumping|
        clumping.ordinal = 1
        clumping.category = Comfy::Cms::Category.find_by(label: 'homes-and-mortgages')
      end
    end

    Clump.create! do |clump|
      clump.ordinal = 3
      clump.name_en = 'Managing Money'
      clump.name_cy = 'Rheoli arian'
      clump.description_en = 'Bacon ipsum dolor amet cupim ground round t-bone boudin bacon chicken rump turducken jerky.'
      clump.description_cy = 'Veggies es bonus vobis, proinde vos postulo essum magis kohlrabi welsh onion daikon amaranth tatsoi tomatillo melon azuki bean garlic.'

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
      clump.description_en = 'Bacon ipsum dolor amet cupim ground round t-bone boudin bacon chicken rump turducken jerky.'
      clump.description_cy = 'Veggies es bonus vobis, proinde vos postulo essum magis kohlrabi welsh onion daikon amaranth tatsoi tomatillo melon azuki bean garlic.'

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
      clump.description_en = 'Bacon ipsum dolor amet cupim ground round t-bone boudin bacon chicken rump turducken jerky.'
      clump.description_cy = 'Veggies es bonus vobis, proinde vos postulo essum magis kohlrabi welsh onion daikon amaranth tatsoi tomatillo melon azuki bean garlic.'

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
      clump.description_en = 'Bacon ipsum dolor amet cupim ground round t-bone boudin bacon chicken rump turducken jerky.'
      clump.description_cy = 'Veggies es bonus vobis, proinde vos postulo essum magis kohlrabi welsh onion daikon amaranth tatsoi tomatillo melon azuki bean garlic.'

      clump.clumpings.build do |clumping|
        clumping.ordinal = 1
        clumping.category = Comfy::Cms::Category.find_by(label: 'cars-and-travel')
      end
    end

    Clump.create! do |clump|
      clump.ordinal = 7
      clump.name_en = 'Insurance'
      clump.name_cy = 'Yswiriant'
      clump.description_en = 'Bacon ipsum dolor amet cupim ground round t-bone boudin bacon chicken rump turducken jerky.'
      clump.description_cy = 'Veggies es bonus vobis, proinde vos postulo essum magis kohlrabi welsh onion daikon amaranth tatsoi tomatillo melon azuki bean garlic.'

      clump.clumpings.build do |clumping|
        clumping.ordinal = 1
        clumping.category = Comfy::Cms::Category.find_by(label: 'insurance')
      end
    end
  end
end
