import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  add() {
    const template = document.querySelector("#synonym-template")
    const content = template.content.cloneNode(true)

    const timestamp = Date.now()

    content.querySelectorAll("input").forEach((input) => {
      input.name = input.name.replace("NEW_RECORD", timestamp)
      input.id = input.id.replace("NEW_RECORD", timestamp)
    })

    this.element.querySelector("#synonyms").appendChild(content)
  }

  remove(event) {
    const field = event.target.closest(".synonym-field")
    const destroyField = field.querySelector("input[name*='_destroy']")

    if (destroyField) {
      destroyField.value = "1"
      field.style.display = "none"
    } else {
      field.remove()
    }
  }
}
