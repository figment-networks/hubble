# Hubble

This document covers usage info on how to run Hubble on your own servers.

Made with :heart: by<br/>
<a href='https://figment.io'><img alt='Figment' src='http://hubble.figment.io/assets/figment-logo-black.svg' height='32px' align='bottom' /></a>


## Dependencies

- Ruby 2.5+
- Node LTS
- Accessible PostgreSQL database.
- Memcached running on localhost.
- [PostMark](https://postmarkapp.com) account for email notifications.
- [Rollbar](https://rollbar.com) account for exception tracking.
- [libsecp25k1](https://github.com/bitcoin-core/secp256k1) (with `--enable-module-recovery` configure option)


## How to Setup Hubble

1. Fork this repo!
1. Generate encrypted secrets with `bin/rails secrets:setup`. Use `config/encrypted_secrets_quickstart.yml` to see what values are needed for what environments. Store `config/secrets.yml.enc` somewhere safe as it won't be committed.
1. Setup your instance:
    ```
    export HUBBLE_ADMIN_EMAIL=your@email.com
    export HUBBLE_HOST=ip-or-hostname-of-server
    export HUBBLE_RAILS_ENV=production
    export HUBBLE_KEY=~/.ssh/hubble-key.pem
    export HUBBLE_DOMAIN=hubble.your.domain
    export HUBBLE_REMOTE_USER=hubble
    ./setup/bootstrap.sh
    ```
    This automated process is meant for a Ubuntu 18.04 LTS install. We use AWS for this. Hubble uses HTTPS everywhere, so watch the output for when it asks you to create a DNS record.
1. Assuming that all goes well, there will be a URL you can visit to claim an admin account and setup a password/2FA.
1. In admin, create a new Cosmos chain with the chain name and gaiad RPC/LCD info. Make sure to click 'enable' at the top.
1. Next ssh into the machine, start `screen` and do the initial sync:
    ```
    cd /hubble/app/current
    bin/rake sync:cosmos:all events:cosmos:all stats:cosmos:all
    ```
    That will take a good long while depending on how long the chain you're syncing has been going for.
1. Once it's done, you will want to install the crontab entries. You can either run `bin/bundle exec whenever --update-crontab` right now, or just deploy again and they'll get installed automatically.


## How to Deploy

Use the appropriate generated deploy script if you used our setup scripts:

```
bin/deploy-{RAILS_ENV}.sh
```

Or do it manually:

```
RAILS_ENV=staging DEPLOY_USER=hubble DEPLOY_HOST=ip-or-hostname DEPLOY_KEYS=~/.ssh/hubble.pem bin/bundle cap staging deploy
```
