import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="price-range-slider"
export default class extends Controller {
  static targets = ["slider", "minDisplay", "maxDisplay", "minInput", "maxInput"]

  connect() {
    this.loadNoUiSlider().then(() => {
      this.initializeSlider()
    })
  }

  loadNoUiSlider() {
    return new Promise((resolve, reject) => {
      // Vérifier si noUiSlider est déjà chargé
      if (window.noUiSlider) {
        resolve()
        return
      }

      // Charger la feuille de style
      const link = document.createElement('link')
      link.rel = 'stylesheet'
      link.href = 'https://cdnjs.cloudflare.com/ajax/libs/noUiSlider/15.7.1/nouislider.min.css'
      document.head.appendChild(link)

      // Charger le script
      const script = document.createElement('script')
      script.src = 'https://cdnjs.cloudflare.com/ajax/libs/noUiSlider/15.7.1/nouislider.min.js'
      script.async = true
      script.onload = () => resolve()
      script.onerror = () => reject(new Error("Failed to load noUiSlider"))
      document.body.appendChild(script)
    })
  }

  initializeSlider() {
    const slider = this.sliderTarget

    noUiSlider.create(slider, {
      start: [125, 560],
      connect: true,
      range: {
        'min': 0,
        'max': 1000
      },
      step: 5,
      tooltips: false,
      format: {
        to: function (value) {
          return Math.round(value)
        },
        from: function (value) {
          return Number(value)
        }
      }
    })

    // Mettre à jour les valeurs d'affichage et les champs cachés
    slider.noUiSlider.on('update', (values, handle) => {
      if (handle === 0) {
        this.minDisplayTarget.textContent = values[0]
        this.minInputTarget.value = values[0]
      } else {
        this.maxDisplayTarget.textContent = values[1]
        this.maxInputTarget.value = values[1]
      }
    })

    // Soumission automatique du formulaire (optionnel)
    // slider.noUiSlider.on('change', () => {
    //   this.element.closest('form').requestSubmit()
    // })
  }
}
