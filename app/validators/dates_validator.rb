class DatesValidator < ActiveModel::Validator

  def validate(record)
    i = record.periodo_inicial
    f = record.periodo_final

    if i > f || (f.jd - i.jd > 365)
      record.errors.add(:base, "Datas inválidas.")
    end
  end
end
