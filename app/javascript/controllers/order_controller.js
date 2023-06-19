import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {
  }

  ingredientDOM () {
    const div = document.createElement('div')

    div.innerHTML = '<div>add:</div>'
    this.sessionNewItem().add.forEach(ingredient => {
      div.innerHTML += `<div>${ingredient}</div>`
    })

    div.innerHTML += '<div>remove:</div>'
    this.sessionNewItem().remove.forEach(ingredient => {
      div.innerHTML += `<div>${ingredient}</div>`
    })

    return div
  }

  itemDOM () {
    const div = document.createElement('div')
    const item = this.sessionNewItem()

    div.innerHTML = `<div>${item.name} ${item.size} - €${item.price}</div>`

    return div
  }

  renderItemPreview () {
    const element = this.itemDOM()
    const ingredient = this.ingredientDOM()

    document
      .getElementById('preview')
      .replaceChildren(element)
    document
      .getElementById('new-item')
      .replaceChildren(ingredient)
  }

  sessionOrder () {
    return JSON.parse(sessionStorage.getItem('order')) || this.noOrder()
  }

  sessionItem () {
    return JSON.parse(sessionStorage.getItem('item'))
  }

  addIngredient (event) {
    const ingredient = event.target.dataset
    const item = this.sessionNewItem()

    if (!item.add.includes(ingredient.ingredient)) {
      item.add.push(`${ingredient.ingredient}`)
    }

    this.setSessionNewItem(item)
    this.renderItemPreview()
  }

  removeIngredient (event) {
    const ingredient = event.target.dataset
    const item = this.sessionNewItem()

    if (!item.remove.includes(ingredient.type)) {
      item.remove.push(ingredient.type)
    }

    this.setSessionNewItem(item)
    this.renderItemPreview()
  }

  pickPizzaSize (event) {
    const pizza = event.target.dataset
    const item = this.attributesForPizza(pizza)

    this.setSessionNewItem(item)
    this.renderItemPreview()
  }

  attributesForPizza (pizza) {
    if (pizza) {
      return {
        name: pizza.name,
        size: pizza.size,
        price: pizza.price,
        multiplier: pizza.multiplier,
        add: [],
        remove: []
      }
    } else {
      return this.noPizza()
    }
  }

  setSessionNewItem (item) {
    sessionStorage.setItem('item', JSON.stringify(item))
  }

  setSessionDiscountCode (code) {
    const order = this.sessionOrder()
    order.discountCode = code

    this.setSessionOrder(order)
  }

  setSessionPromotionCodes (codes) {
    const order = this.sessionOrder()
    order.promotionCodes = codes

    this.setSessionOrder(order)
  }

  noPizza () {
    return {
      name: '',
      size: '',
      price: '',
      add: [],
      remove: []
    }
  }

  noOrder () {
    return {
      items: [],
      promotionCodes: [],
      discountCode: null
    }
  }

  sessionNewItem () {
    return this.sessionItem() || this.noPizza()
  }

  addPizza () {
    const item = this.sessionNewItem()
    const order = this.sessionOrder()

    order.items.push(item)

    this.setSessionOrder(order)
    this.setSessionNewItem(this.noPizza())
    this.renderItemPreview()
    console.log(order)
  }

  setSessionOrder (order) {
    sessionStorage.setItem('order', JSON.stringify(order))
  }

  submitOrder () {
    const order = this.sessionOrder()
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content
    const url = '/orders'
    const body = JSON.stringify({ order })

    fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
      },
      redirect: 'follow',
      body
    })
      .then(response => response.json())
      .then(_data => {
        sessionStorage.clear()
        location.href = '/orders/queue'
      })
  }

  promotionCodes (event) {
    const promotionCodesList = event.target.value.split(', ')

    this.setSessionPromotionCodes(promotionCodesList)
  }

  discountCode (event) {
    const code = event.target.value

    this.setSessionDiscountCode(code)
  }
}
