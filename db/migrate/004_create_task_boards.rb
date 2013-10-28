class CreateTaskBoards < ActiveRecord::Migration

  def change
    create_table :task_boards do |t|
      t.references :owner, polymorphic: true
      t.string :title
    end
    change_table :task_board_columns do |t|
      t.references :task_board
      t.remove :project_id
    end
  end

end
