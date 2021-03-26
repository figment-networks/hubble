Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.precompile += %w[
  admin.js admin.scss
  errors.scss
  account.js account.scss
  cosmoslike.js cosmoslike.scss
  livepeer.js livepeer.scss
  oasis.scss oasis.js
  tezos.js tezos.scss
  near.js near.scss
  mina.js mina.scss
  celo.js celo.scss
  home.scss home.js
  cosmoslike.scss
  cosmoslike.js
  lib/figment-promo.bundled.js
  avalanche.scss
  avalanche.js
  near.scss
  near.js
  polkadot.scss
  polkadot.js
  prime.js prime.scss
  tezos.scss
  tezos.js
  mina.scss
  mina.js
]
