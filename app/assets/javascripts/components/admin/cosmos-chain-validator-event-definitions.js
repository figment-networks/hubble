const CAN_DELETE = [
  'n_of_m',
  'n_consecutive'
]

const BADGE_NAMES = {
  voting_power_change: 'VOTING POWER CHANGES',
  active_set_inclusion: 'ACTIVE SET ADDED/REMOVED',
  n_of_m: 'MISSED N of M PRECOMMITS',
  n_consecutive: 'MISSED N CONSECUTIVE PRECOMMITS'
}

const EDIT_TEMPLATES = {
  voting_power_change: _.template(`X`),
  active_set_inclusion: _.template(`X`),
  n_of_m: _.template(`
    <span class='fa fa-arrow-right mr-3 text-muted'></span>
    <input type='text' autocomplete='off' class='form-control form-control-sm w-15 mr-1' name='<%= namespace %>_chain[validator_event_defs][<%= index %>][n]' value='<%= data.n %>' placeholder='N' />
    <small class='text-muted ml-1 mr-1'>of</small>
    <input type='text' autocomplete='off' class='form-control form-control-sm w-15 ml-1' name='<%= namespace %>_chain[validator_event_defs][<%= index %>][m]' value='<%= data.m %>' placeholder='M' />
  `),
  n_consecutive: _.template(`
    <span class='fa fa-arrow-right mr-3 text-muted'></span>
    <input type='text' autocomplete='off' class='form-control form-control-sm w-50' name='<%= namespace %>_chain[validator_event_defs][<%= index %>][n]' value='<%= data.n %>' placeholder='N' />
  `)
}

const INFO_TEMPLATES = {
  voting_power_change: _.template(``),
  active_set_inclusion: _.template(``),
  n_of_m: _.template(`
    <span class='fa fa-arrow-right mr-2 text-muted'></span>
    <span class='text-lg'><%= data.n %></span>
    <small class='text-muted ml-1 mr-1'>of</small>
    <span class='text-lg'><%= data.m %></span>
  `),
  n_consecutive: _.template(`
    <span class='fa fa-arrow-right mr-2 text-muted'></span>
    <span class='text-lg'><%= data.n %></span>
  `)
}

const DEFINITION_TEMPLATE = _.template(`
  <div class='definition-item p-0 pt-1 pb-1 d-flex align-items-center'>
    <input type='hidden' name='<%= namespace %>_chain[validator_event_defs][<%= index %>][unique_id]' value='<%= data.unique_id %>' />
    <input type='hidden' name='<%= namespace %>_chain[validator_event_defs][<%= index %>][kind]' value='<%= data.kind %>' />
    <input type='hidden' name='<%= namespace %>_chain[validator_event_defs][<%= index %>][height]' value='<%= data.height %>' disabled />

    <div class='controls d-flex align-items-center'>
      <% if( isNew ) { %>
        <div class='btn-group event-kind-buttons mr-1'>
          <button class='btn btn-sm btn-outline-primary <%= data.kind == 'n_of_m' ? 'active' : '' %>' data-threshold-kind='n_of_m'>N of M</button>
          <button class='btn btn-sm btn-outline-primary <%= data.kind == 'n_consecutive' ? 'active' : '' %>' data-threshold-kind='n_consecutive'>N Consec.</button>
        </div>
      <% } else { %>
        <div class='text-lg text-primary'>
          <%= BADGE_NAMES[data.kind] %>
        </div>
      <% } %>

      <div class='current-height d-flex align-items-center ml-2'>
        <span class='fa fa-arrow-right mr-2 text-muted'></span>
        <button class='tooltip-target w-auto height-tooltip-target' data-toggle='tooltip' title='<%- HEIGHT_INFO_TEMPLATE( { height: data.height, canChangeHeight: canChangeHeight } ) %>'>
          <span class='fa fa-angle-double-up mr-1'></span>
          <span class='height-display'><%= data.height || 0 %></span>
        </button>
      </div>

      <div class='inputs d-flex align-items-center ml-2'>
        <% if( isNew ) { %>
          <%= EDIT_TEMPLATES[data.kind]( { index: index, data: data, namespace: namespace } ) %>
        <% } else { %>
          <%= INFO_TEMPLATES[data.kind]( { index: index, data: data, namespace: namespace } ) %>
        <% } %>
      </div>
    </div>
    <div class='ml-auto d-flex align-items-center'>
      <% if( _.includes(CAN_DELETE, data.kind) ) { %>
        <button class='action-remove-event-definition btn btn-sm btn-danger'><span class='fa fa-times'></span></button>
      <% } %>
    </div>
  </div>
`)

