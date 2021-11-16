import { Controller } from "@hotwired/stimulus"

const urlParams = (new URL(document.location)).searchParams;

export default class extends Controller {
  static targets = ["searchBar", "tableHeader", "searchInput", "clipboard"];

  connect() {
    if (urlParams.get('query')) {
      $('.collapse').collapse('show');
    }
  }

  toggleSearch() {
    this.searchBarTarget.classList.add("show");
    this.tableHeaderTarget.classList.add("show");
    this.searchInputTarget.classList.add("focus-visible");
  }

  untoggleSearch() {
    this.searchBarTarget.classList.remove("show");
    this.tableHeaderTarget.classList.remove("show");
    this.searchInputTarget.classList.remove("focus-visible");
  }

  copy(event) {
    navigator.clipboard.writeText(this.clipboardTarget.innerText);
    document.getElementById("custom-tooltip").style.display = "inline";
    setTimeout(function () {
      document.getElementById("custom-tooltip").style.display = "none";
    }, 500);
    event.stopPropagation();
  }
}
