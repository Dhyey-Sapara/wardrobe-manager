import { Controller } from "@hotwired/stimulus"

// Shows a loading spinner while the cloths turbo-frame or turbo-stream is fetching.
export default class extends Controller {
  static targets = ["spinner", "grid"]

  connect() {
    this._showSpinner = this.showSpinner.bind(this)
    this._hideSpinner = this.hideSpinner.bind(this)
    this.element.addEventListener("turbo:before-fetch-request", this._showSpinner)
    this.element.addEventListener("turbo:before-fetch-response", this._hideSpinner)
    this.element.addEventListener("turbo:frame-load", this._hideSpinner)
    this.element.addEventListener("turbo:fetch-request-error", this._hideSpinner)
  }

  disconnect() {
    this.element.removeEventListener("turbo:before-fetch-request", this._showSpinner)
    this.element.removeEventListener("turbo:before-fetch-response", this._hideSpinner)
    this.element.removeEventListener("turbo:frame-load", this._hideSpinner)
    this.element.removeEventListener("turbo:fetch-request-error", this._hideSpinner)
  }

  showSpinner(event) {
    // Only show for requests targeting this frame, not Turbo Drive prefetch/navigation
    if (event.target !== this.element) return
    if (this.hasSpinnerTarget) this.spinnerTarget.classList.remove("hidden")
    if (this.hasSpinnerTarget) this.spinnerTarget.classList.add("flex")
    if (this.hasGridTarget) this.gridTarget.classList.add("opacity-40", "pointer-events-none")
  }

  hideSpinner(event) {
    if (event.target !== this.element) return
    if (this.hasSpinnerTarget) this.spinnerTarget.classList.add("hidden")
    if (this.hasSpinnerTarget) this.spinnerTarget.classList.remove("flex")
    if (this.hasGridTarget) this.gridTarget.classList.remove("opacity-40", "pointer-events-none")
  }

  showMoreLoading(event) {
    const btn = event.currentTarget
    const spinner = btn.querySelector(".show-more-spinner")
    const text = btn.querySelector(".show-more-text")
    if (spinner) spinner.classList.remove("hidden")
    if (text) text.textContent = "Loading…"
    btn.classList.add("pointer-events-none", "opacity-70")
  }
}
