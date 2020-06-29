import { DEFAULT_MEMO, Ledger } from './ledger.js';
class GovProposalSubmitModal {
  constructor( el ) {
    this.GAS_WANTED = 150000
    this.GAS_PRICE = 0.025
    this.MEMO = 'Submit, deposit and vote on proposals with Puzzle - https://puzzle.secretnodes.org'

    this.modal = el
    this.reset()
    this.modal.on( 'hidden.bs.modal', () => this.reset() )

    let triggeredGAEvent =  false
    this.modal.on( 'shown.bs.modal', async () => {
      this.reset()

      if( !triggeredGAEvent ) { ga('send', 'event', 'gov-proposal-submit', 'started') }

      this.ledger = new Ledger({ testModeAllowed: false });

      await this.ledger.setupConnection();

      const setupError = null;
      if( setupError ) {
        this.modal.find('.proposal-step').hide()
        this.modal.find('.step-error')
          .find('.proposal-error').text(setupError == "" ? "Unknown error." : setupError)
          .end().show()
        return
      }

      this.modal.find('.step-setup').hide()

      this.modal.find('.modal-dialog').addClass('modal-lg')
      this.modal.find('.step-new-proposal')
        .find('.account-balance').text( `${this.ledger.scaledBalance} ${App.config.denom}` ).end()
        .find('.account-address').html( this.ledger.publicAddress ).end()
        .find('.transaction-fee').text( `${this.transactionFee()} ${App.config.denom}` ).end()
        .show()

      this.modal.find('.set-all').click( ( e ) => {
        e.preventDefault()
        this.modal.find('.proposal-deposit-amount').val( this.fullDeposit(false) ).trigger('set-to-max')
      } )

      this.modal.find('.proposal-title').on( 'input', ( e ) => {
        this.modal.find('.title-error').toggle( $.trim( $(e.currentTarget).val() ).length == 0 )
      } )
      this.modal.find('.proposal-description').on( 'input', ( e ) => {
        this.modal.find('.description-error').toggle( $.trim( $(e.currentTarget).val() ).length == 0 )
      } )

      this.modal.find('.proposal-deposit-amount').on( 'input set-to-max', ( e ) => {
        const amount = parseFloat( $(e.currentTarget).val() )
        if( isNaN( amount ) ) {
          this.modal.find('.amount-warning').hide()
          this.modal.find('.amount-error').hide()
          this.modal.find('.proposal-form').data( 'disabled', true )
          this.modal.find('.submit-proposal').attr( 'disabled', 'disabled' )
          this.modal.find('.transaction-total').html( '&mdash;' )
          return
        }

        this.modal.find('.transaction-total').text( `${this.total(amount)} ${App.config.denom}` )

        if( !this.checkDepositAmount( amount ) ) {
          this.modal.find('.amount-warning').hide()
          this.setDepositAmount( null )
          const msg = amount == 0 ?
            `You can't deposit <tt>0 ${App.config.denom}</tt>...` :
            `The amount to deposit must take transaction fees into account.<br/><b>Max: <tt class='text-md'>${this.ledger.accountBalance} ${App.config.denom}</tt></b>`
          this.modal.find('.amount-error').html(msg).show()
          this.modal.find('.submit-proposal').attr( 'disabled', 'disabled' )
        }
        else {
          if( amount >= this.ledger.accountBalance - this.transactionFee() ) {
            const msg = `It is recommended to leave some ${App.config.denom} in your account to pay fees on future transactions!`
            this.modal.find('.amount-warning').html(msg).show()
          }
          else {
            this.modal.find('.amount-warning').hide()
          }
          this.setDepositAmount( amount )
          this.modal.find('.amount-error').hide()
          this.modal.find('.proposal-form').data( 'disabled', false )
          this.modal.find('.submit-proposal').removeAttr( 'disabled' )
        }
      } )

      this.modal.find('.proposal-form').submit( async ( e ) => {
        e.preventDefault()

        if( $(e.currentTarget).data('disabled') ) { return }

        this.modal.find('.proposal-step').hide()
        this.modal.find('.modal-dialog').removeClass('modal-lg')
        this.modal.find('.step-confirm').show()

        const txObject = Ledger.createSubmitProposal(
          this.ledger.txContext, 
          $.trim( $('.proposal-title').val() ), 
          $.trim( $('.proposal-description').val() ),
          this.depositAmount.toString()
        )
        let sign = await this.ledger.buildAndSign(this.ledger.txContext, txObject, this.GAS_WANTED.toString());

        this.modal.find('.transaction-json').text(
          JSON.stringify( txObject, undefined, 2 )
        )

        const txSignature = Ledger.applySignature(sign.newTxObject, this.ledger.txContext, sign.sigArray);
        let broadcastError = null
        if( txSignature ) {
          const broadcastResult = await this.ledger.broadcastTransaction( txSignature )
          if( broadcastResult.ok ) {
            this.modal.find('.proposal-step').hide()
            this.modal.find('.view-transaction').attr( 'href', App.config.viewTxPath.replace('TRANSACTION_HASH', broadcastResult.txhash) )
            this.modal.find('.step-complete').show()
            ga('send', 'event', 'gov-proposal-submit', 'completed')
            return
          }
          else {
            broadcastError = broadcastResult.error_message
          }
        }

        ga('send', 'event', 'gov-proposal-submit', 'failed')
        this.modal.find('.proposal-step').hide()
        this.modal.find('.step-error')
          .find('.proposal-error').text(this.ledger.signError || broadcastError || "Unknown error")
          .end().show()
      } )

      this.modal.find('.show-transaction-json').click( ( e ) => {
        $(e.currentTarget).hide()
        this.modal.find('.transaction-json-container').show()
      } )
    } )
  }

