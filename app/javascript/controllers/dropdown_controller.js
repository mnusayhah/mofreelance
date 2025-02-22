// app/javascript/controllers/dropdown_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"];

  connect() {
    this.menuTarget.classList.add("hidden"); // Ensure hidden initially
  }

  toggle() {
    this.menuTarget.classList.toggle("hidden");
  }
}
