$(document).ready( function() {
  if( !_.includes(App.mode, 'faucet-show') ) { return }

  const button = $('.submit-button')
  const form = button.parents('form')

  form.on( 'submit', function( e ) { e.preventDefault() } )

  if( button.hasClass('disabled') ) { return }

  form.find('[name=fund_this_address]').on( 'input check', function() {
    const addr = $.trim( $(this).val() )
    const addrOk = addr.length != 45 || addr.slice(0,7) != App.config.prefixes.account_address
    if( addrOk ) { button.addClass('disabled').attr( 'disabled', 'disabled' ) }
    else { button.removeClass('disabled').removeAttr('disabled') }
  } ).trigger('check')

  if( form.length > 0 ) {
    grecaptcha.ready( function() {
      grecaptcha.render( button.get(0), {
        sitekey: button.data('sitekey'),
        callback: ( token ) => {
          const originalHtml = button.html()
          button.attr('disabled', 'disabled')
          button.html( "<span class='fas fa-spin fa-sync mr-2'></span> Please Wait...</span>" )

          function checkTx( url, doneUrl ) {
            $.ajax( { url, dataType: 'json', success: function( r ) {
              if( r.txhash ) { window.location = doneUrl }
              else { setTimeout( function() { checkTx( url, doneUrl ) }, 1000 ) }
            } } )
          }

          $.ajax( {
            url: form.attr('action'),
            type: form.attr('method'),
            dataType: 'json',
            data: form.serialize(),
            success: function( r ) {
              if( r.check ) { checkTx( r.check, r.redirect ) }
              else { window.location = r.redirect }
            },
            error: function() { window.location.reload() }
          } )
        }
      } )
    } )
  }
} )
