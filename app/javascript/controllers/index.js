// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Enregistrement manuel des contrôleurs
// import DropdownController from "./dropdown_controller"
// import PriceRangeSliderController from "./price_range_slider_controller"

// application.register("dropdown", DropdownController)
// application.register("price-range-slider", PriceRangeSliderController)
