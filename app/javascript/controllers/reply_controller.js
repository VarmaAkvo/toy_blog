import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "form" ]

  changeVisibility() {
    if (this.formTarget.classList.contains('d-none') == true) {
      this.showForm();
    }
    else {
      this.hiddenForm();
    }
  }

  showForm() {
    this.formTarget.classList.remove('d-none')
  }

  hiddenForm() {
    this.formTarget.classList.add('d-none')
  }
}
