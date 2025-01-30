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

    // select(event) {
    //   event.preventDefault()
    //   const slideIndex = event.currentTarget.dataset.slideIndex
    //   this.carousel.to(parseInt(slideIndex))
    // }

    this.element.querySelectorAll('.img-thumbnail').forEach(thumb => {
      thumb.addEventListener('click', (e) => {
        const slideIndex = e.target.dataset.bsSlideTo
        const carousel = document.querySelector('#gymCarousel')
        const bsCarousel = new bootstrap.Carousel(carousel)
        bsCarousel.to(parseInt(slideIndex))
      })
    })
  }
}