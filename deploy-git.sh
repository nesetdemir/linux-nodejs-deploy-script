#!/bin/bash
set -e

SERVER=username@server-ip-address
PORT="22"
PASSWORD="*********"
APP_DIR="~/"

### pm2'deki nodejs app name değiştirilmelidir. ###
## kurulum gerekli: sudo apt-get install sshpass ##
## kurulum gerekli: npm install pm2 -g ##

function run()
{
  echo "Running: $@"
  "$@"
}


tar czf nodejs.tar.gz --exclude='*.sh' $(git diff --name-only HEAD^)
sshpass -p $PASSWORD scp -P $PORT nodejs.tar.gz $SERVER:$APP_DIR
rm -rf nodejs.tar.gz

echo "---- Rotaboo Deploy Application ----"
run sshpass -p $PASSWORD ssh $SERVER "-p" $PORT << 'ENDSSH'
pm2 stop server
tar xf nodejs.tar.gz -C www
cd www
pm2 start server
ENDSSH
