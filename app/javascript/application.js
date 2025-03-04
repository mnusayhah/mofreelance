// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails=======
import "@hotwired/turbo-rails";
import "controllers";
import "@popperjs/core";
import "bootstrap";
// import "jquery";
// import jquery from "jquery";
// window.$ = jquery
// window.jQuery = jquery
import "@popperjs/core";
import Rails from "@rails/ujs"

import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

// Initialiser Stimulus
const application = Application.start()
window.Stimulus = application

// Charger tous les controllers Stimulus automatiquement
eagerLoadControllersFrom("controllers", application)

export { application }

Rails.start()