  reset() {
    this.modal.find('.modal-dialog').removeClass('modal-lg')
    this.modal.find('.proposal-step').hide()
    this.modal.find('.step-setup').show()
    this.modal.find('.proposal-deposit-amount').val('').off('input')
    this.modal.find('.proposal-title').val('').off('input')
    this.modal.find('.proposal-description').val('').off('input')
    this.modal.find('.set-all').off('click')
    this.modal.find('.proposal-form').off('submit').data( 'disabled', true )
    this.modal.find('.submit-proposal').attr( 'disabled', 'disabled' )
    this.modal.find('.show-transaction-json').off('click').show()
    this.modal.find('.transaction-json-container').hide()
    this.modal.find('.amount-error').hide()
    this.modal.find('.amount-warning').hide()
    this.modal.find('.title-error').hide()
    this.modal.find('.description-error').hide()
    this.modal.find('.view-transaction').attr( 'href', '' )
  }

  proposalTransactionObject() {
    return {
      msg: [
        {
          type: 'cosmos-sdk/MsgSubmitProposal',
          value: {
            title: $.trim( $('.proposal-title').val() ),
            description: $.trim( $('.proposal-description').val() ),
            proposal_type: 'Text',
            proposer: this.ledger.publicAddress,
            initial_deposit: [
              { denom: App.config.remoteDenom, amount: this.depositAmount.toString() }
            ]
          }
        }
      ],
      fee: {
        amount: [
          {
            denom: App.config.remoteDenom,
            amount: this.transactionFee( false ).toString()
          }
        ],
        gas: this.GAS_WANTED.toString()
      },
      signatures: null,
      memo: this.MEMO
    }
  }

  transactionFee( scale=true ) {
    return (this.GAS_WANTED * this.GAS_PRICE) / (scale ? App.config.remoteScaleFactor : 1)
  }

  total( amount ) {
    return ((amount * App.config.remoteScaleFactor) + this.transactionFee(false)) / App.config.remoteScaleFactor
  }

  fullDeposit( scale=true ) {
    return App.config.depositMinimum / App.config.remoteScaleFactor
  }

  checkDepositAmount( amount ) {
    return amount > 0 && amount <= this.ledger.accountBalance
  }

  setDepositAmount( amount ) {
    this.depositAmount = amount * App.config.remoteScaleFactor
  }
}

App.Common.GovProposalSubmitModal = GovProposalSubmitModal
