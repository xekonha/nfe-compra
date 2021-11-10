import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["inicio", "fim"];
  open(periodoInicial, periodoFinal) {
    this.inicioTarget.innerHTML = periodoInicial.split('-').reverse().join('/');
    this.fimTarget.innerHTML = periodoFinal.split('-').reverse().join('/');
    this.element.classList.remove("d-none");
  }

  close() {
    this.element.classList.add("d-none");
  }
}
