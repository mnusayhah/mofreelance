import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"];

  toggle() {
    // Toggle the dropdown menu's visibility
    this.menuTarget.classList.toggle("hidden");
  }
}
