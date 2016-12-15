class Cell < ActiveRecord::Base

  belongs_to :table
  belongs_to :column, class_name: "Coordinate", foreign_key: "coordinate_x"
  belongs_to :row, class_name: "Coordinate", foreign_key: "coordinate_y"

  enum cell_type: [:integer, :text, :decimal]

  before_destroy :no_dependents?
  before_create :no_problem_with_dependency?
  before_update :no_problem_with_dependency?

  validates :coordinate_x, presence: true
  validates :coordinate_y, presence: true
  validates :cell_type, presence: true

  private

    def no_dependents?
      answer = true
      if IntegerCell.find_by(cell_id: self.id) ||
         DecimalCell.find_by(cell_id: self.id) ||
         TextCell.find_by(cell_id: self.id)
        self.errors.add(:base, I18n.t(:dependent_cells))
        answer = false
      end
      return answer
    end

    def no_problem_with_dependency?
      answer = true
      if !Cell.where(coordinate_x: self.coordinate_x,
                     coordinate_y: self.coordinate_y)
              .where.not(id: self.id).blank?
        self.errors.add(:base, I18n.t(:the_place_is_busy))
        answer = false
      elsif self.row.superior_id == self.coordinate_x
        self.errors.add(:base, I18n.t(:the_place_is_busy))
        answer = false
      elsif self.cell_type != self.cell_type_was
        if self.cell_type_was == 'integer'
          value = IntegerCell.find_by(cell_id: self.id)
        elsif self.cell_type_was == 'decimal'
          value = DecimalCell.find_by(cell_id: self.id)
        elsif self.cell_type_was == 'text'
          value = TextCell.find_by(cell_id: self.id)
        else
          value = nil
        end
        if !value.blank?
          self.errors.add(:base, I18n.t(:dependent_cells))
          answer = false
        end
      end
      return answer
    end

end
