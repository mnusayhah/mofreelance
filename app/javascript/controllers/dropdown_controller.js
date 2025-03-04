import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"];

  connect() {
    this.menuTarget.classList.add("hidden"); // Ensure hidden initially
  }

  toggle(event) {
    event.preventDefault(); // Prevents unwanted link behavior
    this.menuTarget.classList.toggle("hidden");
  }
}
