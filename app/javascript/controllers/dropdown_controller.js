import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"];

  toggle(event) {
    event.preventDefault(); // Prevents unwanted link behavior
    this.menuTarget.classList.toggle("hidden");
  }
}
