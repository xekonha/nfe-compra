import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "periodoInicial", "periodoFinal"];

  connect() {
    this.modalTarget.classList.add("d-none");
    var max = new Date();
    this.periodoInicialTarget.setAttribute('max', max.toISOString().split('T')[0]);
    this.periodoFinalTarget.setAttribute('max', max.toISOString().split('T')[0]);
    max.setFullYear(max.getFullYear() - 5);
    this.periodoInicialTarget.setAttribute('min', max.toISOString().split('T')[0]);
    this.periodoFinalTarget.setAttribute('min', max.toISOString().split('T')[0]);
  }

  openModal(event) {
    let modalController = this.application.getControllerForElementAndIdentifier(
      this.modalTarget,
      "modal"
    );
    if (!this.periodoInicialTarget.value || this.periodoInicialTarget.value > this.periodoFinalTarget.value) {
      this.invalid(this.periodoInicialTarget);
      document.getElementById('periodoInvalido').classList.add('d-block');
    } else {
      this.valid(this.periodoInicialTarget);
    }

    if (!this.periodoFinalTarget.value) {
      this.invalid(this.periodoFinalTarget);
    } else {
      this.valid(this.periodoFinalTarget);
    }

    if (!this.periodoInicialTarget.classList.contains('is-invalid') && !this.periodoFinalTarget.classList.contains('is-invalid')) {
      modalController.open(this.periodoInicialTarget.value, this.periodoFinalTarget.value);
      document.getElementById('periodoInvalido').classList.remove('d-block');
    }
  }

  invalid(element) {
    element.classList.add('is-invalid');
  }

  valid(element) {
    element.classList.remove('is-invalid');
  }
}
