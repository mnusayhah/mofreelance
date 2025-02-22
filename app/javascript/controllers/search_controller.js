import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["query"];

  performSearch() {
    const query = this.queryTarget.value;

    fetch(`freelancer/profiles?query=${query}`, {
      headers: { "Accept": "text/vnd.turbo-stream.html" }
    })
      .then(response => response.text())
      .then(html => {
        document.querySelector("#profiles-container").innerHTML = html;
      })
      .catch(error => console.error("Error fetching profiles:", error));
  }
}
