import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "companyField" ]

  connect() {
    this.toggle() // Ajuste l'affichage dès le chargement de la page
  }

  toggle() {
    const role = this.element.querySelector('[name="user[role]"]').value
    if (role === "enterprise") {
      this.companyFieldTarget.style.display = "block"
    } else {
      this.companyFieldTarget.style.display = "none"
    }
  }
}
