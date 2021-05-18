if [ ! -f tmp/localhost.key ]; then
  echo "Generating local self-signed cert for dev..."
  openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout tmp/localhost.key -out tmp/localhost.crt
fi

bin/rails server -b 'ssl://0.0.0.0:3080?key=tmp/localhost.key&cert=tmp/localhost.crt'
