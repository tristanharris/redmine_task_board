require_dependency 'projects_helper'

module RedmineTaskBoardSettingsPatch

  def self.apply
    ProjectsController.send :helper, RedmineTaskBoardSettingsPatch
  end

  # Adds a task board tab to the user administration page
  def project_settings_tabs
    tabs = super
    if @project.allows_to?({ :controller => "taskboard", :action => "index" }) then
      tabs << { :name => 'taskboard', :partial => 'settings/project', :label => :label_task_board}
    end
    return tabs
  end

end
