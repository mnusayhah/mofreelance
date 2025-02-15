import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="star-rating"
export default class extends Controller {
  static targets = [ "hiddenInput", "star" ]

  connect() {
    // On initialise la note à partir du champ caché (ou 0 par défaut)
    this.value = parseInt(this.hiddenInputTarget.value) || 0;
    this.renderStars();
    // Quand le curseur quitte le conteneur, on réaffiche la note sélectionnée
    this.element.addEventListener("mouseleave", this.reset.bind(this));
  }

  updateRating(event) {
    const starValue = parseInt(event.currentTarget.dataset.value, 10);
    // Met à jour la note sélectionnée
    this.value = starValue;
    this.hiddenInputTarget.value = starValue;
    this.renderStars();
  }

  highlight(event) {
    const hoverValue = parseInt(event.currentTarget.dataset.value, 10);
    // Met en surbrillance temporaire toutes les étoiles jusqu'à celle survolée
    this.starTargets.forEach((star) => {
      const starValue = parseInt(star.dataset.value, 10);
      if (starValue <= hoverValue) {
        star.classList.remove("text-secondary");
        star.classList.add("text-warning");
      } else {
        star.classList.remove("text-warning");
        star.classList.add("text-secondary");
      }
    });
  }

  reset() {
    // Réaffiche les étoiles selon la note sélectionnée
    this.renderStars();
  }

  renderStars() {
    this.starTargets.forEach((star) => {
      const starValue = parseInt(star.dataset.value, 10);
      if (starValue <= this.value) {
        star.classList.remove("text-secondary");
        star.classList.add("text-warning"); // sélectionnée = jaune
      } else {
        star.classList.remove("text-warning");
        star.classList.add("text-secondary"); // non sélectionnée = grise
      }
      star.style.cursor = "pointer";
    });
  }
}
