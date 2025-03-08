module ApplicationHelper
  def status_class(status)
    case status.to_s
    when "open"
      "status-open"
    when "pending"
      "status-pending"
    when "ongoing"
      "status-ongoing"
    when "in_progress"
      "status-ongoing" # Mappage de in_progress vers ongoing
    when "paid"
      "status-paid"
    when "completed"
      "status-completed"
    when "rejected"
      "bg-danger" # Gardé tel quel car pas de classe personnalisée pour ce statut
    else
      "bg-secondary" # Classe par défaut
    end
  end
end
