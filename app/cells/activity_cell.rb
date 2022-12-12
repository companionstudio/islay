class ActivityCell < Islay::ApplicationCell
  def log
    @user_logs = UserActionLog.recent(10).for_user(current_user)
    @global_logs = ActivityLog.recent(10).reject{|l| l.model.blank?}
    render
  end

end