const HEIGHT_INFO_TEMPLATE = _.template(`
  <small class='mr-1 text-muted'>Height:</small>
  <div class='d-flex align-items-center'>
    <% if( canChangeHeight ) { %>
      <input type='text' class='form-control' autocomplete='off' style='width: 150px;' value='<%= height || 0 %>' placeholder='<%= height || 0 %>' />
    <% } else { %>
      <div class='text-lg mr-3 technical'><%= height || 0 %></div>
    <% } %>
    <button class='btn btn-sm btn-warning ml-1 action-edit-height' <%= canChangeHeight ? '' : 'disabled' %>>override</button>
  </div>
`)

$(document).ready( function() {
  const container = $('.validator-event-defs-list')
  if( container.length == 0 ) { return }

  function renderItem( bindings ) {
    bindings.isNew = bindings.isNew || false
    bindings.canChangeHeight = !App.config.chainIsSyncing || bindings.isNew
    bindings.namespace = App.config.namespace.toLowerCase()

    // generate unique id if we don't have one
    if( !bindings.data.unique_id ) { bindings.data.unique_id = uuid() }

    const html = DEFINITION_TEMPLATE( bindings )
    const el = $(html)

    el.find('.height-tooltip-target').click( (e) => e.preventDefault() ).tooltipster( {
      contentAsHTML: true,
      interactive: true,
      arrow: false,
      theme: 'tooltipster-hubble',
      side: 'top',
      viewportAware: true,
      delay: 25,
      maxWidth: 275,
      onlyOne: true,
      trigger: 'custom',
      triggerOpen: { click: true },
      triggerClose: { click: true },
      functionReady: function( instance, helper ) {
        const tooltip = $(helper.tooltip)
        tooltip.on( 'click', '.action-edit-height', function( e ) {
          const newHeight = tooltip.find('input').val()
          el.find('[name*=height]').val( newHeight ).removeAttr('disabled')
          el.find('.height-display').text( newHeight )
          instance.close()
        } )
      }
    } )
    return el
  }

  //
  // INITIAL DATA LOAD
  //
  _.each( container.data('defs') || [], (data, index) => {
    const bindings = { data, index }
    container.append( renderItem( bindings ) )
  } )


  //
  // SAVE BUTTON
  //
  const saveButton = $('.action-event-definitions-save')
  saveButton.click( function( e ) {
    e.preventDefault()
    saveButton.attr( { disabled: 'disabled' } )
    $('#chain-validator-event-defs-form').get(0).submit()
  } )


  //
  // ADD NEW DEF BUTTON
  //
  $('.action-add-new-validator-event-definition').click( function( e ) {
    const button = $(e.currentTarget)
    const newItem = renderItem( {
      index: container.children().length,
      data: { kind: 'n_of_m', height: 0 },
      isNew: true
    } )
    container.append( newItem )
    saveButton.removeClass('d-none')
  } )


  //
  // REMOVE DEF BUTTON
  //
  container.on( 'click', '.action-remove-event-definition', function( e ) {
    $(e.currentTarget).parents('.definition-item').remove()
    saveButton.removeClass('d-none')
  } )


  //
  // SWITCH THRESHOLD KIND BUTTONS
  //
  container.on( 'click', '.event-kind-buttons button', function( e ) {
    e.preventDefault()
    const button = $(e.currentTarget)
    const row = button.parents('.definition-item')
    const kind = button.data('threshold-kind')
    row.find('[name*=kind]').val( kind )
    row.find('.inputs').html( EDIT_TEMPLATES[kind]( { index: row.index(), data: {}, namespace: App.config.namespace.toLowerCase() } ) )
    button.siblings().removeClass('active').end().addClass('active')
    saveButton.removeClass('d-none')
  } )


  //
  // EDITING PARAMETERS
  //
  container.on( 'keyup', '.inputs input', function( e ) {
    saveButton.removeClass('d-none')
  } )
} )
