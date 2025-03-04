import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

// Initialiser Stimulus
const application = Application.start()
window.Stimulus = application

// Charger tous les controllers Stimulus automatiquement
eagerLoadControllersFrom("controllers", application)

export { application }
