import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["chevron"];

  toggleAccordion(event) {
    if(event.currentTarget.getAttribute('aria-expanded') == 'true') {
      this.chevronTarget.classList.remove('fa-chevron-up');
    } else {
      this.chevronTarget.classList.add('fa-chevron-up');
    }
  }
}
