class Job < ApplicationRecord
  has_many :resumes
  validates :title, presence: true
  validates :wage_upper_bound, presence: true
  validates :wage_lower_bound, presence: true
  #validates :wage_lower_bound, numericality: { greater_than: 30000}
  #validates :wage_upper_bound, numericality: { greater_than: 60000}

  scope :published, -> { where(is_hidden: false) }
  scope :recent,    -> { order('created_at DESC')}


  validate :check_salary



  def publish!
    self.is_hidden = false
    self.save
  end

  def hide!
    self.is_hidden = true
    self.save
  end


  def check_salary
    if wage_lower_bound.to_i < 30000
      errors.add(:wage_lower_bound, "最低薪不能低於 30000")
    end

    if wage_upper_bound.to_i < 60000
      errors.add(:wage_upper_bound, "最高薪要超過 60000")
    end

    if wage_lower_bound.to_i > wage_upper_bound.to_i
      errors.add(:wage_upper_bound, "最高薪不能低于最低薪")
    end
  end

end
