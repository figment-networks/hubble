// TODO: DRY these with other networks/cosmoslike. Up to `page/app-init`.
// Review which are actually needed
//= require jquery
//= require lodash/lodash.min
//= require moment/min/moment.min
//= require moment-timezone/builds/moment-timezone.min
//= require tooltipster/dist/js/tooltipster.bundle.min
//= require clipboard/dist/clipboard.min
//= require datatables/media/js/jquery.dataTables.min
//
// disable proper package for now since it's broken
// require chart.js/dist/Chart.min
//= require lib/Chart.min
//= require lib/chartjs-plugin-annotation.min
//
//= require bootstrap/dist/js/bootstrap.bundle.min
//
//= require lib/custom-tooltip
//= require lib/money
//= require lib/scale
//
//= require page/app-init
//
//= require page/polkadot/chain-show
//= require page/polkadot/block-show
//= require components/polkadot/validator-table
//= require components/polkadot/transactions-table
//= require components/polkadot/small-validator-total-stake-chart

// TODO: move these to shared when we have feature tests for Cosmos or during redesign
//= require page/cosmoslike/account-show
//= require components/cosmoslike/delegations-table
//= require components/cosmoslike/delegation-modal
