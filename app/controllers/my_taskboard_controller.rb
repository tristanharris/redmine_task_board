class MyTaskboardController < ApplicationController
  unloadable

  before_filter :my_account_or_admin

  def my_index
    index
    render 'index'
  end

  def index
    TaskBoardAssignee
    issues = Issue \
        .joins(:status, :tracker, :project, :priority) \
        .includes(:status, :tracker, :project, :priority) \
        .joins('LEFT OUTER JOIN task_board_assignees AS tba ON tba.issue_id = issues.id AND tba.assignee_id = issues.assigned_to_id') \
        .where(:assigned_to_id => @user, :issue_statuses => {:is_closed => false}, :projects => {:status => 1}) \
        .order('tba.weight', 'enumerations.position DESC')

    @not_prioritized, @prioritized = issues.partition do |issue|
      issue.task_board_assignee.nil? or issue.task_board_assignee.weight == nil or issue.task_board_assignee.weight == 0
    end
  end

  def save
    TaskBoardAssignee.destroy_all(:assignee_id => @user.id)
    weight = 1;
    used_ids = Array.new
    params[:sort].each do |issue_id|
      unless used_ids.include? issue_id
        used_ids << issue_id
        tba = TaskBoardAssignee.where(:issue_id => issue_id, :assignee_id => @user.id).first_or_create(:weight => weight)
        weight += 1
      end
    end
    respond_to do |format|
      format.js{ head :ok }
    end
  end

  def my_account_or_admin
    find_user
    if @user.id != User.current.id
      require_admin
    end
    true
  end

  def find_user
    if params[:id] == nil
      params[:id] = User.current.id
    end

    if params[:id] == 'current'
      require_login || return
      @user = User.current
    else
      @user = User.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
