import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  addIngredient (event) {
    const ingredient = event.target.dataset

    const sessionOrder = JSON.parse(sessionStorage.getItem('order'))
    const order = sessionOrder || {
      items: [],
      promotionCodes: [],
      discountCode: null
    }
    order.items.push(this.attributesForIngredient(ingredient))

    sessionStorage.setItem('order', JSON.stringify(order))
    this.renderOrderPreview()
  }
}
