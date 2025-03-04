import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["list"]

  connect() {
    console.log("ExperienceController connected");
  }

  add(event) {
    event.preventDefault();
    console.log("Adding new experience...");

    const template = document.querySelector(".experience-entry").cloneNode(true);

    // Update field indices to maintain uniqueness
    const newIndex = document.querySelectorAll(".experience-entry").length;
    template.querySelectorAll("input, textarea").forEach((input) => {
      input.name = input.name.replace(/\[\d+\]/, `[${newIndex}]`);
      input.value = "";
    });

    // Append new experience entry
    this.element.querySelector("#experience_list").appendChild(template);
  }

  remove(event) {
    event.preventDefault();
    console.log("Removing experience...");

    const entry = event.target.closest(".experience-entry");
    entry.querySelector(".destroy-field").value = "1"; // Mark for deletion
    entry.style.display = "none";
  }
}
