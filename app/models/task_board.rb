class TaskBoard < ActiveRecord::Base
  unloadable
  belongs_to :owner, polymorphic: true
  has_many :columns, :class_name => 'TaskBoardColumn'
  validates_presence_of :title
  validates_length_of :title, :maximum => 255

end


