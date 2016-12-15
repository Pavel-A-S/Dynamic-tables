class Coordinate < ActiveRecord::Base
  has_many :dependents, class_name: "Coordinate",
                       foreign_key: "superior_id"
  belongs_to :superior, class_name: "Coordinate"
  belongs_to :table

  enum disposition: [:row, :column]

  before_destroy :no_dependents?
  before_update :no_problem_with_dependency?
  before_validation :remove_superior_if_disposition_is_row

  validates :name, presence: true, length: { maximum: 250 }
  validates :disposition, presence: true
  validates :superior_id, presence: true, if: :coordinate_of_column?
  validates :order, numericality: { greater_than: -100000, less_than: 100000 }

  private
    def coordinate_of_column?
      self.column?
    end

    def coordinate_of_row?
      self.row?
    end

    def remove_superior_if_disposition_is_row
      self.superior_id = nil if coordinate_of_row?
    end

    def no_dependents?

      answer = true

      if coordinate_of_row?
        if !Coordinate.where(superior_id: self.id).blank?
          self.errors.add(:base, I18n.t(:dependent_coordinates))
          answer = false
        elsif !Cell.where(coordinate_x: self.id).blank?
          self.errors.add(:base, I18n.t(:dependent_cells))
          answer = false
        end
      elsif coordinate_of_column?
        if !Cell.where(coordinate_y: self.id).blank?
          self.errors.add(:base, I18n.t(:dependent_cells))
          answer = false
        end
      end

      return answer
    end

    def no_problem_with_dependency?
      answer = true
      if coordinate_of_column?
        if self.disposition_was == 'row' &&
           !Coordinate.where(superior_id: self.id).blank?
          self.errors.add(:base, I18n.t(:dependent_coordinates))
          answer = false
        elsif self.disposition_was == 'row' &&
          !Cell.where(coordinate_x: self.id).blank?
          self.errors.add(:base, I18n.t(:dependent_cells))
          answer = false
        elsif self.disposition_was == 'row' &&
              self.superior_id == self.id
          self.errors.add(:base, I18n.t(:self_id_equal_self_superior_id))
          answer = false
        elsif !Cell.where(coordinate_x: self.superior_id,
                          coordinate_y: self.id).blank?
          self.errors.add(:base, I18n.t(:the_place_is_busy))
          answer = false
        end
      end

      return answer
    end
end
