import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["mainContent"];


  changeContent(event) {
    event.preventDefault();
    const url = event.target.href;


    fetch(url, {
      headers: { 'Accept': 'text/html' }
    })
      .then(response => response.text())
      .then(html => {

        this.mainContentTarget.innerHTML = html;
      })
      .catch(error => {
        console.error("Error loading content:", error);
      });
  }
}
