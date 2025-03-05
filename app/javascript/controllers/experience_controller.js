import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["list"];

  connect() {
    console.log("ExperienceController connected");
  }

  add(event) {
    event.preventDefault();
    console.log("Adding new experience...");

    const template = document.querySelector(".experience-entry").cloneNode(true);
    const newIndex = document.querySelectorAll(".experience-entry").length;

    // Ensure we also update select fields for date inputs
    template.querySelectorAll("input, textarea, select").forEach((input) => {
      input.name = input.name.replace(/\[\d+\]/, `[${newIndex}]`);
      input.value = "";
    });

    // Make sure the destroy field is reset if present
    const destroyField = template.querySelector(".destroy-field");
    if (destroyField) destroyField.value = "0";

    // Append new experience entry
    this.element.querySelector("#experience_list").appendChild(template);
  }

  remove(event) {
    event.preventDefault();
    console.log("Removing experience...");

    const entry = event.target.closest(".experience-entry");

    // Check if there's a destroy field (nested attributes handling)
    const destroyField = entry.querySelector(".destroy-field");
    if (destroyField) {
      destroyField.value = "1"; // Mark for deletion
      entry.style.display = "none"; // Hide it instead of removing
    } else {
      entry.remove(); // Fully remove if it's a new (unsaved) entry
    }
  }
}
