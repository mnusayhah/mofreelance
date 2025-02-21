import { Controller } from "@hotwired/stimulus";

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
