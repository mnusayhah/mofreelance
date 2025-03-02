module ApplicationHelper
  def status_class(status)
  case status
  when "pending"
    "bg-warning text-dark"
  when "ongoing"
    "bg-success"
  when "rejected"
    "bg-danger"
  when "in_progress"
    "bg-primary"
  when "completed"
    "bg-success text-white"
  else
    "bg-secondary"
  end
end
end
