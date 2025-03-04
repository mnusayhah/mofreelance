// app/javascript/controllers/application.js
import { Application } from "@hotwired/stimulus"
import { Controller } from "@hotwired/stimulus"



export default class extends Controller {
  static targets = ["menu"];

  connect() {
    console.log("DropdownController connected!");
  }

  toggle(event) {
    event.preventDefault(); // Prevent unwanted navigation
    event.stopPropagation(); // Prevent event bubbling

    this.menuTarget.classList.toggle("hidden");
  }
}


const application = Application.start()

// Configure Stimulus application.outputTarget to log messages to the console
application.debug = false
window.Stimulus   = application

export { application }
