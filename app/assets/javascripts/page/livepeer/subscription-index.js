$(document).ready( function() {
  if( !_.includes(App.mode, 'subscription-index') ) { return }

  let dirty = false
  let submitting = false

  window.addEventListener('beforeunload', ( e ) => {
    if( dirty && !submitting ) {
      dialogText = 'Your changes have not been saved! Are you sure you want to leave this page?'
      e.returnValue = dialogText
      return dialogText
    }
    else {
      return undefined
    }
  } )

  $('.subscription-form')
    .on( 'change', 'input', () => dirty = true )
    .on( 'submit', () => submitting = true )
} )
