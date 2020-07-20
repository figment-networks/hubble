class DelegatorListForm {
  constructor( container ) {
    this.container = container
  }

  render() {
    const delegatorInputs = this.container.find('.delegator input')
    const addDelegatorButton = this.container.find('.add-delegator')
    const delegators = this.container.find('.delegators')

    this.applyInputMask(delegatorInputs)

    addDelegatorButton.on( 'click', ( event ) => {
      event.preventDefault()

      const template = this.container.find('.delegator-template > *')
      const newDelegator = template.clone()

      this.applyInputMask(newDelegator.find('input'))

      newDelegator.insertBefore(addDelegatorButton)
      newDelegator.find('input').focus()
    } )

    delegators.on( 'click', '.remove-delegator', ( event ) => {
      event.preventDefault()

      const delegator = $(event.target).parent().parent()

      delegator.remove()
    } )
  }

  applyInputMask(element) {
    element.inputmask( {
      regex: '[0-9A-Fa-f]{40}',
      casing: 'upper',
      onBeforePaste: (v) => v.replace(/^0x/i, '')
    } )
  }
}

window.App.Livepeer.DelegatorListForm = DelegatorListForm
