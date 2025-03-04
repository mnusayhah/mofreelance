// import { Controller } from "@hotwired/stimulus";

// import { Dropdown } from "bootstrap"

// document.addEventListener("DOMContentLoaded", function () {
//   var dropdownElementList = [].slice.call(document.querySelectorAll('.dropdown-toggle'))
//   var dropdownList = dropdownElementList.map(function (dropdownToggleEl) {
//     return new Dropdown(dropdownToggleEl)
//   })
// })


// export default class extends Controller {
//   static targets = ["menu"];

//   connect() {
//     console.log("DropdownController connected!");
//   }

//   toggle(event) {
//     event.preventDefault(); // Prevent unwanted navigation
//     event.stopPropagation(); // Prevent event bubbling

//     this.menuTarget.classList.toggle("hidden");
//   }
// }

// // app/javascript/controllers/application.js
// import { Application } from "@hotwired/stimulus"

// const application = Application.start()

// // Configure Stimulus application.outputTarget to log messages to the console
// application.debug = false
// window.Stimulus   = application

// export { application }
