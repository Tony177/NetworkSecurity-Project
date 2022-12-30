#!/usr/bin/env bash
cd /home/node/app/site
npm install --quiet 
../wait-for-it.sh MySQLServer:3306 -- npm run start