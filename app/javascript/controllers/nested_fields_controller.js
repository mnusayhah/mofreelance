document.addEventListener("DOMContentLoaded", function() {
  function addField(containerId) {
    let container = document.getElementById(containerId);
    let newField = container.querySelector(".nested-fields").cloneNode(true);
    newField.querySelectorAll("input").forEach(input => input.value = "");
    container.appendChild(newField);
  }

  document.getElementById("add_skill").addEventListener("click", function(e) {
    e.preventDefault();
    addField("skills");
  });

  document.getElementById("add_education").addEventListener("click", function(e) {
    e.preventDefault();
    addField("educations");
  });

  document.addEventListener("click", function(e) {
    if (e.target.classList.contains("remove_fields")) {
      e.preventDefault();
      e.target.closest(".nested-fields").remove();
    }
  });
});

document.addEventListener("DOMContentLoaded", function() {
  document.getElementById("submit-profile").addEventListener("click", function(event) {
    console.log("Submit button clicked!");
  });
});
