class TaskBoardAssignee < ActiveRecord::Base
  unloadable
  belongs_to :issue
end

require_dependency 'issue'

module IssueTaskBoardPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
      has_one :task_board_assignee
    end

  end

  module ClassMethods
  end

  module InstanceMethods
  end
end

# Add module to Issue
Issue.send(:include, IssueTaskBoardPatch)
