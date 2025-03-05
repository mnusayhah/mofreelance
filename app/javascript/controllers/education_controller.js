import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["list"];

  connect() {
    console.log("EducationController connected");
  }

  add(event) {
    event.preventDefault();
    console.log("Adding new education...");

    // Select the template by its class (ensure this matches your HTML)
    const template = document.querySelector(".education-entry").cloneNode(true);
    const newIndex = document.querySelectorAll(".education-entry").length;

    // Update input names for the new index
    template.querySelectorAll("input, textarea, select").forEach((input) => {
      input.name = input.name.replace(/\[\d+\]/, `[${newIndex}]`);
      input.value = "";
    });

    // Append the new education entry
    this.element.querySelector("#education_list").appendChild(template);
  }

  remove(event) {
    event.preventDefault();
    console.log("Removing education...");

    const entry = event.target.closest(".education-entry");

    const destroyField = entry.querySelector(".destroy-field");
    if (destroyField) {
      destroyField.value = "1"; // Mark for deletion
      entry.style.display = "none"; // Hide the entry instead of removing
    } else {
      entry.remove(); // Fully remove if it's a new (unsaved) entry
    }
  }
}
