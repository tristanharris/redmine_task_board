require_relative './lib/redmine_task_board_hook_listener'

Rails.configuration.to_prepare do
  RedmineTaskBoardSettingsPatch.apply
end

Redmine::Plugin.register :redmine_task_board do
  name 'Redmine Task Board'
  author 'Austin Smith'
  description 'Add a Kanban-style task board tab to projects'
  version '0.5'
  url 'https://github.com/netaustin/redmine_task_board'
  author_url 'http://www.alleyinteractive.com/'

  settings :partial => 'settings/redmine_task_board_settings',
           :default => {
           }

  project_module :taskboard do
    permission :edit_taskboard, {:projects => :settings, :taskboard => [:create_column, :delete_column, :update_columns]}, :require => :member
    permission :view_taskboard, {:taskboard => [:index, :save, :archive_issues, :unarchive_issue]}, :require => :member
  end
  menu :top_menu, :taskboard, { :controller => 'my_taskboard', :action => 'my_index' }, :caption => :task_board_my_board, :before => :projects
  menu :project_menu, :taskboard, { :controller => 'taskboard', :action => 'index' }, :caption => :task_board_title, :before => :issues, :param => :project_id
end
