class GymHour < ApplicationRecord
  belongs_to :gym

  enum day_of_week: {
    domingo: 0,
    segunda: 1,
    terca: 2,
    quarta: 3,
    quinta: 4,
    sexta: 5,
    sabado: 6
  }
end
