import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["carousel", "thumbnail"]

  connect() {
    console.log("Carousel controller connected!")

    if (!window.bootstrap) {
      console.error("Bootstrap não está carregado!")
      return
    }
    
    this.carousel = new bootstrap.Carousel(this.carouselTarget)
  }

  select(event) {
    event.preventDefault()
    const slideIndex = event.currentTarget.dataset.slideIndex
    this.carousel.to(parseInt(slideIndex))
  }
}